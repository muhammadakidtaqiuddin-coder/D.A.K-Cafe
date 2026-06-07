import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dak_cafe/cart_provider.dart';
import 'package:dak_cafe/db_helper.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _checkout(CartProvider cart) async {
    if (cart.items.isEmpty) return;

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name and phone number.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (phone.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid phone number.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Save each cart item as a separate order row
    for (final item in cart.items) {
      await DBHelper.insertOrder(
        drinkName: item.name,
        size: item.size,
        temperature: item.temperature,
        sugarLevel: item.sugarLevel,
        quantity: item.quantity,
        pricePerItem: item.price,
        total: item.subtotal + (cart.serviceFee / cart.items.length),
        customerName: name,
        customerPhone: phone,
        notes: _notesController.text.trim(),
      );
    }

    setState(() => _isSubmitting = false);

    if (!mounted) return;

    final totalStr = 'RM ${cart.total.toStringAsFixed(2)}';
    final itemCount = cart.totalCount;
    cart.clear();
    _nameController.clear();
    _phoneController.clear();
    _notesController.clear();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: Colors.green, size: 52),
            ),
            const SizedBox(height: 20),
            const Text('Order Placed!',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2A78))),
            const SizedBox(height: 10),
            Text(
              '$itemCount item${itemCount > 1 ? 's' : ''} · $totalStr',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 6),
            const Text('Your order has been saved.',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2A78),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Done',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomiseSheet(CartProvider cart, int index) {
    final item = cart.items[index];
    String size = item.size;
    String temp = item.temperature;
    double sugar = item.sugarLevel.toDouble();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2A78))),
              const SizedBox(height: 20),

              // Size
              const Text('Size',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Color(0xFF1E2A78))),
              const SizedBox(height: 8),
              Row(
                children: ['Small', 'Medium', 'Large'].map((s) {
                  final active = s == size;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setSheet(() => size = s),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: active
                              ? const Color(0xFF1E2A78)
                              : const Color(0xFFF0F2FB),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(s,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: active ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 13)),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Temp
              const Text('Temperature',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Color(0xFF1E2A78))),
              const SizedBox(height: 8),
              Row(
                children: ['Hot', 'Iced'].map((t) {
                  final active = t == temp;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setSheet(() => temp = t),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: active
                              ? const Color(0xFF1E2A78)
                              : const Color(0xFFF0F2FB),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              t == 'Hot'
                                  ? Icons.local_fire_department
                                  : Icons.ac_unit,
                              size: 16,
                              color:
                                  active ? Colors.white : const Color(0xFF1E2A78),
                            ),
                            const SizedBox(width: 4),
                            Text(t,
                                style: TextStyle(
                                    color: active ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Sugar
              Text('Sugar Level: ${sugar.toInt()}%',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: Color(0xFF1E2A78))),
              Slider(
                value: sugar,
                min: 0,
                max: 100,
                divisions: 4,
                activeColor: const Color(0xFF1E2A78),
                label: '${sugar.toInt()}%',
                onChanged: (v) => setSheet(() => sugar = v),
              ),

              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Apply changes — remove and re-add with new config
                    final updated = CartItem(
                      productId: item.productId,
                      name: item.name,
                      price: item.price,
                      icon: item.icon,
                      size: size,
                      temperature: temp,
                      sugarLevel: sugar.toInt(),
                      quantity: item.quantity,
                    );
                    cart.remove(index);
                    cart.addItem(updated);
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2A78),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Save Changes',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) => Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: SafeArea(
          child: Column(
            children: [
              // HEADER
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    const Text('My Cart',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E2A78))),
                    const Spacer(),
                    if (cart.items.isNotEmpty)
                      TextButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            title: const Text('Clear Cart'),
                            content: const Text(
                                'Remove all items from your cart?'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Cancel')),
                              ElevatedButton(
                                onPressed: () {
                                  cart.clear();
                                  Navigator.pop(ctx);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white),
                                child: const Text('Clear'),
                              ),
                            ],
                          ),
                        ),
                        child: const Text('Clear all',
                            style: TextStyle(color: Colors.redAccent)),
                      ),
                  ],
                ),
              ),

              // CART ITEMS
              Expanded(
                child: cart.items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shopping_cart_outlined,
                                size: 80,
                                color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            const Text('Your cart is empty',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            const Text('Add drinks from the Menu tab',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // CART ITEMS LIST
                          ...cart.items.asMap().entries.map((entry) {
                            final i = entry.key;
                            final item = entry.value;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    // Icon
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF0F2FB),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Icon(item.icon,
                                          color: const Color(0xFF1E2A78),
                                          size: 30),
                                    ),
                                    const SizedBox(width: 12),

                                    // Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(item.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Color(0xFF1E2A78))),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${item.size} · ${item.temperature} · Sugar ${item.sugarLevel}%',
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                          const SizedBox(height: 4),
                                          GestureDetector(
                                            onTap: () =>
                                                _showCustomiseSheet(cart, i),
                                            child: const Text('Customise',
                                                style: TextStyle(
                                                    color: Color(0xFF3B4FCC),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    decoration: TextDecoration
                                                        .underline)),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Qty controls + price
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'RM ${item.subtotal.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1E2A78),
                                              fontSize: 14),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            _QtyButton(
                                              icon: item.quantity == 1
                                                  ? Icons.delete_outline
                                                  : Icons.remove,
                                              color: item.quantity == 1
                                                  ? Colors.redAccent
                                                  : const Color(0xFF1E2A78),
                                              onTap: () => cart.decrement(i),
                                            ),
                                            SizedBox(
                                              width: 32,
                                              child: Text(
                                                '${item.quantity}',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            _QtyButton(
                                              icon: Icons.add,
                                              color: const Color(0xFF1E2A78),
                                              onTap: () => cart.increment(i),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                          const SizedBox(height: 8),

                          // CUSTOMER DETAILS
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Your Details',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Color(0xFF1E2A78))),
                                const SizedBox(height: 14),
                                _DetailField(
                                  controller: _nameController,
                                  hint: 'Full Name',
                                  icon: Icons.person_outline,
                                ),
                                const SizedBox(height: 10),
                                _DetailField(
                                  controller: _phoneController,
                                  hint: 'Phone Number',
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 10),
                                _DetailField(
                                  controller: _notesController,
                                  hint: 'Special notes (optional)',
                                  icon: Icons.notes_outlined,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ORDER SUMMARY
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: const Color(0xFFE8EBF8),
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Subtotal',
                                        style: TextStyle(color: Colors.grey)),
                                    Text(
                                        'RM ${cart.subtotal.toStringAsFixed(2)}'),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Service Fee',
                                        style: TextStyle(color: Colors.grey)),
                                    Text('RM 0.50'),
                                  ],
                                ),
                                const Divider(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    Text(
                                      'RM ${cart.total.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xFF1E2A78)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // CHECKOUT BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isSubmitting
                                  ? null
                                  : () => _checkout(cart),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E2A78),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                              ),
                              child: _isSubmitting
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2),
                                    )
                                  : Text(
                                      'Place Order · RM ${cart.total.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _QtyButton(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final int maxLines;

  const _DetailField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          icon: Icon(icon, color: const Color(0xFF1E2A78), size: 20),
          hintText: hint,
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }
}
