import 'package:flutter/material.dart';
import 'package:mealio/Services/user_service.dart';

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

  Future<void> updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final result = await UserService.updatePassword(
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
      );

      if (!mounted) return;

      final statusCode = result["statusCode"];
      final data = result["data"];

      if (statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password Updated")),
        );
        Navigator.pop(context);
      } else {
        final message = _formatError(data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Connection Error")),
      );
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

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Update Password',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 25),
                const Text(
                  "Update Password",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Please enter your current password and choose a new one to secure your account",
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.6,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "Current Password",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: oldPasswordController,
                  obscureText: isCurrentPasswordHidden,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                  decoration:
                      _inputDecoration("Input Current Password").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        isCurrentPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFF64748B),
                      ),
                      onPressed: () {
                        setState(() {
                          isCurrentPasswordHidden = !isCurrentPasswordHidden;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "New Password",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: isNewPasswordHidden,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 8) {
                      return 'Must be at least 8 characters';
                    }
                    if (!RegExp(r'(?=.*[a-z])(?=.*[A-Z])(?=.*\d)')
                        .hasMatch(value)) {
                      return 'Must contain uppercase, lowercase & a number';
                    }
                    return null;
                  },
                  decoration: _inputDecoration("Input New Password").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        isNewPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFF64748B),
                      ),
                      onPressed: () {
                        setState(() {
                          isNewPasswordHidden = !isNewPasswordHidden;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Must be at least 8 characters long.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.6,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "Confirm New Password",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: confirmNewPasswordController,
                  obscureText: isConfirmNewPasswordHidden,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password';
                    }
                    if (value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  decoration:
                      _inputDecoration("Input Confirm New Password").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConfirmNewPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFF64748B),
                      ),
                      onPressed: () {
                        setState(() {
                          isConfirmNewPasswordHidden =
                              !isConfirmNewPasswordHidden;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: updatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF26A3D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Update Password",
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
      ),
    );
  }
}
