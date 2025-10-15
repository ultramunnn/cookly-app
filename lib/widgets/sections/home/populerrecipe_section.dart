import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:cookly_app/widgets/components/custom_recipe_card.dart';

class PopulerRecipe extends StatefulWidget {
  const PopulerRecipe({super.key});

  @override
  State<PopulerRecipe> createState() => _PopulerRecipeState();
}

class _PopulerRecipeState extends State<PopulerRecipe> {
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
        'image': 'assets/foods/bakso.jpeg',
        'title': 'Bakso',
        'duration': '1 - 2 jam',
        'height': 175,
        'width': 175,
      },
      {
        'image': 'assets/foods/nasigoreng.jpeg',
        'title': 'Nasi Goreng',
        'duration': '20 menit',
        'height': 175,
        'width': 175,
      },
    ];

    // Ubah list data menjadi list widget dengan jarak antar kartu
    final List<Widget> recipeCards = recipes.map((recipe) {
      return Padding(
        padding: const EdgeInsets.only(right: 8), // jarak antar kartu
        child: CustomRecipeCard(
          imageAsset: recipe['image']!,
          title: recipe['title'],
          duration: recipe['duration'],
          height: recipe['height']!,
          width: recipe['width']!,
        ),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20), // margin section
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Masakan Populer',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
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
