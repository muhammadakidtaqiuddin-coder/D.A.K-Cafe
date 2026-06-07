import 'package:flutter/material.dart';
import 'package:dak_cafe/db_helper.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({super.key});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  Map<String, List<Map<String, dynamic>>> _data = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = await DBHelper.database;
    final tables = ['users', 'categories', 'products', 'gift_cards', 'promotions', 'orders'];
    final result = <String, List<Map<String, dynamic>>>{};
    for (final t in tables) {
      result[t] = await db.query(t);
    }
    setState(() {
      _data = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DB Debug Viewer'),
        backgroundColor: const Color(0xFF1E2A78),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _loading = true);
              _load();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: _data.entries.map((entry) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Table header
                        Row(
                          children: [
                            const Icon(Icons.table_chart,
                                color: Color(0xFF1E2A78), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              entry.key,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xFF1E2A78)),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8EBF8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${entry.value.length} rows',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF1E2A78),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),

                        // Rows
                        entry.value.isEmpty
                            ? const Text('No data',
                                style: TextStyle(color: Colors.grey))
                            : Column(
                                children: entry.value
                                    .asMap()
                                    .entries
                                    .map((rowEntry) {
                                  final rowIndex = rowEntry.key;
                                  final row = rowEntry.value;
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: rowIndex % 2 == 0
                                          ? const Color(0xFFF7F7F7)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.grey.shade200),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: row.entries.map((col) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  col.key,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${col.value}',
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                }).toList(),
                              ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}