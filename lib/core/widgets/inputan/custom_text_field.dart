import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';

class CustomTextField extends StatelessWidget {
  final IconData? icon;
  final String hint;
  final bool isPassword;
  final bool obscurePassword;
  final BorderRadius? borderRadius;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    this.icon,
    required this.hint,
    this.isPassword = false,
    this.obscurePassword = false,
    this.borderRadius,
    this.keyboardType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBorderRadius =
        borderRadius ??
        const BorderRadius.horizontal(right: Radius.circular(50));
    final bool shouldObscure = isPassword ? obscurePassword : false;

    return SizedBox(
      height: 54,
      child: TextField(
        controller: controller,
        obscureText: shouldObscure,
        keyboardType:
            keyboardType ??
            (isPassword ? TextInputType.visiblePassword : TextInputType.text),
        style: AppTypography.regular14.copyWith(color: AppColors.textDark),
        decoration: InputDecoration(
          prefixIcon: icon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 18, right: 12),
                  child: Icon(icon, color: Colors.grey.shade400, size: 20),
                )
              : null,
          hintText: hint,
          hintStyle: AppTypography.regular12.copyWith(
            color: AppColors.textGrey,
            fontSize: 13,
          ),
          filled: true,
          fillColor: AppColors.primary,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: defaultBorderRadius,
            borderSide: BorderSide(color: AppColors.secondary, width: 1.2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: defaultBorderRadius,
            borderSide: BorderSide(color: AppColors.secondary, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: defaultBorderRadius,
            borderSide: BorderSide(color: AppColors.secondary, width: 1.8),
          ),
          suffixIcon: null,
        ),
      ),
    );
  }
}
