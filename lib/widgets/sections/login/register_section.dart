import 'package:flutter/material.dart';
import 'package:cookly_app/theme/app_color.dart';

class RegisterSection extends StatelessWidget {
  const RegisterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'Belum punya akun? ',
            style: TextStyle(
              color: Color(0xFF444444),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: 'Daftar sekarang',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
