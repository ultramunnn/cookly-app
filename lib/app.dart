import 'package:cookly_app/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:cookly_app/theme/app_color.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cookly",
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.primary,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: AppColors.textSecondary),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
