import 'package:flutter/material.dart';
import 'package:mealio/Pages/food_result_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeContentPage extends StatefulWidget {
  const HomeContentPage({super.key});

  @override
  State<HomeContentPage> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContentPage> {
  final TextEditingController moodController = TextEditingController();
  final List<int> priceOptions = [30, 50, 100, 300];

  String userName = '';
  double radius = 5;
  RangeValues priceRangeIndex = const RangeValues(0, 2);

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      userName = prefs.getString("name") ?? "";
    });
  }

  void _findFood() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodResultPage(
          radius: radius,
          minPrice: _getMinPrice(),
          maxPrice: _getMaxPrice(),
          mood: moodController.text,
        ),
      ),
    );
  }

  int _getMinPrice() {
    final start = priceRangeIndex.start.toInt();
    if (start == 0) return 0;
    return priceOptions[start - 1];
  }

  int _getMaxPrice() {
    final end = priceRangeIndex.end.toInt();
    if (end == priceOptions.length) return 0;
    return priceOptions[end];
  }

  String _formatRange() {
    final start = priceRangeIndex.start.toInt();
    final end = priceRangeIndex.end.toInt();

    if (start == 0 && end == priceOptions.length) return 'Any';
    if (start == 0) return 'Under ${priceOptions[end]}k';
    if (end == priceOptions.length) return '${priceOptions[start - 1]}k+';
    return '${priceOptions[start - 1]}k - ${priceOptions[end]}k';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(
                'Hungry, $userName?',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'What are you\ncraving today?',
                style: TextStyle(
                  fontSize: 36,
                  height: 1.1,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: moodController,
                minLines: 4,
                maxLines: null,
                decoration: InputDecoration(
                  hintText:
                      "i want something... (e.g., spicy and warm\nbecause it's raining)",
                  hintStyle: const TextStyle(color: Color(0xFF64748B)),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 248, 248, 248),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFE2E8F0),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildRadiusCard(),
              const SizedBox(height: 20),
              _buildPricingCard(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _findFood,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF26A3D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Find My Food",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  Widget _buildRadiusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 248, 248, 248),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.location_on, color: Color(0xFFF26A3D)),
                  SizedBox(width: 6),
                  Text(
                    "Search Radius",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Text(
                "${radius.toInt()} km",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFF26A3D),
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: const Color(0xFFF26A3D),
              overlayColor:
                  const Color(0xFFF26A3D).withValues(alpha: 0.2),
              trackHeight: 6,
            ),
            child: Slider(
              value: radius,
              min: 1,
              max: 15,
              divisions: 3,
              onChanged: (value) {
                setState(() {
                  radius = value;
                });
              },
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("1km", style: TextStyle(color: Color(0xFF94A3B8))),
              Text("5km", style: TextStyle(color: Color(0xFF94A3B8))),
              Text("10km", style: TextStyle(color: Color(0xFF94A3B8))),
              Text("15km", style: TextStyle(color: Color(0xFF94A3B8))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 248, 248, 248),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.attach_money, color: Color(0xFFF26A3D)),
                  SizedBox(width: 6),
                  Text(
                    "Pricing",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Text(
                _formatRange(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFF26A3D),
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: const Color(0xFFF26A3D),
              overlayColor:
                  const Color(0xFFF26A3D).withValues(alpha: 0.2),
              trackHeight: 6,
            ),
            child: RangeSlider(
              values: priceRangeIndex,
              min: 0,
              max: priceOptions.length.toDouble(),
              divisions: priceOptions.length,
              onChanged: (values) {
                setState(() {
                  priceRangeIndex = RangeValues(
                    values.start.roundToDouble(),
                    values.end.roundToDouble(),
                  );
                });
              },
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Any", style: TextStyle(color: Color(0xFF94A3B8))),
              Text("30k", style: TextStyle(color: Color(0xFF94A3B8))),
              Text("50k", style: TextStyle(color: Color(0xFF94A3B8))),
              Text("100k", style: TextStyle(color: Color(0xFF94A3B8))),
              Text("300k+", style: TextStyle(color: Color(0xFF94A3B8))),
            ],
          ),
        ],
      ),
    );
  }
}

