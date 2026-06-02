import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String selectedSize = 'Medium';
  String selectedTemp = 'Iced';
  double sugarLevel = 50;
  int quantity = 1;
  bool _isSubmitting = false;

  // Selected drink
  int _selectedDrinkIndex = 0;
  final List<Map<String, dynamic>> _drinks = [
    {'name': 'Iced CEO Americano', 'price': 6.90, 'icon': Icons.coffee},
    {'name': 'Matcha Cloud Frappé', 'price': 15.20, 'icon': Icons.local_cafe},
    {'name': 'Iced French Vanilla Latte', 'price': 11.90, 'icon': Icons.emoji_food_beverage},
    {'name': 'Thai Milk Tea', 'price': 10.90, 'icon': Icons.coffee_maker},
  ];

  final List<String> sizes = ['Small', 'Medium', 'Large'];
  final List<String> temps = ['Hot', 'Iced'];

  double get _itemPrice => _drinks[_selectedDrinkIndex]['price'] as double;
  double get _subtotal => _itemPrice * quantity;
  double get _total => _subtotal + 0.50;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1)); // simulate network
    setState(() => _isSubmitting = false);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text('Order Placed!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2A78))),
            const SizedBox(height: 8),
            Text(
              '${_drinks[_selectedDrinkIndex]['name']}\n$selectedSize · $selectedTemp · Sugar ${sugarLevel.toInt()}%\nQty: $quantity · Total: RM ${_total.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                // Reset form
                nameController.clear();
                phoneController.clear();
                notesController.clear();
                setState(() {
                  selectedSize = 'Medium';
                  selectedTemp = 'Iced';
                  sugarLevel = 50;
                  quantity = 1;
                  _selectedDrinkIndex = 0;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E2A78),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: const Center(
                child: Text('Place an Order',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2A78))),
              ),
            ),

            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // DRINK PICKER
                      _SectionLabel(label: 'Select Drink'),
                      SizedBox(
                        height: 110,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _drinks.length,
                          itemBuilder: (ctx, i) {
                            final selected = _selectedDrinkIndex == i;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedDrinkIndex = i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 100,
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: selected ? const Color(0xFF1E2A78) : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: selected ? const Color(0xFF1E2A78) : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(_drinks[i]['icon'] as IconData,
                                        size: 32, color: selected ? Colors.white : const Color(0xFF1E2A78)),
                                    const SizedBox(height: 6),
                                    Text(
                                      _drinks[i]['name'] as String,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: selected ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // SELECTED ITEM PREVIEW
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF0F2FB), borderRadius: BorderRadius.circular(14)),
                              child: Icon(_drinks[_selectedDrinkIndex]['icon'] as IconData,
                                  size: 36, color: const Color(0xFF1E2A78)),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_drinks[_selectedDrinkIndex]['name'] as String,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E2A78))),
                                const SizedBox(height: 4),
                                Text('RM ${_itemPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      _SectionLabel(label: 'Your Details'),

                      // NAME
                      _InputField(
                        controller: nameController,
                        hint: 'Full Name',
                        icon: Icons.person_outline,
                        validator: (val) => (val == null || val.trim().isEmpty) ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 12),

                      // PHONE
                      _InputField(
                        controller: phoneController,
                        hint: 'Phone Number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Phone number is required';
                          if (val.trim().length < 9) return 'Enter a valid phone number';
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),
                      _SectionLabel(label: 'Drink Size'),

                      Row(
                        children: sizes.map((size) {
                          final isSelected = size == selectedSize;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => selectedSize = size),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF1E2A78) : Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(size,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.black87,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),
                      _SectionLabel(label: 'Temperature'),

                      Row(
                        children: temps.map((temp) {
                          final isSelected = temp == selectedTemp;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => selectedTemp = temp),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF1E2A78) : Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      temp == 'Hot' ? Icons.local_fire_department : Icons.ac_unit,
                                      size: 18,
                                      color: isSelected ? Colors.white : const Color(0xFF1E2A78),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(temp,
                                        style: TextStyle(
                                            color: isSelected ? Colors.white : Colors.black87,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),
                      _SectionLabel(label: 'Sugar Level: ${sugarLevel.toInt()}%'),

                      Slider(
                        value: sugarLevel,
                        min: 0,
                        max: 100,
                        divisions: 4,
                        activeColor: const Color(0xFF1E2A78),
                        label: '${sugarLevel.toInt()}%',
                        onChanged: (val) => setState(() => sugarLevel = val),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('0%', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text('25%', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text('50%', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text('75%', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text('100%', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),

                      const SizedBox(height: 20),
                      _SectionLabel(label: 'Quantity'),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                              icon: Icon(Icons.remove_circle_outline,
                                  color: quantity > 1 ? const Color(0xFF1E2A78) : Colors.grey),
                            ),
                            Expanded(
                              child: Text('$quantity',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2A78))),
                            ),
                            IconButton(
                              onPressed: () => setState(() => quantity++),
                              icon: const Icon(Icons.add_circle_outline, color: Color(0xFF1E2A78)),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      _SectionLabel(label: 'Special Notes (Optional)'),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                        child: TextFormField(
                          controller: notesController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'e.g. Less ice, extra shot...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ORDER SUMMARY
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: const Color(0xFFE8EBF8), borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Subtotal', style: TextStyle(color: Colors.grey)),
                                Text('RM ${_subtotal.toStringAsFixed(2)}'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Service Fee', style: TextStyle(color: Colors.grey)),
                                Text('RM 0.50'),
                              ],
                            ),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text('RM ${_total.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E2A78))),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E2A78),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                )
                              : const Text('Place Order',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E2A78))),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          icon: Icon(icon, color: const Color(0xFF1E2A78)),
          hintText: hint,
          border: InputBorder.none,
          errorStyle: const TextStyle(fontSize: 11),
        ),
      ),
    );
  }
}
