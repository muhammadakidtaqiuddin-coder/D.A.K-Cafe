import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xFF1E2A78),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard_outlined),
            label: "Gift Card",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.workspace_premium_outlined),
            label: "Rewards",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Account",
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // TOP HEADER
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      // Pickup / Delivery
                      Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E2A78),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "Pickup",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                "Delivery",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Color(0xFF1E2A78),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: const [
                      Icon(
                        Icons.home_outlined,
                        size: 18,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Putra One Residences, Sungai Buloh",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E2A78),
                        ),
                      ),
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
                    child: ListView(
                      children: const [
                        CategoryTile(
                          icon: Icons.favorite,
                          title: "For You",
                          active: true,
                        ),
                        CategoryTile(
                          icon: Icons.local_cafe_outlined,
                          title: "Matcha Series",
                        ),
                        CategoryTile(
                          icon: Icons.emoji_food_beverage_outlined,
                          title: "ZUS Tea Series",
                        ),
                        CategoryTile(
                          icon: Icons.coffee_outlined,
                          title: "Buttercrème",
                        ),
                        CategoryTile(
                          icon: Icons.coffee_maker_outlined,
                          title: "Thai Milk Tea",
                        ),
                        CategoryTile(
                          icon: Icons.coffee,
                          title: "Espresso",
                        ),
                        CategoryTile(
                          icon: Icons.thumb_up_alt_outlined,
                          title: "Top Picks",
                        ),
                        CategoryTile(
                          icon: Icons.coffee_maker,
                          title: "CEO Series",
                        ),
                      ],
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
                              Container(
                                width: 4,
                                height: 24,
                                color: const Color(0xFF1E2A78),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "For You",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E2A78),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // PRODUCTS GRID
                          GridView.count(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.72,
                            children: const [
                              ProductCard(
                                name: "Buttercrème Frappé",
                                price: "RM 15.20",
                                image:
                                    "https://images.unsplash.com/photo-1517701604599-bb29b565090c",
                              ),
                              ProductCard(
                                name: "Iced CEO Americano",
                                price: "RM 6.90",
                                image:
                                    "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085",
                              ),
                              ProductCard(
                                name: "Iced French Vanilla Latte",
                                price: "RM 11.90",
                                image:
                                    "https://images.unsplash.com/photo-1511920170033-f8396924c348",
                              ),
                              ProductCard(
                                name: "Matcha Cloud Frappé",
                                price: "RM 15.20",
                                image:
                                    "https://images.unsplash.com/photo-1515823064-d6e0c04616a7",
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // BANNER
                          Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  "https://images.unsplash.com/photo-1515823064-d6e0c04616a7",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 24,
                                color: const Color(0xFF1E2A78),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Matcha Series",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E2A78),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          GridView.count(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.72,
                            children: const [
                              ProductCard(
                                name: "Matcha Cloud Latte",
                                price: "RM 14.90",
                                image:
                                    "https://images.unsplash.com/photo-1515823064-d6e0c04616a7",
                              ),
                              ProductCard(
                                name: "Iced Matcha Latte",
                                price: "RM 13.90",
                                image:
                                    "https://images.unsplash.com/photo-1515823064-d6e0c04616a7",
                              ),
                            ],
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

class CategoryTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool active;

  const CategoryTile({
    super.key,
    required this.icon,
    required this.title,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: active
            ? const Border(
                left: BorderSide(
                  color: Color(0xFF1E2A78),
                  width: 4,
                ),
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 10,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: active
                  ? const Color(0xFF1E2A78)
                  : Colors.grey,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
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
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String image;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2A78),
            ),
          ),
        ],
      ),
    );
  }
}