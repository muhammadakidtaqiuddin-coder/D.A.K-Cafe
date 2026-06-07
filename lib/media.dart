import 'package:flutter/material.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  int _selectedTab = 0; // 0=All, 1=eGift Card, 2=Promotions
  final List<String> _tabs = ['All', 'eGift Card', 'Promotions'];

  final List<Map<String, dynamic>> _giftCards = [
    {'title': 'DAK Gift Card RM 20', 'subtitle': 'Valid for 12 months from date of purchase', 'color': const Color(0xFF1E2A78), 'icon': Icons.card_giftcard, 'purchased': false},
    {'title': 'DAK Gift Card RM 50', 'subtitle': 'Valid for 12 months from date of purchase', 'color': const Color(0xFF3B4FCC), 'icon': Icons.card_giftcard_outlined, 'purchased': false},
    {'title': 'DAK Gift Card RM 100', 'subtitle': 'Valid for 12 months from date of purchase', 'color': const Color(0xFF0D1A5E), 'icon': Icons.redeem, 'purchased': false},
  ];

  final List<Map<String, String>> _promos = [
    {'title': 'Wednesday Special', 'description': 'Buy 2 Free 1 on all drinks every Wednesday.', 'tag': 'ONGOING'},
    {'title': 'Birthday Treat', 'description': 'Enjoy a FREE drink on your birthday month.', 'tag': 'MEMBERS'},
    {'title': 'New Member Welcome', 'description': '10% off your first order when you sign up.', 'tag': 'NEW'},
  ];

  void _handleGiftCardTap(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(_giftCards[index]['title'], style: const TextStyle(color: Color(0xFF1E2A78))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_giftCards[index]['icon'] as IconData, size: 64, color: _giftCards[index]['color'] as Color),
            const SizedBox(height: 12),
            Text(_giftCards[index]['subtitle'] as String, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _giftCards[index]['purchased'] = true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${_giftCards[index]['title']} purchased! 🎉'),
                  backgroundColor: const Color(0xFF1E2A78),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E2A78), foregroundColor: Colors.white),
            child: const Text('Buy Now'),
          ),
        ],
      ),
    );
  }

  void _handlePromoTap(Map<String, String> promo) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFFE8EBF8), borderRadius: BorderRadius.circular(20)),
              child: Text(promo['tag']!, style: const TextStyle(color: Color(0xFF1E2A78), fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            Text(promo['title']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2A78))),
            const SizedBox(height: 8),
            Text(promo['description']!, style: const TextStyle(fontSize: 15, color: Colors.grey)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${promo['title']} promo applied!'),
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
                child: const Text('Claim Promo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContent() {
    final List<Widget> items = [];

    if (_selectedTab == 0 || _selectedTab == 1) {
      for (int i = 0; i < _giftCards.length; i++) {
        final card = _giftCards[i];
        items.add(GestureDetector(
          onTap: () => _handleGiftCardTap(i),
          child: Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: card['color'] as Color,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(card['title'] as String,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
                          const SizedBox(height: 8),
                          Text(card['subtitle'] as String,
                              style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(card['icon'] as IconData, size: 50, color: Colors.white.withOpacity(0.3)),
                  ],
                ),
              ),
              if (card['purchased'] == true)
                Positioned(
                  top: 10,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12)),
                    child: const Text('Purchased', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
        ));
        items.add(const SizedBox(height: 14));
      }
    }

    if (_selectedTab == 0) items.add(const SizedBox(height: 10));

    if (_selectedTab == 0 || _selectedTab == 2) {
      for (final promo in _promos) {
        items.add(GestureDetector(
          onTap: () => _handlePromoTap(promo),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFE8EBF8), borderRadius: BorderRadius.circular(20)),
                        child: Text(promo['tag']!,
                            style: const TextStyle(color: Color(0xFF1E2A78), fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      Text(promo['title']!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E2A78))),
                      const SizedBox(height: 4),
                      Text(promo['description']!, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ));
        items.add(const SizedBox(height: 14));
      }
    }

    return items;
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
              child: Row(
                children: [
                  const Text('Gift Card',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2A78))),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Search coming soon!'), behavior: SnackBarBehavior.floating),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: const Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.search, color: Color(0xFF1E2A78)),
                    ),
                  ),
                ],
              ),
            ),

            // TABS
            Container(
              color: Colors.white,
              child: Row(
                children: List.generate(_tabs.length, (i) {
                  final active = _selectedTab == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTab = i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        children: [
                          Text(_tabs[i],
                              style: TextStyle(
                                  fontWeight: active ? FontWeight.bold : FontWeight.w500,
                                  color: active ? const Color(0xFF1E2A78) : Colors.grey)),
                          const SizedBox(height: 4),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 3,
                            width: active ? 30 : 0,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E2A78),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            // CONTENT
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
