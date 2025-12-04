import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cookly_app/data/models/user_model.dart';
import 'package:cookly_app/data/repository/user_repository.dart';
import 'package:cookly_app/theme/app_color.dart';
import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:cookly_app/widgets/components/custom_text_field.dart';
import 'package:cookly_app/widgets/components/custom_button.dart';
import 'package:cookly_app/widgets/components/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repo = UserRepository();
  final _supabase = Supabase.instance.client;

  late TextEditingController _namaController;
  late TextEditingController _usernameController;

  String? _gambarUrl;
  String? _gambarLocalPath; // Path lokal file gambar
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.user.name);
    _usernameController = TextEditingController(text: widget.user.username);
    _gambarUrl = widget.user.gambarUrl;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _simpanProfile() async {
    if (!_formKey.currentState!.validate()) return;

    // Validasi manual
    if (_namaController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Nama tidak boleh kosong');
      return;
    }

    if (_usernameController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Username tidak boleh kosong');
      return;
    }

    if (_usernameController.text.trim().length < 3) {
      setState(() => _errorMessage = 'Username minimal 3 karakter');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Upload/process gambar jika ada perubahan
      if (_gambarLocalPath != null && _gambarLocalPath!.isNotEmpty) {
        // Selalu upload ke storage
        _gambarUrl = await _repo.uploadProfileImageFromUrl(
          userId: widget.user.id,
          imageUrl: _gambarLocalPath!,
        );
      }

      // Update profil ke database
      await _repo.updateProfile(
        userId: widget.user.id,
        nama: _namaController.text.trim(),
        username: _usernameController.text.trim(),
        gambarUrl: _gambarUrl,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui!')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _errorMessage = 'Gagal memperbarui profil: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_errorMessage!)));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _hapusGambar() async {
    try {
      await _repo.deleteProfileImage(widget.user.id);
      setState(() {
        _gambarUrl = null;
        _gambarLocalPath = null;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Foto profil dihapus')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus foto: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const CustomText(
          text: 'Edit Profil',
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto Profil Section
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: _gambarUrl != null && _gambarUrl!.isNotEmpty
                              ? Image.network(
                                  _gambarUrl!,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildPlaceholder();
                                  },
                                )
                              : _buildPlaceholder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ImagePickerField(
                        onImageUploaded: (path) {
                          setState(() {
                            _gambarLocalPath = path;
                            // Tampilkan preview dari URL
                            _gambarUrl = path;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      if (_gambarUrl != null && _gambarUrl!.isNotEmpty)
                        TextButton.icon(
                          onPressed: _hapusGambar,
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const CustomText(
                            text: 'Hapus Foto',
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Form Fields
                CustomTextField(
                  label: 'Nama Lengkap',
                  controller: _namaController,
                  hintText: 'Masukkan nama lengkap',
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Username',
                  controller: _usernameController,
                  hintText: 'Masukkan username',
                ),
                const SizedBox(height: 32),

                // Error Message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red, width: 1),
                    ),
                    child: CustomText(
                      text: _errorMessage!,
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 24),

                // Save Button
                CustomButton(
                  text: 'Simpan Perubahan',
                  onPressed: _isLoading ? null : _simpanProfile,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.primary.withOpacity(0.1),
      child: Icon(Icons.person, size: 60, color: AppColors.primary),
    );
  }
}
