import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:mealio/Pages/login_page.dart';
import 'package:mealio/Pages/privacy_page.dart';
import 'package:mealio/Pages/terms_page.dart';
import 'package:mealio/Services/auth_service.dart';
import 'package:mealio/theme/mealio_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  bool isPasswordHidden = true;
  bool isConfirmPassordHidden = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final result = await AuthService.register(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      if (!mounted) return;

      final statusCode = result["statusCode"];
      final data = result["data"];

      if (statusCode == 200 || statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Register Success")));

        Navigator.pop(context);
      } else {
        final message = _formatError(data);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Connection Error")));
    }
  }

  String _formatError(Map<String, dynamic>? data) {
    if (data == null) return 'Something went wrong';

    final details = data['details'];
    if (details is List && details.isNotEmpty) {
      return details.map((d) => d['message'] as String).join('\n');
    }

    return data['error'] as String? ?? 'Something went wrong';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Create your Mealio account',
                      textAlign: TextAlign.center,
                      style: textTheme.displaySmall?.copyWith(
                        fontSize: 36,
                        color: MealioColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Join us to get personalized meal recommendations.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(
                          fontSize: 18,
                          color: MealioColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 34),
                    Text(
                      'Full name',
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: MealioColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        if (value.trim().length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(hintText: 'Your name'),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Email',
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: MealioColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'hello@example.com',
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Password',
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: MealioColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      obscureText: isPasswordHidden,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 8) {
                          return 'Must be at least 8 characters';
                        }
                        if (!RegExp(
                          r'(?=.*[a-z])(?=.*[A-Z])(?=.*\d)',
                        ).hasMatch(value)) {
                          return 'Must contain uppercase, lowercase & a number';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(
                            hintText: 'Input password',
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordHidden = !isPasswordHidden;
                                });
                              },
                            ),
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Must be at least 8 characters long.',
                      style: textTheme.bodySmall?.copyWith(
                        color: MealioColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Must contain uppercase, lowercase, and a number.',
                      style: textTheme.bodySmall?.copyWith(
                        color: MealioColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Confirm password',
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: MealioColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: isConfirmPassordHidden,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(
                            hintText: 'Confirm password',
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                isConfirmPassordHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  isConfirmPassordHidden =
                                      !isConfirmPassordHidden;
                                });
                              },
                            ),
                          ),
                    ),
                    const SizedBox(height: 22),
                    RichText(
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
                    const SizedBox(height: 22),
                    ElevatedButton(
                      onPressed: register,
                      child: const Text('Create Account'),
                    ),
                    const SizedBox(height: 26),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: textTheme.bodyMedium?.copyWith(
                            color: MealioColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            const TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Log in',
                              style: textTheme.bodyMedium?.copyWith(
                                color: MealioColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }
}
