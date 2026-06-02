import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _activeCategoryIndex = 0;
  String _orderType = 'Pickup'; // Pickup or Delivery

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.favorite, 'title': 'For You'},
    {'icon': Icons.local_cafe_outlined, 'title': 'Matcha Series'},
    {'icon': Icons.emoji_food_beverage_outlined, 'title': 'ZUS Tea Series'},
    {'icon': Icons.coffee_outlined, 'title': 'Buttercrème'},
    {'icon': Icons.coffee_maker_outlined, 'title': 'Thai Milk Tea'},
    {'icon': Icons.coffee, 'title': 'Espresso'},
    {'icon': Icons.thumb_up_alt_outlined, 'title': 'Top Picks'},
    {'icon': Icons.coffee_maker, 'title': 'CEO Series'},
  ];

  final Map<String, List<Map<String, dynamic>>> _products = {
    'For You': [
      {'name': 'Buttercrème Frappé', 'price': 'RM 15.20', 'icon': Icons.local_cafe},
      {'name': 'Iced CEO Americano', 'price': 'RM 6.90', 'icon': Icons.coffee},
      {'name': 'Iced French Vanilla Latte', 'price': 'RM 11.90', 'icon': Icons.emoji_food_beverage},
      {'name': 'Matcha Cloud Frappé', 'price': 'RM 15.20', 'icon': Icons.local_cafe_outlined},
    ],
    'Matcha Series': [
      {'name': 'Matcha Cloud Latte', 'price': 'RM 14.90', 'icon': Icons.local_cafe_outlined},
      {'name': 'Iced Matcha Latte', 'price': 'RM 13.90', 'icon': Icons.local_cafe},
      {'name': 'Matcha Frappé', 'price': 'RM 15.20', 'icon': Icons.coffee_maker_outlined},
    ],
    'ZUS Tea Series': [
      {'name': 'Jasmine Milk Tea', 'price': 'RM 9.90', 'icon': Icons.emoji_food_beverage_outlined},
      {'name': 'Oolong Milk Tea', 'price': 'RM 10.90', 'icon': Icons.coffee_maker},
    ],
    'Buttercrème': [
      {'name': 'Buttercrème Frappé', 'price': 'RM 15.20', 'icon': Icons.local_cafe},
      {'name': 'Buttercrème Latte', 'price': 'RM 13.90', 'icon': Icons.coffee_outlined},
    ],
    'Thai Milk Tea': [
      {'name': 'Thai Milk Tea', 'price': 'RM 10.90', 'icon': Icons.coffee_maker_outlined},
      {'name': 'Thai Milk Tea Frappé', 'price': 'RM 13.90', 'icon': Icons.coffee_maker},
    ],
    'Espresso': [
      {'name': 'Americano', 'price': 'RM 6.90', 'icon': Icons.coffee},
      {'name': 'Flat White', 'price': 'RM 9.90', 'icon': Icons.coffee_outlined},
      {'name': 'Cappuccino', 'price': 'RM 9.90', 'icon': Icons.emoji_food_beverage},
    ],
    'Top Picks': [
      {'name': 'Iced CEO Americano', 'price': 'RM 6.90', 'icon': Icons.coffee},
      {'name': 'Buttercrème Frappé', 'price': 'RM 15.20', 'icon': Icons.local_cafe},
    ],
    'CEO Series': [
      {'name': 'CEO Americano', 'price': 'RM 6.90', 'icon': Icons.coffee},
      {'name': 'CEO Latte', 'price': 'RM 10.90', 'icon': Icons.coffee_outlined},
    ],
  };

  void _showProductDetail(BuildContext context, Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(color: const Color(0xFFF0F2FB), borderRadius: BorderRadius.circular(20)),
              child: Icon(product['icon'] as IconData, size: 56, color: const Color(0xFF1E2A78)),
            ),
            const SizedBox(height: 16),
            Text(product['name'] as String,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2A78))),
            const SizedBox(height: 8),
            Text(product['price'] as String,
                style: const TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product['name']} added to cart!'),
                      backgroundColor: const Color(0xFF1E2A78),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2A78),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Add to Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeCategory = _categories[_activeCategoryIndex]['title'] as String;
    final products = _products[activeCategory] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            // TOP HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      // Pickup / Delivery toggle
                      Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: ['Pickup', 'Delivery'].map((type) {
                            final isActive = _orderType == type;
                            return GestureDetector(
                              onTap: () {
                                setState(() => _orderType = type);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('$type selected'),
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                decoration: BoxDecoration(
                                  color: isActive ? const Color(0xFF1E2A78) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    color: isActive ? Colors.white : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Search coming soon!'), behavior: SnackBarBehavior.floating),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F3F3),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.search, color: Color(0xFF1E2A78)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      Icon(Icons.home_outlined, size: 18, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('Putra One Residences, Sungai Buloh',
                          style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E2A78))),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: Row(
                children: [
                  // LEFT CATEGORY MENU
                  Container(
                    width: 95,
                    color: Colors.white,
                    child: ListView.builder(
                      itemCount: _categories.length,
                      itemBuilder: (ctx, i) {
                        final active = _activeCategoryIndex == i;
                        return GestureDetector(
                          onTap: () => setState(() => _activeCategoryIndex = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: active ? const Color(0xFFF0F2FB) : Colors.white,
                              border: active
                                  ? const Border(left: BorderSide(color: Color(0xFF1E2A78), width: 4))
                                  : null,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                              child: Column(
                                children: [
                                  Icon(_categories[i]['icon'] as IconData,
                                      color: active ? const Color(0xFF1E2A78) : Colors.grey, size: 28),
                                  const SizedBox(height: 8),
                                  Text(
                                    _categories[i]['title'] as String,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: active ? FontWeight.bold : FontWeight.w500,
                                      color: active ? const Color(0xFF1E2A78) : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // MAIN CONTENT
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SECTION TITLE
                          Row(
                            children: [
                              Container(width: 4, height: 24, color: const Color(0xFF1E2A78)),
                              const SizedBox(width: 8),
                              Text(activeCategory,
                                  style: const TextStyle(
                                      fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E2A78))),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // PRODUCTS GRID
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.72,
                            ),
                            itemCount: products.length,
                            itemBuilder: (ctx, i) {
                              final product = products[i];
                              return GestureDetector(
                                onTap: () => _showProductDetail(context, product),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF0F2FB),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Center(
                                            child: Icon(product['icon'] as IconData,
                                                size: 56, color: const Color(0xFF1E2A78)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(product['name'] as String,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                      const SizedBox(height: 8),
                                      Text(product['price'] as String,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF1E2A78))),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () => _showProductDetail(context, product),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF1E2A78),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 6),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10)),
                                          ),
                                          child: const Text('Add', style: TextStyle(fontSize: 13)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
