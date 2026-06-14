import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<String> _favourites = {};
  bool _hasNotification = true;

  final List<Map<String, dynamic>> _drinks = [
    {'name': 'Iced CEO\nAmericano', 'price': 'RM 6.90', 'icon': Icons.coffee},
    {'name': 'Matcha Cloud\nFrappé', 'price': 'RM 15.20', 'icon': Icons.local_cafe},
    {'name': 'Iced French\nVanilla Latte', 'price': 'RM 11.90', 'icon': Icons.emoji_food_beverage},
    {'name': 'Thai Milk\nTea', 'price': 'RM 10.90', 'icon': Icons.coffee_maker},
  ];

  final List<Map<String, dynamic>> _banners = [
    {'title': 'New Arrival!', 'name': 'Buttercrème\nFrappé', 'price': 'From RM 15.20'},
    {'title': 'Limited Time!', 'name': 'Matcha Cloud\nLatte', 'price': 'From RM 14.90'},
    {'title': 'Best Seller!', 'name': 'Iced CEO\nAmericano', 'price': 'From RM 6.90'},
  ];

  int _bannerIndex = 0;

  void _toggleFavourite(String name) {
    setState(() {
      if (_favourites.contains(name)) {
        _favourites.remove(name);
      } else {
        _favourites.add(name);
      }
    });
  }

  void _showDrinkDetail(BuildContext context, Map<String, dynamic> drink) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2FB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(drink['icon'] as IconData, size: 56, color: const Color(0xFF1E2A78)),
            ),
            const SizedBox(height: 16),
            Text(
              (drink['name'] as String).replaceAll('\n', ' '),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2A78)),
            ),
            const SizedBox(height: 8),
            Text(drink['price'] as String,
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
                      content: Text('${(drink['name'] as String).replaceAll('\n', ' ')} added to cart!'),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // Responsive banner height: taller on large screens, shorter on small
    final bannerHeight = (screenHeight * 0.20).clamp(130.0, 180.0);
    // Responsive card width for horizontal list
    final cardWidth = (screenWidth * 0.37).clamp(120.0, 160.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                color: Colors.white,
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Color(0xFF1E2A78),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Good Morning,', style: TextStyle(color: Colors.grey, fontSize: 13)),
                          Text(
                            'Admin',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E2A78)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() => _hasNotification = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No new notifications'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F3F3),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.notifications_none, color: Color(0xFF1E2A78)),
                          ),
                          if (_hasNotification)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // SWIPEABLE BANNER
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity != null) {
                          setState(() {
                            if (details.primaryVelocity! < 0) {
                              _bannerIndex = (_bannerIndex + 1) % _banners.length;
                            } else {
                              _bannerIndex = (_bannerIndex - 1 + _banners.length) % _banners.length;
                            }
                          });
                        }
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: Container(
                          key: ValueKey(_bannerIndex),
                          height: bannerHeight,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1E2A78), Color(0xFF3B4FCC)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 20,
                                top: 24,
                                right: 80,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_banners[_bannerIndex]['title']!,
                                        style: const TextStyle(color: Colors.white70, fontSize: 13)),
                                    const SizedBox(height: 6),
                                    Text(_banners[_bannerIndex]['name']!,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    Text(_banners[_bannerIndex]['price']!,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 12,
                                bottom: 0,
                                child: Icon(Icons.local_cafe,
                                    size: 90, color: Colors.white.withOpacity(0.2)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _banners.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _bannerIndex == i ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _bannerIndex == i ? const Color(0xFF1E2A78) : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // QUICK ACTIONS — evenly spaced, icon size responsive
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _QuickAction(
                      icon: Icons.menu_book_outlined,
                      label: 'Order',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Go to Menu tab to order!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    _QuickAction(icon: Icons.card_giftcard_outlined, label: 'Gift Card', onTap: () {}),
                    _QuickAction(
                      icon: Icons.workspace_premium_outlined,
                      label: 'Rewards',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('You have 1,250 pts — Gold Member!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    _QuickAction(
                      icon: Icons.history,
                      label: 'History',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No recent orders yet.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // POPULAR SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Popular Now',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2A78))),
                    TextButton(
                      onPressed: () {},
                      child: const Text('See All', style: TextStyle(color: Color(0xFF1E2A78))),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                height: 210,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _drinks.length,
                  itemBuilder: (ctx, i) {
                    final drink = _drinks[i];
                    final name = drink['name'] as String;
                    final isFav = _favourites.contains(name);
                    return GestureDetector(
                      onTap: () => _showDrinkDetail(context, drink),
                      child: Container(
                        width: cardWidth,
                        margin: const EdgeInsets.only(right: 14),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F2FB),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(
                                    child: Icon(drink['icon'] as IconData,
                                        size: 48, color: const Color(0xFF1E2A78)),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => _toggleFavourite(name),
                                    child: Icon(
                                      isFav ? Icons.favorite : Icons.favorite_border,
                                      color: isFav ? Colors.redAccent : Colors.grey,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 4),
                            Text(drink['price'] as String,
                                style: const TextStyle(
                                    color: Color(0xFF1E2A78),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // PROMO SECTION
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Promotions',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2A78))),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Promo valid every Wednesday! 🎉'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFFE8EBF8),
                    ),
                    child: const Text(
                      '🎉  Buy 2 Free 1 every Wednesday!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Color(0xFF1E2A78), fontSize: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Derive size from screen width so it fits any phone
    final screenWidth = MediaQuery.of(context).size.width;
    final size = ((screenWidth - 64) / 4).clamp(48.0, 68.0);
    final iconSize = (size * 0.44).clamp(20.0, 28.0);
    final fontSize = screenWidth < 360 ? 10.0 : 12.0;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EBF8),
              borderRadius: BorderRadius.circular(size * 0.27),
            ),
            child: Icon(icon, color: const Color(0xFF1E2A78), size: iconSize),
          ),
          const SizedBox(height: 6),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
