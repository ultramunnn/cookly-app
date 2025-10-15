import 'package:cookly_app/screen/content/home_content.dart';
import 'package:flutter/material.dart';
import 'package:cookly_app/widgets/components/custom_bottom_navbar.dart';
import 'package:cookly_app/theme/app_color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const Center(
      child: Text("Search Page", style: TextStyle(color: Colors.black)),
    ),
    const Center(
      child: Text("Add Something", style: TextStyle(color: Colors.black)),
    ),
    const Center(
      child: Text("Favorite Page", style: TextStyle(color: Colors.black)),
    ),
    const Center(
      child: Text("Profile Page", style: TextStyle(color: Colors.black)),
    ),
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
