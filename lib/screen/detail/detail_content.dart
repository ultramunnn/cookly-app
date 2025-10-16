import 'package:cookly_app/widgets/components/custom_navbar.dart';
import 'package:cookly_app/widgets/components/custom_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:cookly_app/theme/app_color.dart';
import 'package:cookly_app/widgets/components/custom_text.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String image;
  final String title;
  final String? duration;

  const RecipeDetailScreen({
    super.key,
    required this.image,
    required this.title,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomNavbar(),
                const SizedBox(height: 16),
                CustomSearchbar(
                  hintText: 'Cari Resep',
                  onTap: () {},
                  onChanged: (value) {},
                ),
                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          image,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: title,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          Row(
                            children: const [
                              Icon(Icons.bookmark_border, color: Colors.grey),
                              SizedBox(width: 12),
                              Icon(Icons.share, color: Colors.grey),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.timer,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          CustomText(
                            text: duration ?? '',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const Divider(color: Color(0xFFF1F1F1)),

                      // Bagian isi resep
                      const SectionTitle("Bahan-bahan"),
                      const SizedBox(height: 12),
                      const SectionText(
                        "1 lata de leite condensado\n1 lata de leite (medida da lata de leite condensado)\n3 ovos inteiros\n1 xícara (chá) de açúcar\n1/2 xícara de água",
                      ),
                      const SizedBox(height: 28),
                      const Divider(color: Color(0xFFF1F1F1)),

                      const SectionTitle("Peralatan"),
                      const SizedBox(height: 12),
                      const SectionText(
                        "Baskom\nPisau\nPenggorengan\nSpatula\nPiring saji",
                      ),
                      const SizedBox(height: 28),
                      const Divider(color: Color(0xFFF1F1F1)),

                      const SectionTitle("Langkah-langkah"),
                      const SizedBox(height: 12),
                      const SectionText(
                        "1. Kocok telur menggunakan whisk hingga lembut.\n2. Tambahkan susu kental manis dan susu cair, aduk rata.\n3. Panaskan gula hingga karamel, lalu tuang air sedikit demi sedikit.\n4. Masukkan adonan ke loyang dan kukus selama 40 menit.",
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: text,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.primary,
      textAlign: TextAlign.left,
    );
  }
}

class SectionText extends StatelessWidget {
  final String text;
  const SectionText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: text,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF444444),
      textAlign: TextAlign.left, // biar teks mulai dari kiri
    );
  }
}
