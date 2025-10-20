import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryFilterSection extends StatefulWidget {
  final ValueChanged<int>? onSelected; // Ubah ke int (kategori_id)

  const CategoryFilterSection({super.key, this.onSelected});

  @override
  State<CategoryFilterSection> createState() => _CategoryFilterSectionState();
}

class _CategoryFilterSectionState extends State<CategoryFilterSection> {
  late final Future<List<Map<String, dynamic>>> _categoriesFuture;
  int? selectedCategoryId;

  // Mapping kategori ke icon sesuai database
  final Map<String, IconData> categoryIcons = {
    'Makanan': Icons.restaurant,
    'Minuman': Icons.local_drink,
  };

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _getCategories();
  }

  // Fungsi untuk mengambil kategori dari Supabase
  Future<List<Map<String, dynamic>>> _getCategories() async {
    try {
      final data = await Supabase.instance.client
          .from('kategori')
          .select()
          .order('kategori_id', ascending: true);
      return data;
    } catch (e) {
      throw Exception('Error loading categories: $e');
    }
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
                // Loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error state
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

                // No data
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

                // Build kategori buttons
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: categories.map((category) {
                      final categoryId = category['kategori_id'] as int;
                      final categoryName = category['nama_kategori'] as String;
                      final isSelected = selectedCategoryId == categoryId;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategoryId = isSelected ? null : categoryId;
                          });
                          widget.onSelected?.call(categoryId);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 32),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.grey[100] : primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          width: 48,
                          height: 48,
                          child: Icon(
                            categoryIcons[categoryName] ??
                                Icons
                                    .category, // Default icon jika tidak ada mapping
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
