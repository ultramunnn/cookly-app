import 'package:flutter/material.dart';

class CustomSearchbar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  const CustomSearchbar({
    super.key,
    this.hintText = 'Cari resep...',
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8), // jarak kiri & kanan
      child: Row(
        children: [
          // Field abu-abu
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onTap: onTap,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: const TextStyle(
                          color: Color(0xFF707070),
                          fontSize: 14,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Lexend',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Tombol oranye di luar field
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFDD4A14),
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              onPressed: () {
                debugPrint('Search button clicked');
              },
              icon: const Icon(Icons.search, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
