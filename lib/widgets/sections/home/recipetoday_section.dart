import 'package:cookly_app/screen/detail/detail_content.dart';
import 'package:cookly_app/theme/app_color.dart';
import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:cookly_app/widgets/components/custom_recipe_card.dart';

class RecipytodaySection extends StatefulWidget {
  const RecipytodaySection({super.key});

  @override
  State<RecipytodaySection> createState() => _RecipytodaySectionState();
}

class _RecipytodaySectionState extends State<RecipytodaySection> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recipes = [
      {
        'image': 'assets/foods/rendang.jpeg',
        'title': 'Rendang',
        'duration': '1.5 jam',
        'height': 120,
        'width': 120,
      },
      {
        'image': 'assets/foods/bakso.jpeg',
        'title': 'Bakso',
        'duration': '1 - 2 jam',
        'height': 120,
        'width': 120,
      },
    ];

    // Ubah list data menjadi list widget
    final List<Widget> recipeCards = recipes.map((recipe) {
      return Padding(
        padding: const EdgeInsets.only(right: 8), // jarak antar kartu
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(
                  image: recipe['image']!,
                  duration: recipe['duration']!,
                  title: recipe['title']!,
                ),
              ),
            );
          },
          child: CustomRecipeCard(
            imageAsset: recipe['image']!,
            titleCenter: recipe['title'],
            duration: recipe['duration'],
            height: recipe['height']!,
            width: recipe['width']!,
          ),
        ),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul Section (opsional)
          Row(
            children: [
              const CustomText(
                text: 'Masakan Hari Ini',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Scroll horizontal
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start, // pastikan ke kiri
                children: recipeCards,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
