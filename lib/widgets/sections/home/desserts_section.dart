import 'package:cookly_app/screen/detail/detail_content.dart';
import 'package:cookly_app/theme/app_color.dart';
import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:cookly_app/widgets/components/custom_recipe_card.dart';

class DessertsSection extends StatefulWidget {
  const DessertsSection({super.key});

  @override
  State<DessertsSection> createState() => _DessertsSectionState();
}

class _DessertsSectionState extends State<DessertsSection> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recipes = [
      {
        'image': 'assets/foods/rendang.jpeg',
        'title': 'Rendang',
        'duration': '1.5 jam',
        'height': 175,
        'width': 175,
      },
      {
        'image': 'assets/foods/rendang.jpeg',
        'title': 'Rendang',
        'duration': '1.5 jam',
        'height': 175,
        'width': 175,
      },
      {
        'image': 'assets/foods/rendang.jpeg',
        'title': 'Rendang',
        'duration': '1.5 jam',
        'height': 175,
        'width': 175,
      },
    ];

    // Ubah list data menjadi list widget dengan jarak antar kartu
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
                  title: recipe['title']!,
                  duration: recipe['duration']!,
                ),
              ),
            );
          },
          child: CustomRecipeCard(
            imageAsset: recipe['image']!,
            title: recipe['title'],
            duration: recipe['duration'],
            height: recipe['height']!,
            width: recipe['width']!,
          ),
        ),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20), // margin section
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Makanan Penutup',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              Spacer(),
              CustomText(
                text: 'Lihat Semua',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
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
