import 'package:flutter/material.dart';
import 'package:cookly_app/theme/app_color.dart';

class LangkahSection extends StatelessWidget {
  final List<String> langkahList;
  final ValueChanged<List<String>> onChanged;

  const LangkahSection({
    super.key,
    required this.langkahList,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Langkah-langkah",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 8),
        Column(
          children: List.generate(
            langkahList.length,
            (i) => _buildLangkahItem(context, i),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            final newList = List<String>.from(langkahList);
            newList.add("");
            onChanged(newList);
          },
          icon: const Icon(Icons.add, color: AppColors.primary),
          label: const Text(
            "Tambah Langkah",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLangkahItem(BuildContext context, int index) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: langkahList[index],
            decoration: InputDecoration(hintText: "Langkah ${index + 1}"),
            onChanged: (val) {
              final newList = List<String>.from(langkahList);
              newList[index] = val;
              onChanged(newList);
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            final newList = List<String>.from(langkahList);
            newList.removeAt(index);
            onChanged(newList);
          },
        ),
      ],
    );
  }
}
