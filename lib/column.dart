import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dak_cafe/home.dart';
import 'package:dak_cafe/menu.dart';
import 'package:dak_cafe/media.dart';
import 'package:dak_cafe/cart_page.dart';
import 'package:dak_cafe/cart_provider.dart';
import 'package:dak_cafe/review_page.dart';
import 'package:dak_cafe/profile.dart';
import 'package:dak_cafe/debug_page.dart';

class ColumnPage extends StatefulWidget {
  final Map<String, dynamic> user;
  const ColumnPage({super.key, required this.user});

  @override
  State<ColumnPage> createState() => _ColumnPageState();
}

class _ColumnPageState extends State<ColumnPage> {
  int currentIndex = 0;

  bool get isAdmin => widget.user['username'] == 'admin';

  List<Widget> get pages => [
        const HomePage(),
        const MenuPage(),
        const CartPage(),
        const MediaPage(),
        const ReviewPage(),
        ProfilePage(user: widget.user),
        if (isAdmin) const DebugPage(),
      ];

  List<BottomNavigationBarItem> get navItems => [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_outlined),
          label: 'Menu',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Cart',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard_outlined),
          label: 'Gift Card',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.star_outline_rounded),
          label: 'Review',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Account',
        ),
        if (isAdmin)
          const BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings_outlined),
            label: 'Admin',
          ),
      ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: _ColumnShell(
        pages: pages,
        navItems: navItems,
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
      ),
    );
  }
}

// Separate shell so Consumer can access CartProvider for the badge
class _ColumnShell extends StatelessWidget {
  final List<Widget> pages;
  final List<BottomNavigationBarItem> navItems;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _ColumnShell({
    required this.pages,
    required this.navItems,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (ctx, cart, _) {
        // Build nav items with live cart badge on Cart tab
        final items = navItems.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          // Cart is index 2
          if (i == 2 && cart.totalCount > 0) {
            return BottomNavigationBarItem(
              label: item.label,
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart_outlined),
                  Positioned(
                    right: -6,
                    top: -4,
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
            );
          }
          return item;
        }).toList();

        return Scaffold(
          body: pages[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            selectedItemColor: const Color(0xFF1E2A78),
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            onTap: onTap,
            items: items,
          ),
        );
      },
    );
  }
}
