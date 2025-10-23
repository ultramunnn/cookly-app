import 'package:cookly_app/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  final _client = Supabase.instance.client;

  // Get user profile by user ID (optional)
  Future<UserModel> getProfileById(String userId) async {
    try {
      final response = await _client
          .from('profiles') // Ganti dengan nama table users Anda
          .select('id, nama, username')
          .eq('id', userId)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Error getting user profile by ID: $e');
    }
  }
}
