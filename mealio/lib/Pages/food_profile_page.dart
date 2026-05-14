import 'package:flutter/material.dart';
import 'package:mealio/Pages/home_page.dart';
import 'package:mealio/Services/user_service.dart';
import 'package:mealio/theme/mealio_theme.dart';

class FoodProfilePage extends StatefulWidget {
  final bool isOnboarding;

  const FoodProfilePage({super.key, this.isOnboarding = false});

  @override
  State<FoodProfilePage> createState() => _FoodProfileState();
}

class _FoodProfileState extends State<FoodProfilePage> {
  bool halal = false;
  bool vegan = false;
  List<String> selected = [];

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    try {
      final result = await UserService.getPreferences();
      if (!mounted) return;

      final data = result['data']['user'];

      setState(() {
        halal = data['requiresHalal'] ?? false;
        vegan = data['requiresVegan'] ?? false;
        selected = List<String>.from(data['allergies'] ?? []);
      });
    } catch (e) {
      // silently fail on load
    }
  }

  Future<void> savePreferences() async {
    try {
      final result = await UserService.savePreferences(
        halal: halal,
        vegan: vegan,
        allergies: selected,
      );

      if (!mounted) return;

      if (result['statusCode'] == 200 || result['statusCode'] == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Preferences Saved')));

        if (widget.isOnboarding) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        } else {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Connection Error')));
    }
  }

  Widget _buildSwitchCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color activeColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: MealioColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MealioColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: activeColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: MealioColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: MealioColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: activeColor,
            activeTrackColor: activeColor.withValues(alpha: 0.35),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, IconData icon) {
    final isSelected = selected.contains(label);
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selected.remove(label);
          } else {
            selected.add(label);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? MealioColors.primary : MealioColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? MealioColors.primary : MealioColors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: MealioColors.primary.withValues(alpha: 0.16),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : MealioColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.white : MealioColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              const Icon(Icons.close, size: 16, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !widget.isOnboarding,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Personalize your recommendations',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      fontSize: 28,
                      color: MealioColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Set dietary requirements and allergies so Mealio can find the right matches for you.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      color: MealioColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Dietary requirements',
                    style: textTheme.titleLarge?.copyWith(
                      color: MealioColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSwitchCard(
                    title: 'Halal only',
                    subtitle: 'Strictly exclude non-halal items',
                    icon: Icons.check_circle,
                    iconBg: MealioColors.primary.withValues(alpha: 0.12),
                    activeColor: MealioColors.primary,
                    value: halal,
                    onChanged: (val) {
                      setState(() {
                        halal = val;
                      });
                    },
                  ),
                  _buildSwitchCard(
                    title: 'Vegan',
                    subtitle: 'Plant-based diet only',
                    icon: Icons.eco,
                    iconBg: Colors.green.withValues(alpha: 0.12),
                    activeColor: Colors.green,
                    value: vegan,
                    onChanged: (val) {
                      setState(() {
                        vegan = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Allergies & intolerances',
                        style: textTheme.titleLarge?.copyWith(
                          color: MealioColors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selected.clear();
                          });
                        },
                        child: const Text('Clear all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildChip('Seafood', Icons.set_meal),
                      _buildChip('Peanut', Icons.circle),
                      _buildChip('Dairy', Icons.local_drink),
                      _buildChip('Gluten', Icons.ramen_dining),
                      _buildChip('Soy', Icons.eco),
                      _buildChip('Eggs', Icons.egg),
                      _buildChip('Sesame', Icons.grain),
                      _buildChip('Wheat', Icons.grass),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: savePreferences,
                    child: const Text('Save Preferences'),
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
}
