import 'package:flutter/material.dart';
import 'package:cookly_app/theme/app_color.dart';
import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:cookly_app/widgets/components/custom_searchbar.dart';
import 'package:cookly_app/helper/formatduration.dart';
import 'package:cookly_app/screen/detail/detail_content.dart';
import 'package:cookly_app/data/repository/recipes_repository.dart';
import 'package:cookly_app/data/models/recipes_model.dart';

class AllRecipesScreen extends StatefulWidget {
  final String? kategoriFilter;

  const AllRecipesScreen({super.key, this.kategoriFilter});

  @override
  State<AllRecipesScreen> createState() => _AllRecipesScreenState();
}

class _AllRecipesScreenState extends State<AllRecipesScreen> {
  final repo = RecipesRepository();
  List<Recipe> allRecipes = [];
  List<Recipe> filteredRecipes = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    setState(() => isLoading = true);
    final result = await repo.getAllRecipes(kategoriFilter: widget.kategoriFilter);
    setState(() {
      allRecipes = result;
      filteredRecipes = result;
      isLoading = false;
    });
  }

  void _searchRecipe(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      searchQuery = query;
      filteredRecipes = allRecipes.where((r) {
        final nama = r.name.toLowerCase();
        final deskripsi = r.deskripsi?.toLowerCase() ?? '';
        final kategori = r.kategori?.toLowerCase() ?? '';
        return nama.contains(lowerQuery) ||
            deskripsi.contains(lowerQuery) ||
            kategori.contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.kategoriFilter == null
        ? "Semua Resep"
        : "Semua ${widget.kategoriFilter!.capitalize()}";

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _loadRecipes,
              child: Column(
                children: [
                  // 🔍 Searchbar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: CustomSearchbar(
                      hintText: 'Cari resep...',
                      onSearch: _searchRecipe,
                    ),
                  ),

                  if (searchQuery.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          text: 'Ditemukan ${filteredRecipes.length} resep',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600]!,
                        ),
                      ),
                    ),

                  Expanded(
                    child: filteredRecipes.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                            itemCount: filteredRecipes.length,
                            itemBuilder: (context, index) {
                              return _buildRecipeCard(filteredRecipes[index]);
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildRecipeCard(Recipe resep) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeDetailScreen(resepId: resep.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🖼️ Gambar
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: resep.gambarUrl != null
                      ? Image.network(
                          resep.gambarUrl!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
                        )
                      : _buildPlaceholderImage(),
                ),
                const SizedBox(width: 12),

                // 📄 Konten
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: resep.name,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 6),

                      if (resep.kategori != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: CustomText(
                            text: resep.kategori!,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],

                      CustomText(
                        text: resep.deskripsi ?? 'Tidak ada deskripsi',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600]!,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),

                      if (resep.durasi != null)
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined,
                                size: 16, color: AppColors.primary),
                            const SizedBox(width: 4),
                            CustomText(
                              text: formatDuration(resep.durasi!),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.restaurant, size: 40, color: Colors.grey[400]),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            searchQuery.isEmpty ? Icons.restaurant_menu : Icons.search_off,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          CustomText(
            text: searchQuery.isEmpty
                ? "Belum ada resep tersedia."
                : "Tidak ada hasil untuk \"$searchQuery\"",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

extension StringCasing on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
