import 'package:flutter/material.dart';
import 'package:mealio/Pages/food_result_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mealio/theme/mealio_theme.dart';

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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 14,
                  //     vertical: 8,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: MealioColors.surface,
                  //     borderRadius: BorderRadius.circular(999),
                  //     border: Border.all(color: MealioColors.border),
                  //   ),
                  //   child: Text(
                  //     'Mealio search',
                  //     style: textTheme.labelLarge?.copyWith(
                  //       color: MealioColors.textSecondary,
                  //       fontWeight: FontWeight.w700,
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 18),
                  Text(
                    'Hungry, $userName?',
                    style: textTheme.headlineSmall?.copyWith(
                      fontSize: 28,
                      color: MealioColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'What are you\ncraving today?',
                    style: textTheme.displaySmall?.copyWith(
                      fontSize: 36,
                      height: 1.08,
                      color: MealioColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tell Mealio the vibe, then narrow down distance and budget.',
                    style: textTheme.bodyLarge?.copyWith(
                      color: MealioColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    decoration: BoxDecoration(
                      color: MealioColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: MealioColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: moodController,
                      minLines: 4,
                      maxLines: null,
                      decoration: const InputDecoration(
                        filled: false,
                        hintText:
                            "I want something... (e.g., spicy and warm because it's raining)",
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildRadiusCard(),
                  const SizedBox(height: 20),
                  _buildPricingCard(),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _findFood,
                    child: const Text('Find My Food'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadiusCard() {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: MealioColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: MealioColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: MealioColors.primary.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: MealioColors.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Search Radius',
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: MealioColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                '${radius.toInt()} km',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: MealioColors.textPrimary,
                ),
              ),
            ],
          ),
          Slider(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('1 km', style: TextStyle(color: MealioColors.textMuted)),
              Text('5 km', style: TextStyle(color: MealioColors.textMuted)),
              Text('10 km', style: TextStyle(color: MealioColors.textMuted)),
              Text('15 km', style: TextStyle(color: MealioColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard() {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: MealioColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: MealioColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: MealioColors.primary.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.attach_money,
                      color: MealioColors.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Pricing',
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: MealioColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                _formatRange(),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: MealioColors.textPrimary,
                ),
              ),
            ],
          ),
          RangeSlider(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Any', style: TextStyle(color: MealioColors.textMuted)),
              Text('30k', style: TextStyle(color: MealioColors.textMuted)),
              Text('50k', style: TextStyle(color: MealioColors.textMuted)),
              Text('100k', style: TextStyle(color: MealioColors.textMuted)),
              Text('300k+', style: TextStyle(color: MealioColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}
