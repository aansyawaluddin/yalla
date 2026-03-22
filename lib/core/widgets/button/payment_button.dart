import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_typography.dart';

class PaymentButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const PaymentButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF0D4700), Color(0xFF20AD00)],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: icon != null
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: AppTypography.bold14.copyWith(
                  color: Colors.white,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
              ),
              if (icon != null) Icon(icon, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
