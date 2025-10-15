import 'package:flutter/material.dart';

class LineGap extends StatelessWidget {
  const LineGap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: const Color(0xFFF1F1F1),
          ),
        ),
      ),
    );
  }
}
