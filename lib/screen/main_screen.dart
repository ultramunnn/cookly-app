import 'package:cookly_app/screen/content/home_content.dart';
import 'package:cookly_app/screen/create_screen.dart';
import 'package:cookly_app/screen/detail/allrecipe_screen.dart';
import 'package:cookly_app/screen/profile_screen.dart';
import 'package:cookly_app/screen/favorite_screen.dart';
import 'package:flutter/material.dart';
import 'package:cookly_app/widgets/components/custom_bottom_navbar.dart';
import 'package:cookly_app/theme/app_color.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const AllRecipesScreen(),
    const Center(child: TambahResepScreen()),
    const FavoriteScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Konten halaman
            Positioned.fill(child: _pages[_selectedIndex]),

            // Bottom Navigation
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomBottomNavBar(
                selectedIndex: _selectedIndex,
                onItemTapped: _onItemTapped,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
