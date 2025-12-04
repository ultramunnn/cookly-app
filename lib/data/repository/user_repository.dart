import 'package:cookly_app/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class UserRepository {
  final _client = Supabase.instance.client;
  static const String _storageBucket = 'profile-images';

  // Get user profile by user ID
  Future<UserModel> getProfileById(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select('id, nama, username, gambar_url')
          .eq('id', userId)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Error getting user profile: $e');
    }
  }

  // Upload profile image dari URL online ke Supabase Storage
  Future<String> uploadProfileImageFromUrl({
    required String userId,
    required String imageUrl,
  }) async {
    try {
      // Download image dari URL
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode != 200) {
        throw Exception(
          'Gagal download gambar dari URL: ${response.statusCode}',
        );
      }

      // Simpan ke temporary directory
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/profile_temp_$userId.jpg');
      await tempFile.writeAsBytes(response.bodyBytes);

      // Upload ke Supabase Storage
      final fileName = 'profile_$userId.jpg';
      final path = 'profiles/$fileName';

      // Hapus file lama jika ada
      try {
        await _client.storage.from(_storageBucket).remove([path]);
      } catch (e) {
        // File tidak ada, skip
      }

      // Upload file
      await _client.storage
          .from(_storageBucket)
          .upload(
            path,
            tempFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      // Hapus temp file
      await tempFile.delete();

      // Return public URL dari Supabase Storage
      final publicUrl = _client.storage.from(_storageBucket).getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      throw Exception('Error uploading profile image: $e');
    }
  }

  // Upload profile image dari file path lokal
  Future<String> uploadProfileImage({
    required String userId,
    required String filePath,
  }) async {
    try {
      final file = File(filePath);

      if (!await file.exists()) {
        throw Exception('File tidak ditemukan: $filePath');
      }

      final fileName = 'profile_$userId.jpg';
      final path = 'profiles/$fileName';

      // Hapus file lama jika ada
      try {
        await _client.storage.from(_storageBucket).remove([path]);
      } catch (e) {
        // File tidak ada, skip
      }

      // Upload file baru
      await _client.storage
          .from(_storageBucket)
          .upload(
            path,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      // Return public URL
      final publicUrl = _client.storage.from(_storageBucket).getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      throw Exception('Error uploading profile image: $e');
    }
  }

  // Update user profile dengan validation dan verification
  Future<void> updateProfile({
    required String userId,
    String? nama,
    String? username,
    String? gambarUrl,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (nama != null) updateData['nama'] = nama;
      if (username != null) updateData['username'] = username;
      if (gambarUrl != null) {
        updateData['gambar_url'] = gambarUrl;
      }

      // Update dengan explicit return
      await _client
          .from('profiles')
          .update(updateData)
          .eq('id', userId)
          .then((_) {});

      // Verify data tersimpan dengan query langsung
      final verifyResponse = await _client
          .from('profiles')
          .select('id, nama, username, gambar_url')
          .eq('id', userId)
          .single();

      if (verifyResponse['gambar_url'] != gambarUrl && gambarUrl != null) {
        throw Exception('Data tidak tersimpan ke database');
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  // Delete profile image
  Future<void> deleteProfileImage(String userId) async {
    try {
      final fileName = 'profile_$userId.jpg';
      final path = 'profiles/$fileName';

      // Hapus dari storage
      await _client.storage.from(_storageBucket).remove([path]);

      // Update DB
      await _client
          .from('profiles')
          .update({'gambar_url': null})
          .eq('id', userId);
    } catch (e) {
      throw Exception('Error deleting profile image: $e');
    }
  }

  // Verify dan get valid public URL
  Future<String> getValidPublicUrl(String filePath) async {
    try {
      final fileName = 'profile_$filePath.jpg';
      final path = 'profiles/$fileName';

      final publicUrl = _client.storage.from(_storageBucket).getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      throw Exception('Error getting public URL: $e');
    }
  }

  // List files di storage untuk debugging
  Future<List<String>> listProfileImages() async {
    try {
      final files = await _client.storage
          .from(_storageBucket)
          .list(path: 'profiles');
      return files.map((f) => f.name).toList();
    } catch (e) {
      throw Exception('Error listing files: $e');
    }
  }
}
