import 'package:flutter/material.dart';
import 'package:cookly_app/theme/app_color.dart';

class PeralatanSection extends StatelessWidget {
  final List<String> peralatanList;
  final ValueChanged<List<String>> onChanged;

  const PeralatanSection({
    super.key,
    required this.peralatanList,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Peralatan Masak",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 8),
        Column(
          children: List.generate(
            peralatanList.length,
            (i) => _buildPeralatanItem(context, i),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            final newList = List<String>.from(peralatanList);
            newList.add("");
            onChanged(newList);
          },
          icon: const Icon(Icons.add, color: AppColors.primary),
          label: const Text(
            "Tambah Peralatan",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeralatanItem(BuildContext context, int index) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: peralatanList[index],
            decoration: InputDecoration(hintText: "Peralatan ${index + 1}"),
            onChanged: (val) {
              final newList = List<String>.from(peralatanList);
              newList[index] = val;
              onChanged(newList);
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            final newList = List<String>.from(peralatanList);
            newList.removeAt(index);
            onChanged(newList);
          },
        ),
      ],
    );
  }
}
