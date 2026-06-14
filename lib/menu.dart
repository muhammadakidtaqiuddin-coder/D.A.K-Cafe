import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dak_cafe/db_helper.dart';
import 'package:dak_cafe/cart_provider.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _activeCategoryIndex = 0;
  String _orderType = 'Pickup';

  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _currentProducts = [];
  bool _loading = true;

  final List<IconData> _categoryIcons = [
    Icons.favorite,
    Icons.local_cafe_outlined,
    Icons.emoji_food_beverage_outlined,
    Icons.coffee_outlined,
    Icons.coffee_maker_outlined,
    Icons.coffee,
    Icons.thumb_up_alt_outlined,
    Icons.coffee_maker,
  ];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final cats = await DBHelper.getCategories();
    setState(() => _categories = cats);
    if (cats.isNotEmpty) {
      await _loadProducts(cats[0]['id'] as int);
    }
    setState(() => _loading = false);
  }

  Future<void> _loadProducts(int categoryId) async {
    final products = await DBHelper.getProductsByCategory(categoryId);
    setState(() => _currentProducts = products);
  }

  void _showProductDetail(BuildContext context, Map<String, dynamic> product) {
    String size = 'Medium';
    String temp = 'Iced';
    double sugar = 50;
    int qty = 1;

    double price = 0;
    try {
      price = double.parse((product['price'] as String).replaceAll('RM', '').trim());
    } catch (_) {}

    final icon = _categoryIcons[_activeCategoryIndex % _categoryIcons.length];

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                          color: const Color(0xFFF0F2FB),
                          borderRadius: BorderRadius.circular(16)),
                      child: Icon(icon, size: 34, color: const Color(0xFF1E2A78)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product['name'],
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E2A78))),
                          const SizedBox(height: 4),
                          Text(product['price'],
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Size',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E2A78))),
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
                            color: active ? const Color(0xFF1E2A78) : const Color(0xFFF0F2FB),
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
                const Text('Temperature',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E2A78))),
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
                            color: active ? const Color(0xFF1E2A78) : const Color(0xFFF0F2FB),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                t == 'Hot' ? Icons.local_fire_department : Icons.ac_unit,
                                size: 16,
                                color: active ? Colors.white : const Color(0xFF1E2A78),
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
                Text('Sugar Level: ${sugar.toInt()}%',
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E2A78))),
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
                const Text('Quantity',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E2A78))),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                      color: const Color(0xFFF0F2FB),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: qty > 1 ? () => setSheet(() => qty--) : null,
                        icon: Icon(Icons.remove_circle_outline,
                            color: qty > 1 ? const Color(0xFF1E2A78) : Colors.grey),
                      ),
                      Expanded(
                        child: Text('$qty',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E2A78))),
                      ),
                      IconButton(
                        onPressed: () => setSheet(() => qty++),
                        icon: const Icon(Icons.add_circle_outline, color: Color(0xFF1E2A78)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final cart = Provider.of<CartProvider>(context, listen: false);
                      cart.addItem(CartItem(
                        productId: product['id'] as int,
                        name: product['name'] as String,
                        price: price,
                        icon: icon,
                        size: size,
                        temperature: temp,
                        sugarLevel: sugar.toInt(),
                        quantity: qty,
                      ));
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
                    child: Text(
                        'Add to Cart · RM ${(price * qty).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Category sidebar: 22% of width, clamped so it's never too narrow or too wide
    final sidebarWidth = (screenWidth * 0.22).clamp(68.0, 96.0);
    // Grid aspect ratio: slightly taller on narrow phones
    final gridAspect = screenWidth < 360 ? 0.64 : 0.72;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
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
                            Flexible(
                              child: Container(
                                height: 42,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F0F0),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: ['Pickup', 'Delivery'].map((type) {
                                    final isActive = _orderType == type;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() => _orderType = type);
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text('$type selected'),
                                          behavior: SnackBarBehavior.floating,
                                          duration: const Duration(seconds: 1),
                                        ));
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        decoration: BoxDecoration(
                                          color: isActive
                                              ? const Color(0xFF1E2A78)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(type,
                                            style: TextStyle(
                                              color: isActive ? Colors.white : Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            )),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Consumer<CartProvider>(
                              builder: (ctx, cart, _) => Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Go to Cart tab to view your cart!'),
                                          behavior: SnackBarBehavior.floating,
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F3F3),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: const Icon(Icons.shopping_cart_outlined,
                                          color: Color(0xFF1E2A78)),
                                    ),
                                  ),
                                  if (cart.totalCount > 0)
                                    Positioned(
                                      right: 4,
                                      top: 4,
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        decoration: const BoxDecoration(
                                          color: Colors.redAccent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '${cart.totalCount}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Search coming soon!'),
                                      behavior: SnackBarBehavior.floating),
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
                        const SizedBox(height: 12),
                        Row(
                          children: const [
                            Icon(Icons.home_outlined, size: 18, color: Colors.grey),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Putra One Residences, Sungai Buloh',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1E2A78),
                                    fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LEFT CATEGORY SIDEBAR
                        SizedBox(
                          width: sidebarWidth,
                          child: Container(
                            color: Colors.white,
                            child: ListView.builder(
                              itemCount: _categories.length,
                              itemBuilder: (ctx, i) {
                                final active = _activeCategoryIndex == i;
                                final icon = _categoryIcons[i % _categoryIcons.length];
                                return GestureDetector(
                                  onTap: () async {
                                    setState(() => _activeCategoryIndex = i);
                                    await _loadProducts(_categories[i]['id'] as int);
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      color: active ? const Color(0xFFF0F2FB) : Colors.white,
                                      border: active
                                          ? const Border(
                                              left: BorderSide(
                                                  color: Color(0xFF1E2A78), width: 4))
                                          : null,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 6),
                                      child: Column(
                                        children: [
                                          Icon(icon,
                                              color: active
                                                  ? const Color(0xFF1E2A78)
                                                  : Colors.grey,
                                              size: 22),
                                          const SizedBox(height: 6),
                                          Text(
                                            _categories[i]['title'],
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: active
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                              color: active
                                                  ? const Color(0xFF1E2A78)
                                                  : Colors.black87,
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
                        ),

                        // MAIN PRODUCT GRID
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        width: 4,
                                        height: 22,
                                        color: const Color(0xFF1E2A78)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _categories.isNotEmpty
                                            ? _categories[_activeCategoryIndex]['title']
                                            : '',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E2A78)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: gridAspect,
                                  ),
                                  itemCount: _currentProducts.length,
                                  itemBuilder: (ctx, i) {
                                    final product = _currentProducts[i];
                                    return GestureDetector(
                                      onTap: () => _showProductDetail(context, product),
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFF0F2FB),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: const Center(
                                                  child: Icon(Icons.local_cafe,
                                                      size: 44, color: Color(0xFF1E2A78)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(product['name'],
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            const SizedBox(height: 4),
                                            Text(product['price'],
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF1E2A78))),
                                            const SizedBox(height: 6),
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () =>
                                                    _showProductDetail(context, product),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xFF1E2A78),
                                                  foregroundColor: Colors.white,
                                                  padding: const EdgeInsets.symmetric(
                                                      vertical: 6),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(10)),
                                                ),
                                                child: const Text('Add',
                                                    style: TextStyle(fontSize: 12)),
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
