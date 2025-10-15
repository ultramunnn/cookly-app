import 'package:flutter/material.dart';
import 'package:cookly_app/theme/app_color.dart';

class DividerSection extends StatelessWidget {
  const DividerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'atau',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
      ],
    );
  }
}
