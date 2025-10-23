import 'package:cookly_app/data/models/recipes_model.dart';
import 'package:cookly_app/data/repository/recipes_repository.dart';
import 'package:cookly_app/screen/detail/allrecipe_screen.dart';
import 'package:cookly_app/screen/detail/detail_content.dart';
import 'package:cookly_app/theme/app_color.dart';
import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:cookly_app/widgets/components/custom_recipe_card.dart';
import 'package:cookly_app/helper/formatduration.dart';

class DrinkSection extends StatefulWidget {
  const DrinkSection({super.key});

  @override
  State<DrinkSection> createState() => _DrinkSectionState();
}

class _DrinkSectionState extends State<DrinkSection> {
  late final Future<List<Recipe>> _drinkRecipesFuture;
  final repo = RecipesRepository();

  @override
  void initState() {
    super.initState();
    _drinkRecipesFuture = _getDrinkRecipes();
  }

  // Fungsi untuk mengambil resep minuman
  Future<List<Recipe>> _getDrinkRecipes() async {
    final data = await repo.getAllRecipes(kategoriFilter: 'Minuman', limit: 10);
    return data;
  }

  // Fungsi untuk menampilkan error dialog yang modern
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: CustomText(
                text: 'Oops, Terjadi Kesalahan',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CustomText(
            text: message,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF666666),
            textAlign: TextAlign.left,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CustomText(
              text: 'Tutup',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFF6B6B),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _drinkRecipesFuture = _getDrinkRecipes();
              });
            },
            child: const CustomText(
              text: 'Coba Lagi',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                text: 'Minuman',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              const Spacer(),
              GestureDetector(
                // Navigate ke halaman "Lihat semua minuman"
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const AllRecipesScreen(kategoriFilter: 'Minuman'),
                    ),
                  );
                },
                child: const CustomText(
                  text: 'Lihat Semua',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // FutureBuilder untuk mengambil data minuman dari Supabase
          SizedBox(
            width: double.infinity,
            height: 200,
            child: FutureBuilder<List<Recipe>>(
              future: _drinkRecipesFuture,
              builder: (context, snapshot) {
                // Loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error state
                if (snapshot.hasError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showErrorDialog(
                      context,
                      'Gagal memuat resep minuman. Periksa koneksi internet Anda.\n\nError: ${snapshot.error}',
                    );
                  });
                  return const Center(
                    child: CustomText(
                      text: 'Terjadi kesalahan saat memuat data',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF999999),
                    ),
                  );
                }

                // No data state
                final recipes = snapshot.data!;
                if (recipes.isEmpty) {
                  return const Center(
                    child: CustomText(
                      text: 'Tidak ada resep minuman.',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF999999),
                    ),
                  );
                }

                // Build recipe cards
                final List<Widget> recipeCards = recipes.map((recipe) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RecipeDetailScreen(resepId: recipe.id),
                          ),
                        );
                      },
                      child: CustomRecipeCard(
                        imageUrl: recipe.gambarUrl!,
                        title: recipe.name,
                        duration: formatDuration(recipe.durasi),
                        height: 150,
                        width: 150,
                        showDuration: true,
                      ),
                    ),
                  );
                }).toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: recipeCards,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
