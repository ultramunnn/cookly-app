import 'package:flutter/material.dart';
import 'package:cookly_app/theme/app_color.dart';
import 'package:cookly_app/widgets/components/custom_text.dart';

class CustomNavbar extends StatelessWidget {
  const CustomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // === LOGO KIRI ===
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Image.asset('assets/images/logo.png'),
              ),
              const SizedBox(width: 12),
              CustomText(
                text: 'Cookly',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ],
          ),

          // === IKON KANAN ===
          SizedBox(
            width: 44,
            height: 44,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none),
              color: Colors.black87,
              iconSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
