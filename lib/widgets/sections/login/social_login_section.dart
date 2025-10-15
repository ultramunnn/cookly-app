import 'package:flutter/material.dart';

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 44,
          height: 44,
          child: Image.asset('assets/images/google.png'),
        ), // Google
        const SizedBox(width: 12),
        SizedBox(
          width: 44,
          height: 44,
          child: Image.asset('assets/images/fb.png'),
        ), // Facebook
        const SizedBox(width: 12),
        SizedBox(
          width: 44,
          height: 44,
          child: Image.asset('assets/images/ig.png'),
        ), // Apple
      ],
    );
  }
}
