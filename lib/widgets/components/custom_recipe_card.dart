import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:flutter/material.dart';

class CustomRecipeCard extends StatefulWidget {
  final String? title;
  final String? titleCenter;
  final String imageAsset; // ubah dari imageUrl ke imageAsset
  final String? duration;
  final int height;
  final int width;
  final VoidCallback? onFavoriteTap;

  const CustomRecipeCard({
    super.key,
    this.title,
    this.titleCenter,
    required this.height,
    required this.width,
    required this.imageAsset,
    this.duration,
    this.onFavoriteTap,
  });

  @override
  State<CustomRecipeCard> createState() => _CustomRecipeCardState();
}

class _CustomRecipeCardState extends State<CustomRecipeCard> {
  bool isFavorite = false;
  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width.toDouble(),
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // ⬅️ ini penting biar gak makan ruang ekstra
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar + durasi
          Stack(
            children: [
              // Gambar utama (pakai asset)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.imageAsset,
                  width: double.infinity,
                  height: widget.height.toDouble(),
                  fit: BoxFit.cover,
                ),
              ),
              if (widget.titleCenter != null && widget.titleCenter!.isNotEmpty)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: CustomText(
                        text: widget.titleCenter ?? '',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              // Label waktu di pojok kiri bawah
              if (widget.duration != null && widget.duration!.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.timer,
                          size: 12,
                          color: Color(0xFFDD4A14),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.duration ?? '',
                          style: const TextStyle(
                            color: Color(0xFFDD4A14),
                            fontSize: 10,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          // Judul + ikon favorit
          if (widget.title != null && widget.title!.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 16,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: widget.onFavoriteTap ?? toggleFavorite,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Color(0xFFDD4A14),
                    size: 20,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
