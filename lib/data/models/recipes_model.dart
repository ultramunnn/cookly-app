class Recipe {
  final int id;
  final String name;
  final String deskripsi;
  final int durasi;
  final String gambarUrl;
  final String kategori;

  Recipe({
    required this.id,
    required this.name,
    required this.deskripsi,
    required this.durasi,
    required this.gambarUrl,
    required this.kategori,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['resep_id'],
      name: json['judul'],
      deskripsi: json['deskripsi'],
      durasi: json['durasi'],
      gambarUrl: json['gambar_url'],
      kategori: json['kategori']['nama_kategori'],
    );
  }
}
