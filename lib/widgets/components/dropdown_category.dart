import 'package:flutter/material.dart';
import 'package:cookly_app/theme/app_color.dart';

class DropdownCategory extends StatelessWidget {
  final int? selectedId;
  final List<Map<String, dynamic>> kategoriList;
  final ValueChanged<int?> onChanged;

  const DropdownCategory({
    super.key,
    required this.selectedId,
    required this.kategoriList,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Kategori",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<int>(
          value: selectedId,
          decoration: _dropdownDecoration(),
          items: kategoriList
              .map(
                (e) => DropdownMenuItem<int>(
                  value: e['kategori_id'],
                  child: Text(e['nama_kategori']),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}
