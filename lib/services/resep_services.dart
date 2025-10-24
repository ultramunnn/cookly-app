import 'package:cookly_app/data/repository/add_recipes_repository.dart';

class RecipeService {
  final _repo = AddRecipesRepository();

  /// Simpan resep dengan [gambarUrl] sudah dalam bentuk public URL
  Future<void> saveRecipe({
    required String gambarUrl, // langsung URL
    required String judul,
    required String deskripsi,
    required int durasi,
    required int kategoriId,
    required String userId,
    required List<Map<String, String>> bahanList,
    required List<String> langkahList,
    required List<String> peralatanList,
  }) async {
    try {
      // Insert resep lengkap ke DB
      await _repo.addRecipe(
        judul: judul,
        deskripsi: deskripsi,
        durasi: durasi,
        kategoriId: kategoriId,
        userId: userId,
        imageUrl: gambarUrl,
        bahanList: bahanList,
        langkahList: langkahList,
        peralatanList: peralatanList,
      );
    } catch (e) {
      throw Exception('Gagal menyimpan resep: $e');
    }
  }
}
