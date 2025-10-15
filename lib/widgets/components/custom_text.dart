import 'package:flutter/material.dart';
import 'package:cookly_app/theme/app_color.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextStyle? style;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.color = AppColors.textPrimary,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: TextStyle(
        fontFamily: 'Lexend',
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
