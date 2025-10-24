import 'package:cookly_app/data/repository/recipes_repository.dart';
import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:flutter/material.dart';

class CategoryFilterSection extends StatefulWidget {
  final ValueChanged<String>? onSelected;

  const CategoryFilterSection({super.key, this.onSelected});

  @override
  State<CategoryFilterSection> createState() => _CategoryFilterSectionState();
}

class _CategoryFilterSectionState extends State<CategoryFilterSection> {
  late final Future<List<Map<String, dynamic>>> _categoriesFuture;
  String? selectedCategoryName;

  
  final _categoryRepository = RecipesRepository();

  // Mapping kategori ke icon sesuai database
  final Map<String, IconData> categoryIcons = {
    'Makanan': Icons.restaurant,
    'Minuman': Icons.local_drink,
  };

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _categoryRepository.getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFFDD4A14);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: "Filter Berdasarkan Kategori",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 18),

          // FutureBuilder untuk fetch kategori
          SizedBox(
            width: double.infinity,
            height: 60,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: CustomText(
                      text: 'Error: ${snapshot.error}',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  );
                }

                final categories = snapshot.data!;
                if (categories.isEmpty) {
                  return const Center(
                    child: CustomText(
                      text: 'Tidak ada kategori',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF999999),
                    ),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: categories.map((category) {
                      final categoryName = category['nama_kategori'] as String;
                      final isSelected = selectedCategoryName == categoryName;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategoryName =
                                isSelected ? null : categoryName;
                          });
                          widget.onSelected?.call(categoryName);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 32),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.grey[100] : primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.grey.withValues(alpha: 0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          width: 48,
                          height: 48,
                          child: Icon(
                            categoryIcons[categoryName] ?? Icons.category,
                            color: isSelected ? primaryColor : Colors.white,
                            size: 24,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
