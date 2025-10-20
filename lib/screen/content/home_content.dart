import 'package:cookly_app/screen/detail/detail_content.dart';
import 'package:cookly_app/widgets/components/custom_linegap.dart';
import 'package:cookly_app/widgets/components/custom_navbar.dart';
import 'package:cookly_app/widgets/components/custom_searchbar.dart';
import 'package:cookly_app/widgets/sections/home/populerrecipe_section.dart';
import 'package:cookly_app/widgets/sections/home/recipetoday_section.dart';
import 'package:cookly_app/widgets/sections/home/categoryfilter_section.dart';
import 'package:cookly_app/widgets/sections/home/drink_section.dart';
import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final supabase = Supabase.instance.client;

  bool _isSearching = false;
  bool _isLoading = false;
  List<Map<String, dynamic>> _searchResults = [];

  /// Fungsi untuk mencari resep dari Supabase
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
      final results = await supabase
          .from('resep')
          .select('*, kategori(nama_kategori)')
          .ilike('judul', '%$keyword%');
      setState(() {
        _searchResults = List<Map<String, dynamic>>.from(results);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error search: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomNavbar(),
              CustomSearchbar(
                hintText: 'Cari Resep...',
                onSearch: _searchRecipes,
              ),
              const SizedBox(height: 24),

              // Jika sedang mencari, tampilkan hasilnya
              if (_isSearching)
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _searchResults.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: CustomText(
                          text: 'Tidak ada hasil ditemukan.',
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final resep = _searchResults[index];
                          final fotoUrl = resep['gambar_url'];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: fotoUrl != null
                                    ? Image.network(
                                        fotoUrl,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.fastfood,
                                          color: Colors.white70,
                                        ),
                                      ),
                              ),
                              title: CustomText(
                                text: resep['judul'] ?? 'Tanpa Nama',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              subtitle: CustomText(
                                text:
                                    resep['kategori']?['nama_kategori'] ??
                                    'Tidak ada kategori',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600]!,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RecipeDetailScreen(
                                      resepId: resep['resep_id'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      )
              else ...[
                // Jika tidak mencari, tampilkan konten default
                const RecipytodaySection(),
                const SizedBox(height: 24),
                const LineGap(),
                const SizedBox(height: 24),
                const PopulerRecipe(),
                const SizedBox(height: 24),
                const LineGap(),
                const SizedBox(height: 24),
                CategoryFilterSection(
                  onSelected: (value) {
                    debugPrint('Kategori dipilih: $value');
                  },
                ),
                const SizedBox(height: 24),
                const LineGap(),
                const SizedBox(height: 24),
                const DrinkSection(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
