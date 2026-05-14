import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mealio/Pages/login_page.dart';
import 'package:mealio/Pages/privacy_page.dart';
import 'package:mealio/Pages/register_page.dart';
import 'package:mealio/Pages/terms_page.dart';
import 'package:mealio/theme/mealio_theme.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -70,
              right: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      MealioColors.primary.withValues(alpha: 0.18),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -90,
              left: -80,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      MealioColors.accent.withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 170,
                        height: 170,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: MealioColors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: MealioColors.primary.withValues(alpha: 0.12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: MealioColors.primary.withValues(
                                alpha: 0.16,
                              ),
                              blurRadius: 32,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                MealioColors.surfaceWarm,
                                MealioColors.surface,
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: ClipOval(
                              child: Image.asset(
                                'assets/icon.png',
                                width: 92,
                                height: 92,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: MealioColors.surface,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: MealioColors.border),
                        ),
                        child: Text(
                          'Personalized meal discovery',
                          style: textTheme.labelLarge?.copyWith(
                            color: MealioColors.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Mealio',
                        textAlign: TextAlign.center,
                        style: textTheme.displaySmall?.copyWith(
                          fontSize: 44,
                          color: MealioColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Discover new flavors, plan your meals effortlessly, and eat healthier with personalized recommendations.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge?.copyWith(
                            fontSize: 18,
                            color: MealioColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: const [
                          _FeatureChip(
                            icon: Icons.restaurant,
                            label: 'Curated picks',
                          ),
                          _FeatureChip(icon: Icons.tune, label: 'Diet filters'),
                          _FeatureChip(
                            icon: Icons.location_on,
                            label: 'Nearby spots',
                          ),
                        ],
                      ),
                      const SizedBox(height: 34),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          child: const Text('Create Account'),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          child: const Text('Sign In'),
                        ),
                      ),
                      const SizedBox(height: 22),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: textTheme.bodySmall?.copyWith(
                            color: MealioColors.textSecondary,
                            height: 1.5,
                          ),
                          children: [
                            const TextSpan(
                              text: 'By creating an account, you agree to our ',
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              style: textTheme.bodySmall?.copyWith(
                                color: MealioColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const TermsPage(),
                                    ),
                                  );
                                },
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: textTheme.bodySmall?.copyWith(
                                color: MealioColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const PrivacyPage(),
                                    ),
                                  );
                                },
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: MealioColors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: MealioColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: MealioColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              color: MealioColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
