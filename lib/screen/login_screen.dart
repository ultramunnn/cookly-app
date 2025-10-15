import 'package:cookly_app/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cookly_app/theme/app_color.dart';
import '../widgets/sections/login/logo_section.dart';
import '../widgets/components/custom_text_field.dart';
import '../widgets/components/custom_button.dart';
import '../widgets/sections/login/divider_section.dart';
import 'package:cookly_app/widgets/sections/login/social_login_section.dart';
import '../widgets/sections/login/register_section.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

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
                CustomTextField(
                  hintText: 'Masukkan Username`',
                  controller: usernameController,
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  hintText: 'Masukkan Password',
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Login',
                  onPressed: () {
                    print('=== LOGIN BUTTON PRESSED ===');
                    print('Username: ${usernameController.text}');
                    print('Password: ${passwordController.text}');

                    try {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                      print('Navigation executed');
                    } catch (e) {
                      print('Navigation error: $e');
                    }
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  'Lupa kata sandi Anda',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 32),

                const RegisterSection(),
                const SizedBox(height: 32),
                const DividerSection(),
                const SizedBox(height: 32),
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
