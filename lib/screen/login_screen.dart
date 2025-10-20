import 'package:cookly_app/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:cookly_app/theme/app_color.dart';
import 'package:cookly_app/widgets/sections/login/logo_section.dart';
import 'package:cookly_app/widgets/components/custom_text_field.dart';
import 'package:cookly_app/widgets/components/custom_button.dart';
import 'package:cookly_app/widgets/sections/login/divider_section.dart';
import 'package:cookly_app/widgets/sections/login/social_login_section.dart';
import 'package:cookly_app/widgets/sections/login/register_section.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Harap isi email dan password');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        _showErrorDialog(
          'Login gagal, periksa kembali email dan password Anda.',
        );
      }
    } catch (e) {
      _showErrorDialog('Terjadi kesalahan saat login. Coba lagi');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Gagal Masuk',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        content: Text(message, style: const TextStyle(fontSize: 15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                const LogoSection(),
                const SizedBox(height: 56),

                // Email
                CustomTextField(
                  hintText: 'Masukkan Email',
                  controller: emailController,
                ),
                const SizedBox(height: 32),

                // Password
                CustomTextField(
                  hintText: 'Masukkan Password',
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 32),

                // Tombol login
                _isLoading
                    ? const CircularProgressIndicator(color: AppColors.primary)
                    : CustomButton(text: 'Login', onPressed: _login),

                const SizedBox(height: 12),
                Text(
                  'Lupa kata sandi Anda?',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 32),
                const RegisterSection(),
                const SizedBox(height: 32),
                const DividerSection(),
                const SizedBox(height: 32),
                const SocialLoginSection(),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
