import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';

class CustomTextField extends StatefulWidget {
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
    this.obscurePassword = true,
    this.borderRadius,
    this.keyboardType,
    this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword ? widget.obscurePassword : false;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ??
        const BorderRadius.horizontal(right: Radius.circular(50));

    return SizedBox(
      height: 54,
      child: TextField(
        controller: widget.controller,
        obscureText: _obscure,
        keyboardType: widget.keyboardType ??
            (widget.isPassword ? TextInputType.visiblePassword : TextInputType.text),
        style: AppTypography.regular14.copyWith(color: AppColors.textDark),
        decoration: InputDecoration(
          prefixIcon: widget.icon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 18, right: 12),
                  child: Icon(widget.icon, color: Colors.grey.shade400, size: 20),
                )
              : null,
          hintText: widget.hint,
          hintStyle: AppTypography.regular12.copyWith(color: AppColors.textGrey, fontSize: 13),
          filled: true,
          fillColor: AppColors.primary,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: AppColors.secondary, width: 1.2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: AppColors.secondary, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: AppColors.secondary, width: 1.8),
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  splashRadius: 20,
                  icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey.shade600),
                  onPressed: () => setState(() => _obscure = !_obscure),
                )
              : null,
        ),
      ),
    );
  }
}