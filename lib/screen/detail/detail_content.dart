import 'package:cookly_app/widgets/components/custom_navbar.dart';
import 'package:cookly_app/widgets/components/custom_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:cookly_app/theme/app_color.dart';
import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cookly_app/helper/formatduration.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int resepId;
  final VoidCallback? onBack;

  const RecipeDetailScreen({super.key, required this.resepId, this.onBack});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Future<Map<String, dynamic>> _recipeDetailFuture;

  // 🔍 Tambahan: hasil pencarian
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _recipeDetailFuture = _getRecipeDetail();
  }

  Future<Map<String, dynamic>> _getRecipeDetail() async {
    try {
      final recipeData = await Supabase.instance.client
          .from('resep')
          .select()
          .eq('resep_id', widget.resepId)
          .single();

      final ingredients = await Supabase.instance.client
          .from('resep_bahan')
          .select('jumlah, bahan(nama_bahan)')
          .eq('resep_id', widget.resepId);

      final steps = await Supabase.instance.client
          .from('langkah_resep')
          .select()
          .eq('resep_id', widget.resepId)
          .order('urutan', ascending: true);

      return {'recipe': recipeData, 'ingredients': ingredients, 'steps': steps};
    } catch (e) {
      throw Exception('Error loading recipe: $e');
    }
  }

  // 🔍 Fungsi untuk cari resep lain
  Future<void> _searchRecipes(String keyword) async {
    if (keyword.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    final result = await Supabase.instance.client
        .from('resep')
        .select('resep_id, judul, gambar_url, durasi')
        .ilike('judul', '%$keyword%');

    setState(() {
      _isSearching = true;
      _searchResults = List<Map<String, dynamic>>.from(result);
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
                  ? _buildSearchResults() // tampilkan hasil pencarian
                  : FutureBuilder<Map<String, dynamic>>(
                      future: _recipeDetailFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        final data = snapshot.data!;
                        final recipe = data['recipe'] as Map<String, dynamic>;
                        final ingredients = data['ingredients'] as List<dynamic>;
                        final steps = data['steps'] as List<dynamic>;

                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Gambar
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          recipe['gambar_url'] ?? '',
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

                                      // Judul
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: CustomText(
                                              text: recipe['judul'] ?? 'Untitled',
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Row(
                                            children: const [
                                              Icon(Icons.bookmark_border, color: Colors.grey),
                                              SizedBox(width: 12),
                                              Icon(Icons.share, color: Colors.grey),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),

                                      // Durasi
                                      Row(
                                        children: [
                                          const Icon(Icons.timer, color: AppColors.primary, size: 20),
                                          const SizedBox(width: 8),
                                          CustomText(
                                            text: formatDuration(recipe['durasi']),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 28),
                                      const Divider(color: Color(0xFFF1F1F1)),

                                      // Bahan
                                      const SectionTitle("Bahan-bahan"),
                                      const SizedBox(height: 12),
                                      _buildIngredientsList(ingredients),
                                      const SizedBox(height: 28),
                                      const Divider(color: Color(0xFFF1F1F1)),

                                      // Langkah
                                      const SectionTitle("Langkah-langkah"),
                                      const SizedBox(height: 12),
                                      _buildStepsList(steps),
                                      const SizedBox(height: 80),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  //Widget hasil pencarian
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
            // Navigasi ke detail resep lain
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

  Widget _buildIngredientsList(List<dynamic> ingredients) {
    if (ingredients.isEmpty) {
      return const SectionText("Tidak ada bahan yang tersedia.");
    }

    String ingredientsText = ingredients
        .map((item) {
          final jumlah = item['jumlah'] ?? '';
          final namaBahan = item['bahan']?['nama_bahan'] ?? '';
          return '$jumlah $namaBahan';
        })
        .join('\n');

    return SectionText(ingredientsText);
  }

  Widget _buildStepsList(List<dynamic> steps) {
    if (steps.isEmpty) {
      return const SectionText("Tidak ada langkah yang tersedia.");
    }

    String stepsText = steps
        .map((step) {
          final urutan = step['urutan'] ?? 0;
          final deskripsi = step['deskripsi'] ?? '';
          return '$urutan. $deskripsi';
        })
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
