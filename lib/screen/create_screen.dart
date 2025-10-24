import 'package:cookly_app/screen/main_screen.dart';
import 'package:cookly_app/services/resep_services.dart';
import 'package:cookly_app/widgets/sections/create/bahan_section.dart';
import 'package:cookly_app/widgets/sections/create/langkah_section.dart';
import 'package:cookly_app/widgets/sections/create/peralatan_section.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cookly_app/theme/app_color.dart';
import 'package:cookly_app/widgets/components/custom_button.dart';
import 'package:cookly_app/widgets/components/dropdown_category.dart';
import 'package:cookly_app/widgets/components/custom_text_field.dart';
import 'package:cookly_app/data/repository/recipes_repository.dart';
import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:cookly_app/widgets/components/image_picker.dart';

class TambahResepScreen extends StatefulWidget {
  const TambahResepScreen({super.key});

  @override
  State<TambahResepScreen> createState() => _TambahResepScreenState();
}

class _TambahResepScreenState extends State<TambahResepScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repo = RecipesRepository();
  final String? _userID = Supabase.instance.client.auth.currentUser?.id;

  String? _gambarUrl; // URL gambar hasil upload

  // Controllers
  final _judulController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _durasiController = TextEditingController();

  // Data
  int? _kategoriId;
  List<Map<String, String>> _bahanList = [];
  List<String> _langkahList = [];
  List<String> _peralatanList = [];
  List<Map<String, dynamic>> _kategoriList = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final data = await _repo.getAllCategories();
      setState(() => _kategoriList = data);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat kategori: $e")));
    }
  }

  Future<void> _simpanResep() async {
    if (!_formKey.currentState!.validate() ||
        _kategoriId == null ||
        _gambarUrl == null ||
        _gambarUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data wajib.")),
      );
      return;
    }

    if (_userID == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User tidak valid.")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await RecipeService().saveRecipe(
        gambarUrl: _gambarUrl!, // langsung URL
        judul: _judulController.text.trim(),
        deskripsi: _deskripsiController.text.trim(),
        durasi: int.tryParse(_durasiController.text.trim()) ?? 0,
        kategoriId: _kategoriId!,
        userId: _userID!,
        bahanList: _bahanList,
        langkahList: _langkahList,
        peralatanList: _peralatanList,
      );

      if (!mounted) return;
      await _showSuccessDialog();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const CustomText(
          text: "Tambah Resep",
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20,100),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  label: "Judul Resep",
                  controller: _judulController,
                  hintText: "Masukkan judul resep",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: "Deskripsi",
                  controller: _deskripsiController,
                  hintText: "Tuliskan deskripsi singkat resep",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: "Durasi (menit)",
                  controller: _durasiController,
                  hintText: "Contoh: 30",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownCategory(
                  selectedId: _kategoriId,
                  kategoriList: _kategoriList,
                  onChanged: (val) => setState(() => _kategoriId = val),
                ),
                const SizedBox(height: 16),
                ImagePickerField(
                  onImageUploaded: (url) =>
                      setState(() => _gambarUrl = url), // URL langsung
                ),
                const SizedBox(height: 20),
                BahanSection(
                  bahanList: _bahanList,
                  onChanged: (newList) => setState(() => _bahanList = newList),
                ),
                const SizedBox(height: 20),
                LangkahSection(
                  langkahList: _langkahList,
                  onChanged: (newList) =>
                      setState(() => _langkahList = newList),
                ),
                const SizedBox(height: 20),
                PeralatanSection(
                  peralatanList: _peralatanList,
                  onChanged: (newList) =>
                      setState(() => _peralatanList = newList),
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: "Simpan Resep",
                  onPressed: _isLoading ? null : _simpanResep,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 70,
              ),
              const SizedBox(height: 20),
              const Text(
                "Resep Berhasil Disimpan!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              const Text(
                "Resepmu telah tersimpan dan bisa dilihat di halaman utama.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
