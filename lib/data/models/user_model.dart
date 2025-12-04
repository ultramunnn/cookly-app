class UserModel {
  final String id;
  final String name;
  final String username;
  final String? gambarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    this.gambarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['nama'] ?? '',
      username: json['username'] ?? '',
      gambarUrl: json['gambar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': name,
      'username': username,
      'gambar_url': gambarUrl,
    };
  }
}
