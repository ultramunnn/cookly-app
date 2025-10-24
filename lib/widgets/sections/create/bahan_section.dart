import 'package:flutter/material.dart';
import 'package:cookly_app/theme/app_color.dart';

class BahanSection extends StatelessWidget {
  final List<Map<String, String>> bahanList;
  final ValueChanged<List<Map<String, String>>> onChanged;

  const BahanSection({
    super.key,
    required this.bahanList,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Bahan-bahan",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 8),
        Column(
          children: List.generate(
            bahanList.length,
            (i) => _buildBahanItem(context, i),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            final newList = List<Map<String, String>>.from(bahanList);
            newList.add({'nama': '', 'jumlah': ''});
            onChanged(newList);
          },
          icon: const Icon(Icons.add, color: AppColors.primary),
          label: const Text(
            "Tambah Bahan",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBahanItem(BuildContext context, int index) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: bahanList[index]['nama'],
            decoration: const InputDecoration(hintText: "Nama bahan"),
            onChanged: (val) {
              final newList = List<Map<String, String>>.from(bahanList);
              newList[index]['nama'] = val;
              onChanged(newList);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            initialValue: bahanList[index]['jumlah'],
            decoration: const InputDecoration(hintText: "Jumlah"),
            onChanged: (val) {
              final newList = List<Map<String, String>>.from(bahanList);
              newList[index]['jumlah'] = val;
              onChanged(newList);
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            final newList = List<Map<String, String>>.from(bahanList);
            newList.removeAt(index);
            onChanged(newList);
          },
        ),
      ],
    );
  }
}
