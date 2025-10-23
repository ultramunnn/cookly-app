import 'package:cookly_app/data/repository/recipes_repository.dart';
import 'package:cookly_app/data/models/recipes_model.dart';
import 'package:cookly_app/widgets/components/custom_navbar.dart';
import 'package:cookly_app/widgets/components/custom_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:cookly_app/theme/app_color.dart';
import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:cookly_app/helper/formatduration.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int resepId;
  final VoidCallback? onBack;

  const RecipeDetailScreen({super.key, required this.resepId, this.onBack});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final repo = RecipesRepository();

  late Future<Recipe> _recipeFuture;
  late Future<List<Map<String, dynamic>>> _ingredientsFuture;
  late Future<List<Map<String, dynamic>>> _stepsFuture;
  late Future<List<String>> _equipmentsFuture;

  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  void _loadRecipe() {
    _recipeFuture = repo.getRecipeDetail(widget.resepId);
    _ingredientsFuture = repo.getIngredients(widget.resepId);
    _stepsFuture = repo.getSteps(widget.resepId);
    _equipmentsFuture = repo.getEquipments(widget.resepId);
  }

  Future<void> _searchRecipes(String keyword) async {
    if (keyword.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    final results = await repo.searchRecipes(keyword);
    setState(() {
      _isSearching = true;
      _searchResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomNavbar(),
            const SizedBox(height: 16),
            CustomSearchbar(
              hintText: 'Cari resep lain...',
              onSearch: (keyword) => _searchRecipes(keyword),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isSearching
                  ? _buildSearchResults()
                  : FutureBuilder<Recipe>(
                      future: _recipeFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        final recipe = snapshot.data!;
                        return _buildRecipeDetail(recipe);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeDetail(Recipe recipe) {
    return FutureBuilder(
      future: Future.wait([
        _ingredientsFuture,
        _stepsFuture,
        _equipmentsFuture,
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final ingredients = snapshot.data![0] as List<Map<String, dynamic>>;
        final steps = snapshot.data![1] as List<Map<String, dynamic>>;
        final peralatan = snapshot.data![2] as List<String>;

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    recipe.gambarUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 250,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        text: recipe.name,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.bookmark_border, color: Colors.grey),
                        SizedBox(width: 12),
                        Icon(Icons.share, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.timer, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    CustomText(
                      text: formatDuration(recipe.durasi),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Divider(color: Color(0xFFF1F1F1)),

                const SectionTitle("Bahan-bahan"),
                const SizedBox(height: 12),
                _buildIngredientsList(ingredients),
                const SizedBox(height: 28),

                const SectionTitle("Peralatan"),
                const SizedBox(height: 12),
                _buildPeralatanList(peralatan),
                const SizedBox(height: 28),
                const Divider(color: Color(0xFFF1F1F1)),

                const SectionTitle("Langkah-langkah"),
                const SizedBox(height: 12),
                _buildStepsList(steps),
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(child: Text('Tidak ada hasil.'));
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final resep = _searchResults[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(resep['gambar_url'] ?? ''),
            backgroundColor: Colors.grey[200],
          ),
          title: Text(resep['judul']),
          subtitle: Text(formatDuration(resep['durasi'])),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeDetailScreen(resepId: resep['resep_id']),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildIngredientsList(List<Map<String, dynamic>> ingredients) {
    if (ingredients.isEmpty) {
      return const SectionText("Tidak ada bahan yang tersedia.");
    }

    String ingredientsText = ingredients
        .map(
          (item) =>
              "${item['jumlah'] ?? ''} ${item['bahan']?['nama_bahan'] ?? ''}",
        )
        .join('\n');

    return SectionText(ingredientsText);
  }

  Widget _buildPeralatanList(List<String> peralatan) {
    if (peralatan.isEmpty) {
      return const SectionText("Tidak ada peralatan yang diperlukan.");
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: peralatan
          .map(
            (alat) => Chip(
              label: Text(
                alat,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
              backgroundColor: AppColors.primary.withOpacity(0.08),
            ),
          )
          .toList(),
    );
  }

  Widget _buildStepsList(List<Map<String, dynamic>> steps) {
    if (steps.isEmpty) {
      return const SectionText("Tidak ada langkah yang tersedia.");
    }

    String stepsText = steps
        .map((step) => "${step['urutan'] ?? 0}. ${step['deskripsi'] ?? ''}")
        .join('\n');

    return SectionText(stepsText);
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: text,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.primary,
      textAlign: TextAlign.left,
    );
  }
}

class SectionText extends StatelessWidget {
  final String text;
  const SectionText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: text,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF444444),
      textAlign: TextAlign.left,
    );
  }
}
