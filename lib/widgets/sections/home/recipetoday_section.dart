import 'package:cookly_app/data/models/recipes_model.dart';
import 'package:cookly_app/data/repository/recipes_repository.dart';
import 'package:cookly_app/screen/detail/detail_content.dart';
import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:cookly_app/widgets/components/custom_recipe_card.dart';
import 'package:cookly_app/helper/formatduration.dart';

class RecipytodaySection extends StatefulWidget {
  const RecipytodaySection({super.key});

  @override
  State<RecipytodaySection> createState() => _RecipytodaySectionState();
}

class _RecipytodaySectionState extends State<RecipytodaySection> {
  // Variabel untuk menampung future 
  Future<List<Recipe>>? _recipesFuture;
  final repo = RecipesRepository();

  @override
  void initState() {
    super.initState();
    _recipesFuture = _getRecipes();
  }

  // Fungsi untuk mengambil data dari tabel 'resep' 
  Future<List<Recipe>> _getRecipes() async {
    // Ambil data dari tabel 'resep'
    final data = await repo.getAllRecipes(
      limit: 10
    );
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
                _recipesFuture = _getRecipes();
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul Section
          const Row(
            children: [
              CustomText(
                text: 'Resep Hari Ini',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Scroll horizontal dengan FutureBuilder
          SizedBox(
            width: double.infinity,
            height: 150,
            child: FutureBuilder<List<Recipe>>(
              future: _recipesFuture, // Gunakan future yang sudah kita buat
              builder: (context, snapshot) {
                // 1. Tampilkan loading indicator saat data sedang diambil
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. Tampilkan error dialog jika terjadi kesalahan
                if (snapshot.hasError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showErrorDialog(
                      context,
                      'Gagal memuat resep. Periksa koneksi internet Anda.\n\nError: ${snapshot.error}',
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

                // 3. Jika data berhasil didapat dan tidak kosong
                final recipes = snapshot.data!;
                if (recipes.isEmpty) {
                  return const Center(
                    child: CustomText(
                      text: 'Tidak ada resep hari ini.',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF999999),
                    ),
                  );
                }

                // Ubah list data dari Supabase menjadi list widget
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
                        imageUrl: recipe.gambarUrl,
                        titleCenter: recipe.name,
                        duration: formatDuration(recipe.durasi),
                        height: 120,
                        width: 120,
                        showDuration: false,
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
