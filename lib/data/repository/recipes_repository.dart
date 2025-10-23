import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cookly_app/data/models/recipes_model.dart';

class RecipesRepository {
  final _client = Supabase.instance.client;

  // Ambil detail 1 resep + relasi kategori, bahan, langkah, dan peralatan
  Future<Recipe> getRecipeDetail(int id) async {
    try {
      final recipeData = await _client
          .from('resep')
          .select('''
            resep_id, judul, deskripsi, durasi, gambar_url,
            kategori(nama_kategori),
            resep_bahan(jumlah, bahan(nama_bahan)),
            langkah_resep(urutan, deskripsi),
            resep_peralatan(peralatan(nama_peralatan))
            ''')
          .eq('resep_id', id)
          .single();

      return Recipe.fromJson(recipeData);
    } catch (e, st) {
      throw Exception('Error loading recipe detail: $e\n$st');
    }
  }

  //  Cari resep berdasarkan keyword judul
  Future<List<Recipe>> searchRecipes(String keyword) async {
    try {
      final result = await _client
          .from('resep')
          .select('''
            resep_id, judul, gambar_url, durasi, deskripsi,
            kategori(nama_kategori)
            ''')
          .ilike('judul', '%$keyword%');

      return (result as List)
          .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error searching recipes: $e');
    }
  }

  Future<List<Recipe>> getAllRecipes({
    String? kategoriFilter,
    int? limit,
  }) async {
    try {
      // Gunakan dynamic untuk menghindari type issues
      dynamic query = _client.from('resep').select('''
      resep_id,
      judul,
      gambar_url,
      durasi,
      deskripsi,
      kategori_id,
      kategori(nama_kategori)
    ''');

      // Handle kategori filter
      if (kategoriFilter != null && kategoriFilter.isNotEmpty) {
        final kategori = await _client
            .from('kategori')
            .select('kategori_id')
            .eq('nama_kategori', kategoriFilter.trim())
            .maybeSingle();

        if (kategori != null) {
          query = query.eq('kategori_id', kategori['kategori_id']);
        } else {
          return [];
        }
      }

      // Handle limit
      if (limit != null && limit > 0) {
        query = query.limit(limit);
      }

      final response = await query;

      return (response as List).map((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error getAllRecipes: $e');
    }
  }

  // Ambil daftar bahan
  Future<List<Map<String, dynamic>>> getIngredients(int resepId) async {
    try {
      final ingredients = await _client
          .from('resep_bahan')
          .select('jumlah, bahan(nama_bahan)')
          .eq('resep_id', resepId);

      return List<Map<String, dynamic>>.from(ingredients);
    } catch (e) {
      throw Exception('Error getIngredients: $e');
    }
  }

  // Ambil langkah-langkah resep
  Future<List<Map<String, dynamic>>> getSteps(int resepId) async {
    try {
      final steps = await _client
          .from('langkah_resep')
          .select('urutan, deskripsi')
          .eq('resep_id', resepId)
          .order('urutan', ascending: true);

      return List<Map<String, dynamic>>.from(steps);
    } catch (e) {
      throw Exception('Error getSteps: $e');
    }
  }

  // Ambil peralatan
  Future<List<String>> getEquipments(int resepId) async {
    try {
      final peralatan = await _client
          .from('resep_peralatan')
          .select('peralatan(nama_peralatan)')
          .eq('resep_id', resepId);

      return (peralatan as List)
          .map((e) => e['peralatan']?['nama_peralatan']?.toString() ?? '')
          .where((nama) => nama.isNotEmpty)
          .toList();
    } catch (e) {
      throw Exception('Error getEquipments: $e');
    }
  }

  //ambil semua kategori
  Future<List<Map<String, dynamic>>> getAllCategories() async {
    try {
      final data = await _client
          .from('kategori')
          .select()
          .order('kategori_id', ascending: true);
      return data;
    } catch (e) {
      throw Exception('Gagal mengambil kategori: $e');
    }
  }
}
