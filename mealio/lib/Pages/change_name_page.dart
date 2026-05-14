import 'package:flutter/material.dart';
import 'package:mealio/Services/user_service.dart';
import 'package:mealio/theme/mealio_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeNamePage extends StatefulWidget {
  const ChangeNamePage({super.key});

  @override
  State<ChangeNamePage> createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentName();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentName() async {
    final prefs = await SharedPreferences.getInstance();
    nameController.text = prefs.getString('name') ?? '';
  }

  Future<void> changeName() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final result = await UserService.changeName(name: nameController.text);

      if (!mounted) return;

      final statusCode = result['statusCode'];
      final data = result['data'];

      if (statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', nameController.text);

        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Name updated')));
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
                      'Update your display name',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineSmall?.copyWith(
                        fontSize: 28,
                        color: MealioColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This is the name shown across Mealio.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                        color: MealioColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Full name',
                      style: textTheme.titleLarge?.copyWith(
                        color: MealioColors.textSecondary,
                        fontWeight: FontWeight.w700,
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
                    const SizedBox(height: 16),
                    Text(
                      'Use a name that is easy for your restaurants and friends to recognize.',
                      style: textTheme.bodySmall?.copyWith(
                        color: MealioColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: changeName,
                      child: const Text('Save changes'),
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
