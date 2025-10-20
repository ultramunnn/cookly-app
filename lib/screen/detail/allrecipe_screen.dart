import 'package:cookly_app/screen/detail/detail_content.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cookly_app/theme/app_color.dart';
import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:cookly_app/widgets/components/custom_searchbar.dart';

class AllRecipesScreen extends StatefulWidget {
  final String? kategoriFilter; // Contoh: 'minuman', 'makanan', dll.

  const AllRecipesScreen({super.key, this.kategoriFilter});

  @override
  State<AllRecipesScreen> createState() => _AllRecipesScreenState();
}

class _AllRecipesScreenState extends State<AllRecipesScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> allRecipes = [];
  List<Map<String, dynamic>> filteredRecipes = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  //Ambil data resep dari Supabase (opsional dengan filter kategori)
  Future<void> _loadRecipes() async {
    setState(() => isLoading = true);

    try {
      // Jika ada filter kategori
      if (widget.kategoriFilter != null && widget.kategoriFilter!.isNotEmpty) {
        final kategoriName = widget.kategoriFilter!.trim();

        // Ambil ID kategori dari nama_kategori
        final kategoriResp = await supabase
            .from('kategori')
            .select('kategori_id')
            .eq('nama_kategori', kategoriName)
            .maybeSingle();

        if (kategoriResp == null) {
          debugPrint('Kategori $kategoriName tidak ditemukan');
          setState(() {
            allRecipes = [];
            filteredRecipes = [];
            isLoading = false;
          });
          return;
        }

        final kategoriId = kategoriResp['kategori_id'];

        //Query resep berdasarkan kategori_id
        final response = await supabase
            .from('resep')
            .select('*, kategori(nama_kategori)')
            .eq('kategori_id', kategoriId);

        setState(() {
          allRecipes = List<Map<String, dynamic>>.from(response);
          filteredRecipes = allRecipes;
          isLoading = false;
        });
      } else {
        //Jika tidak ada filter, ambil semua resep
        final response = await supabase
            .from('resep')
            .select('*, kategori(nama_kategori)');

        setState(() {
          allRecipes = List<Map<String, dynamic>>.from(response);
          filteredRecipes = allRecipes;
          isLoading = false;
        });
      }
    } catch (e, st) {
      debugPrint('Error loading recipes: $e\n$st');
      setState(() => isLoading = false);
    }
  }

  //Fungsi pencarian resep berdasarkan nama, deskripsi, atau kategori
  void _searchRecipe(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      searchQuery = query;
      filteredRecipes = allRecipes.where((recipe) {
        final nama = recipe['judul']?.toString().toLowerCase() ?? '';
        final deskripsi = recipe['deskripsi']?.toString().toLowerCase() ?? '';
        final kategori =
            recipe['kategori']?['nama_kategori']?.toString().toLowerCase() ??
            '';
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
        title: Text(title, style: const TextStyle(color: AppColors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadRecipes,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    // 🔍 Searchbar
                    CustomSearchbar(
                      hintText: 'Cari resep...',
                      onSearch: _searchRecipe,
                    ),
                    const SizedBox(height: 16),

                    // 📋 Daftar resep
                    Expanded(
                      child: filteredRecipes.isEmpty
                          ? Center(
                              child: CustomText(
                                text: searchQuery.isEmpty
                                    ? "Belum ada resep tersedia."
                                    : "Tidak ada hasil untuk \"$searchQuery\"",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: filteredRecipes.length,
                              itemBuilder: (context, index) {
                                final resep = filteredRecipes[index];
                                final fotoUrl = resep['gambar_url'];

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(12),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: fotoUrl != null
                                          ? Image.network(
                                              fotoUrl,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.fastfood,
                                                color: Colors.white70,
                                              ),
                                            ),
                                    ),
                                    title: CustomText(
                                      text: resep['judul'] ?? 'Tanpa Nama',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    subtitle: CustomText(
                                      text:
                                          resep['deskripsi'] ??
                                          'Tidak ada deskripsi',
                                      fontSize: 13,
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
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

/// 🔤 Extension untuk kapitalisasi huruf pertama
extension StringCasing on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
