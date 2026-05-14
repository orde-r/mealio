import 'package:flutter/material.dart';
import 'package:mealio/Pages/change_name_page.dart';
import 'package:mealio/Pages/food_profile_page.dart';
import 'package:mealio/Pages/update_password_page.dart';
import 'package:mealio/Pages/welcome_page.dart';
import 'package:mealio/Services/user_service.dart';
import 'package:mealio/theme/mealio_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileContentPage extends StatefulWidget {
  const ProfileContentPage({super.key});

  @override
  State<ProfileContentPage> createState() => _ProfileContentPageState();
}

class _ProfileContentPageState extends State<ProfileContentPage> {
  String name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    setState(() {
      name = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
    });
  }

  Widget buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isLogout
                    ? MealioColors.danger.withValues(alpha: 0.10)
                    : MealioColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isLogout ? MealioColors.danger : MealioColors.primary,
              ),
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
                      color: isLogout
                          ? MealioColors.danger
                          : MealioColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: MealioColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isLogout ? MealioColors.danger : MealioColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final displayName = name.isEmpty ? 'Your profile' : name;
    final displayEmail = email.isEmpty ? 'your@email.com' : email;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: MealioColors.surface,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: MealioColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 132,
                          height: 132,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                MealioColors.primary.withValues(alpha: 0.95),
                                MealioColors.primaryDeep,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: MealioColors.primary.withValues(
                                  alpha: 0.24,
                                ),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 42,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          displayName,
                          textAlign: TextAlign.center,
                          style: textTheme.displaySmall?.copyWith(
                            fontSize: 32,
                            color: MealioColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          displayEmail,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge?.copyWith(
                            color: MealioColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: MealioColors.surfaceWarm,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Mealio member',
                            style: textTheme.labelLarge?.copyWith(
                              color: MealioColors.primaryDeep,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Account settings',
                    style: textTheme.titleLarge?.copyWith(
                      color: MealioColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: MealioColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: MealioColors.border),
                    ),
                    child: Column(
                      children: [
                        buildMenuItem(
                          icon: Icons.person_outline,
                          title: 'Change name',
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChangeNamePage(),
                              ),
                            );
                            loadUser();
                          },
                        ),
                        const Divider(height: 1),
                        buildMenuItem(
                          icon: Icons.restaurant,
                          title: 'Food profile',
                          subtitle: 'Dietary requirements & allergies',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FoodProfilePage(),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        buildMenuItem(
                          icon: Icons.lock_outline,
                          title: 'Update password',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const UpdatePasswordPage(),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        buildMenuItem(
                          icon: Icons.logout,
                          title: 'Log out',
                          isLogout: true,
                          onTap: () {
                            showDialog<void>(
                              context: context,
                              builder: (dialogContext) {
                                final dialogTextTheme = Theme.of(
                                  dialogContext,
                                ).textTheme;

                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 72,
                                          height: 72,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: MealioColors.danger
                                                .withValues(alpha: 0.10),
                                          ),
                                          child: const Icon(
                                            Icons.logout,
                                            color: MealioColors.danger,
                                            size: 30,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          'Log out?',
                                          style: dialogTextTheme.titleLarge,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Are you sure you want to log out? You will need to enter your credentials to sign in again.',
                                          textAlign: TextAlign.center,
                                          style: dialogTextTheme.bodyMedium,
                                        ),
                                        const SizedBox(height: 24),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              await UserService.logout();
                                              if (!dialogContext.mounted) {
                                                return;
                                              }
                                              Navigator.of(dialogContext).pop();
                                              if (!context.mounted) return;
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WelcomePage(),
                                                ),
                                                (route) => false,
                                              );
                                            },
                                            child: const Text('Log out'),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop();
                                            },
                                            child: const Text('Cancel'),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
