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
  static const List<int> _radiusOptions = [1, 5, 10, 15];
  static const List<int> _priceOptions = [30, 50, 100, 300];

  String userName = '';
  double radiusIndex = 1;
  RangeValues priceRangeIndex = const RangeValues(0, 2);

  int get _anyPriceIndex => _priceOptions.length;

  int get _selectedRadius {
    final index = radiusIndex.round().clamp(0, _radiusOptions.length - 1);
    return _radiusOptions[index];
  }

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
          radius: _selectedRadius.toDouble(),
          minPrice: _getMinPrice(),
          maxPrice: _getMaxPrice(),
          mood: moodController.text,
        ),
      ),
    );
  }

  int _getMinPrice() {
    final start = priceRangeIndex.start.toInt();
    if (start >= _anyPriceIndex) return 0;
    return _priceOptions[start];
  }

  int _getMaxPrice() {
    final end = priceRangeIndex.end.toInt();
    if (end >= _anyPriceIndex) return 0;
    return _priceOptions[end];
  }

  String _priceLabel(int index) {
    if (index >= _anyPriceIndex) return 'Any';
    return '${_priceOptions[index]}k';
  }

  String _formatPriceRange() {
    final start = priceRangeIndex.start.toInt();
    final end = priceRangeIndex.end.toInt();

    if (start == 0 && end == _anyPriceIndex) return 'Any';
    if (start == end) return _priceLabel(start);
    if (end == _anyPriceIndex) return '${_priceLabel(start)}+';
    return '${_priceLabel(start)} - ${_priceLabel(end)}';
  }

  RangeValues _normalizePriceRange(RangeValues values) {
    var start = values.start.round().clamp(0, _anyPriceIndex);
    var end = values.end.round().clamp(0, _anyPriceIndex);

    if (start == end && start != 0 && start != _anyPriceIndex) {
      final previousStart = priceRangeIndex.start.toInt();
      final previousEnd = priceRangeIndex.end.toInt();
      final startMoved = start != previousStart;
      final endMoved = end != previousEnd;

      if (startMoved && !endMoved) {
        start -= 1;
      } else if (endMoved && !startMoved) {
        end += 1;
      } else if (end < _anyPriceIndex) {
        end += 1;
      } else {
        start -= 1;
      }
    }

    return RangeValues(start.toDouble(), end.toDouble());
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
                '$_selectedRadius km',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: MealioColors.textPrimary,
                ),
              ),
            ],
          ),
          Slider(
            value: radiusIndex,
            min: 0,
            max: (_radiusOptions.length - 1).toDouble(),
            divisions: _radiusOptions.length - 1,
            label: '$_selectedRadius km',
            onChanged: (value) {
              setState(() {
                radiusIndex = value.roundToDouble();
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _radiusOptions
                .map(
                  (option) => Text(
                    '$option km',
                    style: const TextStyle(color: MealioColors.textMuted),
                  ),
                )
                .toList(),
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
                _formatPriceRange(),
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
            max: _anyPriceIndex.toDouble(),
            divisions: _anyPriceIndex,
            labels: RangeLabels(
              _priceLabel(priceRangeIndex.start.toInt()),
              _priceLabel(priceRangeIndex.end.toInt()),
            ),
            onChanged: (values) {
              setState(() {
                priceRangeIndex = _normalizePriceRange(values);
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              _anyPriceIndex + 1,
              (index) => Text(
                _priceLabel(index),
                style: const TextStyle(color: MealioColors.textMuted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
