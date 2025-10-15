import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:flutter/material.dart';

class CategoryFilterSection extends StatefulWidget {
  final ValueChanged<String>? onSelected;

  const CategoryFilterSection({super.key, this.onSelected});

  @override
  State<CategoryFilterSection> createState() => _CategoryFilterSectionState();
}

class _CategoryFilterSectionState extends State<CategoryFilterSection> {
  // Dummy data (nanti bisa diganti Supabase)
  List<Map<String, dynamic>> categories = [
    {'name': 'Daging', 'icon': Icons.set_meal.codePoint},
    {'name': 'Sayur', 'icon': Icons.grass.codePoint},
    {'name': 'Kue', 'icon': Icons.cake.codePoint},
    {'name': 'Minuman', 'icon': Icons.local_drink.codePoint},
  ];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    await Future.delayed(const Duration(seconds: 1)); // simulasi loading
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFFDD4A14);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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

          // List kategori horizontal
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: categories.map((category) {
                    return GestureDetector(
                      onTap: () => widget.onSelected?.call(category['name']),
                      child: Container(
                        margin: const EdgeInsets.only(right: 32),
                        decoration: BoxDecoration(
                          color: primaryColor, // bulatan warna primary
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        width: 48,
                        height: 48,
                        child: Icon(
                          IconData(
                            category['icon'],
                            fontFamily: 'MaterialIcons',
                          ),
                          color: Colors.white, // icon putih
                          size: 26,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
