import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';

class StandardIconInput extends StatelessWidget {
  final IconData icon;
  final String hint;
  final VoidCallback? onTap;

  const StandardIconInput({
    super.key,
    required this.icon,
    required this.hint,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primary,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textGrey, size: 22),
            const SizedBox(width: 12),
            Text(
              hint,
              style: AppTypography.regular14.copyWith(
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
