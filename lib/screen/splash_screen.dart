import 'dart:async';
import 'package:cookly_app/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cookly_app/screen/login_screen.dart';
import 'package:cookly_app/theme/app_color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    // kasih delay biar splash tetap kelihatan
    await Future.delayed(const Duration(seconds: 2));

    final session = Supabase.instance.client.auth.currentSession;

    if (!mounted) return;

    if (session != null) {
      // User sudah login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      // Belum login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash_logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 16),
            const Text(
              'Cookly',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
