import 'package:supabase_flutter/supabase_flutter.dart';

class AddRecipesRepository {
  final _client = Supabase.instance.client;
  static const String _storageBucket = 'recipes';

  Future<void> addRecipe({
    required String judul,
    required String deskripsi,
    required int durasi,
    required int kategoriId,
    required String userId,
    required String imageUrl,
    required List<Map<String, String>> bahanList,
    required List<String> langkahList,
    required List<String> peralatanList,
  }) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;

      //  Insert resep utama
      final resepRes = await _client
          .from('resep')
          .insert({
            'judul': judul,
            'deskripsi': deskripsi,
            'durasi': durasi,
            'user_id': userId,
            'gambar_url': imageUrl,
            'kategori_id': kategoriId,
            'is_public': true,
            'tanggal_upload': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      final resepId = resepRes['resep_id'];

      // 2Insert bahan-bahan
      for (final item in bahanList) {
        if (item['nama'] == null || item['nama']!.isEmpty) continue;

        final bahanRes = await _client
            .from('bahan')
            .select('bahan_id')
            .eq('nama_bahan', item['nama']!.trim())
            .maybeSingle();

        int bahanId;
        if (bahanRes == null) {
          final newBahan = await _client
              .from('bahan')
              .insert({'nama_bahan': item['nama']!.trim()})
              .select()
              .single();
          bahanId = newBahan['bahan_id'];
        } else {
          bahanId = bahanRes['bahan_id'];
        }

        await _client.from('resep_bahan').insert({
          'resep_id': resepId,
          'bahan_id': bahanId,
          'jumlah': item['jumlah'],
        });
      }

      //  Insert langkah-langkah
      for (int i = 0; i < langkahList.length; i++) {
        final langkah = langkahList[i].trim();
        if (langkah.isEmpty) continue;
        await _client.from('langkah_resep').insert({
          'resep_id': resepId,
          'urutan': i + 1,
          'deskripsi': langkah,
        });
      }

      // Insert peralatan
      for (final namaPeralatan in peralatanList) {
        final peralatan = namaPeralatan.trim();
        if (peralatan.isEmpty) continue;

        final peralatanRes = await _client
            .from('peralatan')
            .select('peralatan_id')
            .eq('nama_peralatan', peralatan)
            .maybeSingle();

        int peralatanId;
        if (peralatanRes == null) {
          final newPeralatan = await _client
              .from('peralatan')
              .insert({'nama_peralatan': peralatan})
              .select()
              .single();
          peralatanId = newPeralatan['peralatan_id'];
        } else {
          peralatanId = peralatanRes['peralatan_id'];
        }

        await _client.from('resep_peralatan').insert({
          'resep_id': resepId,
          'peralatan_id': peralatanId,
        });
      }
    } catch (e, st) {
      throw Exception('Gagal menambah resep: $e\n$st');
    }
  }
}
