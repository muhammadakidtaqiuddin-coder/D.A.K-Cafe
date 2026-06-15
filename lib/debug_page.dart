import 'package:flutter/material.dart';
import 'package:dak_cafe/db_helper.dart';

// ─── Schema definitions ────────────────────────────────────────────────────────
// Each field: { 'key': String, 'label': String, 'type': 'text'|'number'|'bool' }
// 'id' and auto-timestamps are excluded from forms.

const _tableSchemas = <String, List<Map<String, dynamic>>>{
  'users': [
    {'key': 'username', 'label': 'Username', 'type': 'text'},
    {'key': 'password', 'label': 'Password', 'type': 'text'},
    {'key': 'name',     'label': 'Name',     'type': 'text'},
    {'key': 'email',    'label': 'Email',    'type': 'text'},
  ],
  'categories': [
    {'key': 'title', 'label': 'Title', 'type': 'text'},
  ],
  'products': [
    {'key': 'category_id', 'label': 'Category ID', 'type': 'number'},
    {'key': 'name',        'label': 'Name',        'type': 'text'},
    {'key': 'price',       'label': 'Price',       'type': 'text'},
  ],
  'gift_cards': [
    {'key': 'title',     'label': 'Title',     'type': 'text'},
    {'key': 'subtitle',  'label': 'Subtitle',  'type': 'text'},
    {'key': 'purchased', 'label': 'Purchased', 'type': 'bool'},
  ],
  'promotions': [
    {'key': 'title',       'label': 'Title',       'type': 'text'},
    {'key': 'description', 'label': 'Description', 'type': 'text'},
    {'key': 'tag',         'label': 'Tag',         'type': 'text'},
  ],
  'orders': [
    {'key': 'drink_name',     'label': 'Drink Name',     'type': 'text'},
    {'key': 'size',           'label': 'Size',           'type': 'text'},
    {'key': 'temperature',    'label': 'Temperature',    'type': 'text'},
    {'key': 'sugar_level',    'label': 'Sugar Level',    'type': 'number'},
    {'key': 'quantity',       'label': 'Quantity',       'type': 'number'},
    {'key': 'price_per_item', 'label': 'Price/Item',     'type': 'number'},
    {'key': 'service_fee',    'label': 'Service Fee',    'type': 'number'},
    {'key': 'total',          'label': 'Total',          'type': 'number'},
    {'key': 'customer_name',  'label': 'Customer Name',  'type': 'text'},
    {'key': 'customer_phone', 'label': 'Customer Phone', 'type': 'text'},
    {'key': 'notes',          'label': 'Notes',          'type': 'text'},
  ],
  'reviews': [
    {'key': 'drink_name',    'label': 'Drink Name',    'type': 'text'},
    {'key': 'rating',        'label': 'Rating (1–5)',  'type': 'number'},
    {'key': 'reviewer_name', 'label': 'Reviewer Name', 'type': 'text'},
    {'key': 'comment',       'label': 'Comment',       'type': 'text'},
  ],
};

// ─── Colours ──────────────────────────────────────────────────────────────────

const _brand = Color(0xFF1E2A78);
const _brandLight = Color(0xFFE8EBF8);
const _danger = Color(0xFFD32F2F);

// ─── DebugPage ────────────────────────────────────────────────────────────────

class DebugPage extends StatefulWidget {
  const DebugPage({super.key});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  Map<String, List<Map<String, dynamic>>> _data = {};
  bool _loading = true;

  final _tables = [
    'users', 'categories', 'products',
    'gift_cards', 'promotions', 'orders', 'reviews',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final db = await DBHelper.database;
    final result = <String, List<Map<String, dynamic>>>{};
    for (final t in _tables) {
      result[t] = await db.query(t);
    }
    setState(() {
      _data = result;
      _loading = false;
    });
  }

  // ── Delete ──────────────────────────────────────────────────────────────────

  Future<void> _deleteRow(String table, int id) async {
    final confirmed = await _confirmDialog(
      title: 'Delete row',
      message: 'Delete row #$id from "$table"? This cannot be undone.',
    );
    if (!confirmed) return;

    await DBHelper.deleteRow(table, id);
    _showSnack('Row #$id deleted from $table.');
    _load();
  }

  // ── Add ─────────────────────────────────────────────────────────────────────

  Future<void> _addRow(String table) async {
    final schema = _tableSchemas[table];
    if (schema == null) return;

    final data = await _showFormDialog(
      title: 'Add row to "$table"',
      schema: schema,
      initial: {},
    );
    if (data == null) return;

    // Auto-set created_at for tables that need it
    if (table == 'orders' || table == 'reviews') {
      data['created_at'] = DateTime.now().toIso8601String();
    }

    await DBHelper.insertRow(table, data);
    _showSnack('Row added to $table.');
    _load();
  }

  // ── Edit ────────────────────────────────────────────────────────────────────

