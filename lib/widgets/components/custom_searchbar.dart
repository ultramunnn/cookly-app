import 'package:flutter/material.dart';

class CustomSearchbar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onSearch;

  const CustomSearchbar({
    super.key,
    this.hintText = 'Cari resep...',
    this.onSearch,
  });

  @override
  State<CustomSearchbar> createState() => _CustomSearchbarState();
}

class _CustomSearchbarState extends State<CustomSearchbar> {
  final TextEditingController _controller = TextEditingController();

  void _handleSearch() {
    if (widget.onSearch != null) {
      widget.onSearch!(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(50),
              ),
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _handleSearch(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hintText,
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
          ),
          const SizedBox(width: 10),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFDD4A14),
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              onPressed: _handleSearch,
              icon: const Icon(Icons.search, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
