import 'package:flutter/material.dart';
import 'package:cookly_app/theme/app_color.dart';
import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:cookly_app/widgets/components/custom_navbar.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  // Mock data untuk favorit
  final List<Map<String, dynamic>> favoriteRecipes = [
    {
      'id': 1,
      'name': 'Nasi Goreng Spesial',
      'category': 'Makanan',
      'duration': '30 min',
      'image': 'assets/images/nasi_goreng.jpg',
    },
    {
      'id': 2,
      'name': 'Mie Ayam Kuah',
      'category': 'Makanan',
      'duration': '25 min',
      'image': 'assets/images/mie_ayam.jpg',
    },
    {
      'id': 3,
      'name': 'Jus Jeruk Segar',
      'category': 'Minuman',
      'duration': '5 min',
      'image': 'assets/images/jus_jeruk.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Navbar
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CustomNavbar(),
            ),
            const SizedBox(height: 24),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: 'Resep Favorit',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    text:
                        'Anda memiliki ${favoriteRecipes.length} resep favorit',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600]!,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // List Favorit
            Expanded(
              child: favoriteRecipes.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: favoriteRecipes.length,
                      itemBuilder: (context, index) {
                        return _buildFavoriteCard(
                          favoriteRecipes[index],
                          index,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> recipe, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // TODO: Navigate ke detail resep
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.restaurant,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Konten
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: recipe['name'],
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 6),

                      // Category Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: CustomText(
                          text: recipe['category'],
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Duration
                      Row(
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          CustomText(
                            text: recipe['duration'],
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Favorite Button
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        // TODO: Remove from favorite
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${recipe['name']} dihapus dari favorit',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const CustomText(
            text: 'Belum ada resep favorit',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          const SizedBox(height: 8),
          CustomText(
            text: 'Tambahkan resep favorit Anda untuk melihatnya di sini',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate ke home
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const CustomText(
              text: 'Jelajahi Resep',
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