  Future<void> _editRow(String table, Map<String, dynamic> row) async {
    final schema = _tableSchemas[table];
    if (schema == null) return;

    final data = await _showFormDialog(
      title: 'Edit row #${row['id']} in "$table"',
      schema: schema,
      initial: row,
    );
    if (data == null) return;

    await DBHelper.updateRow(table, row['id'] as int, data);
    _showSnack('Row #${row['id']} updated.');
    _load();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Dialogs
  // ─────────────────────────────────────────────────────────────────────────────

  Future<bool> _confirmDialog({
    required String title,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: _danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Shows a form dialog built from [schema].
  /// Returns the filled map or null if cancelled.
  Future<Map<String, dynamic>?> _showFormDialog({
    required String title,
    required List<Map<String, dynamic>> schema,
    required Map<String, dynamic> initial,
  }) async {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => _CrudFormDialog(
        title: title,
        schema: schema,
        initial: initial,
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DB Debug Viewer'),
        backgroundColor: _brand,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: _data.entries.map((entry) {
                return _TableCard(
                  tableName: entry.key,
                  rows: entry.value,
                  onAdd: () => _addRow(entry.key),
                  onEdit: (row) => _editRow(entry.key, row),
                  onDelete: (id) => _deleteRow(entry.key, id),
                );
              }).toList(),
            ),
    );
  }
}

// ─── TableCard ────────────────────────────────────────────────────────────────

class _TableCard extends StatelessWidget {
  const _TableCard({
    required this.tableName,
    required this.rows,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final String tableName;
  final List<Map<String, dynamic>> rows;
  final VoidCallback onAdd;
  final void Function(Map<String, dynamic> row) onEdit;
  final void Function(int id) onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Row(
              children: [
                const Icon(Icons.table_chart, color: _brand, size: 20),
                const SizedBox(width: 8),
                Text(
                  tableName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: _brand,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _brandLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${rows.length} rows',
                    style: const TextStyle(
                      fontSize: 12,
                      color: _brand,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // ── Add button ──────────────────────────────────────────────
                Tooltip(
                  message: 'Add row',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: onAdd,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _brand,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),

            // ── Rows ────────────────────────────────────────────────────────
            if (rows.isEmpty)
              const Text('No data', style: TextStyle(color: Colors.grey))
            else
              Column(
                children: rows.asMap().entries.map((rowEntry) {
                  final rowIndex = rowEntry.key;
                  final row = rowEntry.value;
                  return _RowTile(
                    row: row,
                    isEven: rowIndex % 2 == 0,
                    onEdit: () => onEdit(row),
                    onDelete: () {
                      final id = row['id'];
                      if (id is int) onDelete(id);
                    },
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── RowTile ──────────────────────────────────────────────────────────────────

class _RowTile extends StatelessWidget {
  const _RowTile({
    required this.row,
    required this.isEven,
    required this.onEdit,
    required this.onDelete,
  });

  final Map<String, dynamic> row;
  final bool isEven;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(10, 8, 4, 8),
      decoration: BoxDecoration(
        color: isEven ? const Color(0xFFF7F7F7) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Fields ──────────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: row.entries.map((col) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 110,
                        child: Text(
                          col.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${col.value}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // ── Action buttons ───────────────────────────────────────────────
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                color: _brand,
                tooltip: 'Edit',
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                color: _danger,
                tooltip: 'Delete',
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── CrudFormDialog ───────────────────────────────────────────────────────────

class _CrudFormDialog extends StatefulWidget {
  const _CrudFormDialog({
    required this.title,
    required this.schema,
    required this.initial,
  });

  final String title;
  final List<Map<String, dynamic>> schema;
  final Map<String, dynamic> initial;

  @override
  State<_CrudFormDialog> createState() => _CrudFormDialogState();
}

class _CrudFormDialogState extends State<_CrudFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers;
  late final Map<String, bool> _boolValues;

  @override
  void initState() {
    super.initState();
    _controllers = {};
    _boolValues = {};

    for (final field in widget.schema) {
      final key = field['key'] as String;
      final type = field['type'] as String;
      final initialVal = widget.initial[key];

      if (type == 'bool') {
        _boolValues[key] = (initialVal == 1 || initialVal == true);
      } else {
        _controllers[key] =
            TextEditingController(text: initialVal != null ? '$initialVal' : '');
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final result = <String, dynamic>{};
    for (final field in widget.schema) {
      final key = field['key'] as String;
      final type = field['type'] as String;

      if (type == 'bool') {
        result[key] = _boolValues[key] == true ? 1 : 0;
      } else if (type == 'number') {
        final raw = _controllers[key]!.text.trim();
        result[key] = num.tryParse(raw) ?? 0;
      } else {
        result[key] = _controllers[key]!.text.trim();
      }
    }

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title, style: const TextStyle(fontSize: 15)),
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      content: SizedBox(
        width: 340,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.schema.map((field) {
                final key = field['key'] as String;
                final label = field['label'] as String;
                final type = field['type'] as String;

                if (type == 'bool') {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Text(label, style: const TextStyle(fontSize: 13)),
                        const Spacer(),
                        Switch(
                          value: _boolValues[key] ?? false,
                          activeColor: _brand,
                          onChanged: (v) => setState(() => _boolValues[key] = v),
                        ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextFormField(
                    controller: _controllers[key],
                    keyboardType: type == 'number'
                        ? const TextInputType.numberWithOptions(decimal: true)
                        : TextInputType.text,
                    decoration: InputDecoration(
                      labelText: label,
                      labelStyle: const TextStyle(fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 13),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return '$label is required';
                      }
                      if (type == 'number' && num.tryParse(v.trim()) == null) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _brand,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: _submit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
