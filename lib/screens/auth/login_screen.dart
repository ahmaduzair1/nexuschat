import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLogin = true;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final auth = ref.read(authServiceProvider);
      if (_isLogin) {
        await auth.signIn(_emailCtrl.text.trim(), _passCtrl.text);
      } else {
        await auth.register(_emailCtrl.text.trim(), _passCtrl.text, _nameCtrl.text.trim());
      }
      // Auth wrapper will handle navigation on success
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo/Brand
                Icon(Icons.hub_rounded, size: 80, color: AppColors.emeraldPrimary),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Nexus',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.silverText,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  'Communication, evolved.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.silverMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // Fields
                if (!_isLogin) ...[
                  TextFormField(
                    controller: _nameCtrl,
                    style: const TextStyle(color: AppColors.silverText),
                    decoration: const InputDecoration(hintText: 'Full Name'),
                    validator: (v) => v!.isEmpty ? 'Enter your name' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                TextFormField(
                  controller: _emailCtrl,
                  style: const TextStyle(color: AppColors.silverText),
                  decoration: const InputDecoration(hintText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => !v!.contains('@') ? 'Enter valid email' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _passCtrl,
                  style: const TextStyle(color: AppColors.silverText),
                  decoration: const InputDecoration(hintText: 'Password'),
                  obscureText: true,
                  validator: (v) => v!.length < 6 ? 'Password too short' : null,
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emeraldPrimary,
                    foregroundColor: AppColors.navyBackground,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusFull),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.navyBackground),
                        )
                      : Text(
                          _isLogin ? 'Sign In' : 'Create Account',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                ),

                // Toggle
                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(
                    _isLogin ? 'Need an account? Register' : 'Already have an account? Sign in',
                    style: const TextStyle(color: AppColors.emeraldPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
