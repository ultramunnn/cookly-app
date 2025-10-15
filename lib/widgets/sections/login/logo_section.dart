import 'package:flutter/material.dart';
import 'package:cookly_app/theme/app_color.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: Image.asset('assets/images/logo.png'),
        ),

        const SizedBox(height: 12),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Masak dengan ',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(text: ' '),
              TextSpan(
                text: 'Cookly',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: '!',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
