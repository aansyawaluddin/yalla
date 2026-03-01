import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';

class LocationSwapInput extends StatelessWidget {
  const LocationSwapInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Column(
          children: [
            _buildLocationItem(
              leadingWidget: Image.asset(
                'assets/icons/location.png',
                width: 25,
                height: 30,
              ),
              title: "Makassar",
              subtitle: " - UPGC",
              isTop: true,
            ),
            const SizedBox(height: 12),
            _buildLocationItem(
              leadingWidget: Image.asset(
                'assets/icons/planee.png',
                width: 35,
                height: 31,
              ),
              title: "",
              subtitle: "",
              isTop: false,
            ),
          ],
        ),
        // Tombol Swap Melayang
        Positioned(
          right: 24,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF005C99), Color(0xFF0099FF)],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.lightBlue.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.swap_vert,
                color: AppColors.primary,
                size: 24,
              ),
              onPressed: () {
                // TODO: Tambahkan fungsi tukar lokasi di sini
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationItem({
    required Widget leadingWidget,
    required String title,
    required String subtitle,
    required bool isTop,
  }) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        border: Border.all(
          color: isTop ? AppColors.secondary : AppColors.line,
          width: isTop ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          leadingWidget,
          const SizedBox(width: 12),
          if (title.isNotEmpty)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: title,
                    style: AppTypography.bold14.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                  TextSpan(
                    text: subtitle,
                    style: AppTypography.bold14.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
