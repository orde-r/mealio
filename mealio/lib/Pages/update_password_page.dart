import 'package:flutter/material.dart';
import 'package:mealio/Services/user_service.dart';
import 'package:mealio/theme/mealio_theme.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  bool isCurrentPasswordHidden = true;
  bool isNewPasswordHidden = true;
  bool isConfirmNewPasswordHidden = true;

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final result = await UserService.updatePassword(
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
      );

      if (!mounted) return;

      final statusCode = result['statusCode'];
      final data = result['data'];

      if (statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Password updated')));
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
      ).showSnackBar(const SnackBar(content: Text('Connection Error')));
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

  Widget _passwordField({
    required TextEditingController controller,
    required bool obscureText,
    required String hintText,
    required VoidCallback onToggle,
    required String label,
    required String? Function(String?) validator,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.titleLarge?.copyWith(
            color: MealioColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: IconButton(
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Secure your account',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineSmall?.copyWith(
                        fontSize: 28,
                        color: MealioColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your current password and choose a new one to secure your account.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                        color: MealioColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _passwordField(
                      controller: oldPasswordController,
                      obscureText: isCurrentPasswordHidden,
                      hintText: 'Input current password',
                      label: 'Current password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your current password';
                        }
                        return null;
                      },
                      onToggle: () {
                        setState(() {
                          isCurrentPasswordHidden = !isCurrentPasswordHidden;
                        });
                      },
                    ),
                    const SizedBox(height: 18),
                    _passwordField(
                      controller: newPasswordController,
                      obscureText: isNewPasswordHidden,
                      hintText: 'Input new password',
                      label: 'New password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new password';
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
                      onToggle: () {
                        setState(() {
                          isNewPasswordHidden = !isNewPasswordHidden;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Must be at least 8 characters and include uppercase, lowercase, and a number.',
                      style: textTheme.bodySmall?.copyWith(
                        color: MealioColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _passwordField(
                      controller: confirmNewPasswordController,
                      obscureText: isConfirmNewPasswordHidden,
                      hintText: 'Confirm new password',
                      label: 'Confirm new password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password';
                        }
                        if (value != newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      onToggle: () {
                        setState(() {
                          isConfirmNewPasswordHidden =
                              !isConfirmNewPasswordHidden;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: updatePassword,
                      child: const Text('Update password'),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
