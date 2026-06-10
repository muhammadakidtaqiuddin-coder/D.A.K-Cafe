import 'package:flutter/material.dart';
import 'package:dak_cafe/db_helper.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int _selectedDrinkIndex = 0;
  int _rating = 0;
  int _hoverRating = 0;
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();
  bool _isSubmitting = false;
  bool _submitted = false;

  final List<Map<String, dynamic>> _drinks = [
    {'name': 'Iced CEO Americano', 'icon': Icons.coffee},
    {'name': 'Matcha Cloud Frappé', 'icon': Icons.local_cafe},
    {'name': 'Buttercrème Frappé', 'icon': Icons.emoji_food_beverage},
    {'name': 'Thai Milk Tea', 'icon': Icons.coffee_maker},
    {'name': 'Iced French Vanilla Latte', 'icon': Icons.local_drink},
    {'name': 'Jasmine Milk Tea', 'icon': Icons.emoji_food_beverage_outlined},
  ];

  final List<String> _ratingLabels = [
    '',
    'Poor',
    'Fair',
    'Good',
    'Great',
    'Excellent!',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a star rating.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write a short review.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    await DBHelper.insertReview(
      drinkName: _drinks[_selectedDrinkIndex]['name'] as String,
      rating: _rating,
      reviewerName: _nameController.text.trim(),
      comment: _reviewController.text.trim(),
    );

    setState(() {
      _isSubmitting = false;
      _submitted = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() {
      _submitted = false;
      _rating = 0;
      _hoverRating = 0;
      _selectedDrinkIndex = 0;
      _nameController.clear();
      _reviewController.clear();
    });
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: const Center(
                child: Text(
                  'Leave a Review',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2A78)),
                ),
              ),
            ),

            Expanded(
              child: _submitted ? _buildSuccess() : _buildForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(45),
            ),
            child: const Icon(Icons.favorite_rounded,
                color: Colors.green, size: 52),
          ),
          const SizedBox(height: 20),
          const Text('Thank you!',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2A78))),
          const SizedBox(height: 8),
          const Text('Your review has been submitted.',
              style: TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DRINK PICKER
          _Label('Which drink are you reviewing?'),
          SizedBox(
            height: 100,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cardW = (MediaQuery.of(context).size.width * 0.24).clamp(80.0, 100.0);
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _drinks.length,
                  itemBuilder: (ctx, i) {
                    final active = _selectedDrinkIndex == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedDrinkIndex = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: cardW,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          active ? const Color(0xFF1E2A78) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_drinks[i]['icon'] as IconData,
                            size: 28,
                            color: active
                                ? Colors.white
                                : const Color(0xFF1E2A78)),
                        const SizedBox(height: 6),
                        Text(
                          _drinks[i]['name'] as String,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: active ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
              },
            ),
          ),

          const SizedBox(height: 24),

          // STAR RATING
          _Label('How would you rate it?'),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final starIndex = i + 1;
                    final filled = starIndex <=
                        (_hoverRating > 0 ? _hoverRating : _rating);
                    return GestureDetector(
                      onTap: () => setState(() => _rating = starIndex),
                      onTapDown: (_) =>
                          setState(() => _hoverRating = starIndex),
                      onTapCancel: () => setState(() => _hoverRating = 0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          child: Icon(
                            filled ? Icons.star_rounded : Icons.star_outline_rounded,
                            key: ValueKey('$starIndex-$filled'),
                            size: 44,
                            color: filled
                                ? const Color(0xFFFFB800)
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    _rating > 0 ? _ratingLabels[_rating] : 'Tap a star to rate',
                    key: ValueKey(_rating),
                    style: TextStyle(
                      color: _rating > 0
                          ? const Color(0xFF1E2A78)
                          : Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // NAME
          _Label('Your Name'),
          _FormField(
            controller: _nameController,
            hint: 'e.g. Ahmad Farid',
            icon: Icons.person_outline,
          ),

          const SizedBox(height: 16),

          // COMMENT
          _Label('Your Review'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
              ],
            ),
            child: TextField(
              controller: _reviewController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText:
                    'Tell us what you think about this drink...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
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
                  : const Text('Submit Review',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF1E2A78))),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;

  const _FormField(
      {required this.controller, required this.hint, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(icon, color: const Color(0xFF1E2A78)),
          hintText: hint,
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
