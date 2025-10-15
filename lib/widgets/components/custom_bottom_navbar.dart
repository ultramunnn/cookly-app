import 'package:flutter/material.dart';
import 'package:cookly_app/theme/app_color.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    // Daftar icon dari folder assets/icon/
    final icons = [
      'assets/icon/home.png',
      'assets/icon/menu_book.png',
      'assets/icon/add.png', // tombol tengah
      'assets/icon/favorite.png',
      'assets/icon/profile.png',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFF1F1F1), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(icons.length, (index) {
          if (index == 2) {
            // Tombol tengah — tombol utama
            return GestureDetector(
              onTap: () => onItemTapped(index),
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    icons[index],
                    width: 56,
                    height: 56,
                    // jangan pakai color agar warna asli icon terlihat
                  ),
                ),
              ),
            );
          } else {
            // Tombol biasa (home, menu, favorite, profile)
            return GestureDetector(
              onTap: () => onItemTapped(index),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedIndex == index
                      ? AppColors.primary.withOpacity(0.15)
                      : Colors.transparent,
                ),
                child: Center(
                  child: Image.asset(
                    icons[index],
                    width: 26,
                    height: 26,
                    color: selectedIndex == index
                        ? AppColors.primary
                        : const Color(0xFFBDBDBD),
                  ),
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
