import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:cookly_app/theme/app_color.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImagePickerField extends StatefulWidget {
  final ValueChanged<String> onImageUploaded; // <-- return URL langsung
  final String? initialImage;

  const ImagePickerField({
    super.key,
    required this.onImageUploaded,
    this.initialImage,
  });

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  XFile? _pickedImage;
  bool _isUploading = false;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialImage != null) {
      _imageUrl = widget.initialImage;
    }
  }

  Future<String> uploadImage(XFile image) async {
    final supabase = Supabase.instance.client;
    final filePath =
        'resep/${DateTime.now().millisecondsSinceEpoch}_${image.name}';

    setState(() => _isUploading = true);

    try {
      await supabase.storage.from('recipes').upload(filePath, File(image.path));
      final imageUrl = supabase.storage.from('recipes').getPublicUrl(filePath);
      return imageUrl;
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    Permission permission;

    if (source == ImageSource.camera) {
      permission = Permission.camera;
    } else {
      int androidSdkInt = 0;
      if (Platform.isAndroid) {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        androidSdkInt = androidInfo.version.sdkInt;
      }

      permission = (Platform.isAndroid && androidSdkInt >= 33)
          ? Permission.photos
          : Permission.storage;
    }

    var status = await permission.status;
    if (!status.isGranted) {
      status = await permission.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Izin akses ditolak.")));
        return;
      }
    }

    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() => _pickedImage = picked);

      // Upload otomatis dan kirim URL ke parent
      try {
        final url = await uploadImage(picked);
        setState(() => _imageUrl = url);
        widget.onImageUploaded(url);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Gagal upload gambar: $e")));
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Dari Galeri"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Dari Kamera"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: _isUploading ? null : _showImageSourceDialog,
          icon: const Icon(Icons.image, color: Colors.white),
          label: _isUploading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  "Pilih Gambar",
                  style: TextStyle(color: Colors.white),
                ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: 12),
        if (_pickedImage != null || _imageUrl != null)
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _isUploading
                  ? Container(
                      height: 100,
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Image.file(
                      File(_pickedImage?.path ?? ''),
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // fallback kalau File gagal
                        return _imageUrl != null
                            ? Image.network(_imageUrl!,
                                height: 100, fit: BoxFit.cover)
                            : const SizedBox();
                      },
                    ),
            ),
          ),
      ],
    );
  }
}
