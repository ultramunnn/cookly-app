class UserModel {
  final String id;
  final String name;
  final String username;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
  });


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['nama'],
      username: json['username'],
    );
  }
}
