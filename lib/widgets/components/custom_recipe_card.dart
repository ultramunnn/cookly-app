import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:flutter/material.dart';

class CustomRecipeCard extends StatefulWidget {
  final String? title;
  final String? titleCenter;
  final String imageUrl;
  final String? duration;
  final double height;
  final double width;
  final VoidCallback? onFavoriteTap;
  final bool showDuration;

  const CustomRecipeCard({
    super.key,
    this.title,
    this.titleCenter,
    required this.height,
    required this.width,
    required this.imageUrl,
    this.duration,
    this.onFavoriteTap,
    this.showDuration = true,
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
    return SizedBox(
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar + durasi
          Stack(
            children: [
              // Container untuk shadow + gambar
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.imageUrl,
                    width: double.infinity,
                    height: widget.height,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: widget.height,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Overlay judul di tengah
              if (widget.titleCenter != null && widget.titleCenter!.isNotEmpty)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: CustomText(
                          text: widget.titleCenter ?? '',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),

              // Label waktu di pojok kiri bawah
              if (widget.showDuration && widget.duration != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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

          if (widget.title != null && widget.title!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      widget.title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF191919),
                        fontSize: 13,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: widget.onFavoriteTap ?? toggleFavorite,
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: const Color(0xFFDD4A14),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
