import 'package:flutter/material.dart';
import 'package:cookly_app/data/models/recipes_model.dart';
import 'package:cookly_app/data/repository/recipes_repository.dart';
import 'package:cookly_app/helper/formatduration.dart';
import 'package:cookly_app/screen/detail/allrecipe_screen.dart';
import 'package:cookly_app/screen/detail/detail_content.dart';
import 'package:cookly_app/widgets/components/custom_linegap.dart';
import 'package:cookly_app/widgets/components/custom_navbar.dart';
import 'package:cookly_app/widgets/components/custom_searchbar.dart';
import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:cookly_app/widgets/sections/home/categoryfilter_section.dart';
import 'package:cookly_app/widgets/sections/home/drink_section.dart';
import 'package:cookly_app/widgets/sections/home/populerrecipe_section.dart';
import 'package:cookly_app/widgets/sections/home/recipetoday_section.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final RecipesRepository _repository = RecipesRepository();

  bool _isSearching = false;
  bool _isLoading = false;
  List<Recipe> _searchResults = [];

  

  /// Cari resep menggunakan repository
  Future<void> _searchRecipes(String keyword) async {
    if (keyword.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _isLoading = true;
    });

    try {
      final results = await _repository.searchRecipes(keyword);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error search: $e');
      setState(() => _isLoading = false);
    }
  }

  ///  Widget hasil pencarian
  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchResults.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CustomText(
            text: 'Tidak ada hasil ditemukan.',
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final resep = _searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                resep.gambarUrl ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            title: CustomText(
              text: resep.name ?? 'Tanpa Nama',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            subtitle: CustomText(
              text: formatDuration(resep.durasi),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600]!,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecipeDetailScreen(resepId: resep.id),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const CustomNavbar(),
          const SizedBox(height: 16),
          CustomSearchbar(hintText: 'Cari Resep...', onSearch: _searchRecipes),
          const SizedBox(height: 16),
          Expanded(
            child: _isSearching
                ? _buildSearchResults()
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const RecipytodaySection(),
                          const SizedBox(height: 24),
                          const LineGap(),
                          const SizedBox(height: 24),
                          const PopulerRecipe(),
                          const SizedBox(height: 24),
                          const LineGap(),
                          const SizedBox(height: 24),
                          CategoryFilterSection(
                            onSelected: (kategoriNama) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AllRecipesScreen(
                                    kategoriFilter: kategoriNama,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          const LineGap(),
                          const SizedBox(height: 24),
                          const DrinkSection(),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
