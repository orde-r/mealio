import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mealio/Pages/food_profile_page.dart';
import 'package:mealio/Pages/home_page.dart';
import 'package:mealio/Pages/register_page.dart';
import 'package:mealio/Services/auth_service.dart';
import 'package:mealio/theme/mealio_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  bool isPasswordHidden = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final result = await AuthService.login(
        email: emailController.text,
        password: passwordController.text,
      );

      if (!mounted) return;

      final statusCode = result["statusCode"];
      final data = result["data"];

      if (statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Login Success")));

        final hasCompletedOnboarding =
            data['user']['hasCompletedOnboarding'] ?? false;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => hasCompletedOnboarding
                ? const HomePage()
                : const FoodProfilePage(isOnboarding: true),
          ),
        );
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
                      'Welcome back',
                      textAlign: TextAlign.center,
                      style: textTheme.displaySmall?.copyWith(
                        fontSize: 40,
                        color: MealioColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Sign in to continue your culinary journey with Mealio.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(
                          fontSize: 18,
                          color: MealioColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                    Text(
                      'Email address',
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
                          return 'Please enter your password';
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
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: login,
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: textTheme.bodyMedium?.copyWith(
                            color: MealioColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            const TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: 'Sign up',
                              style: textTheme.bodyMedium?.copyWith(
                                color: MealioColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
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
