import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';

class PromoCard extends StatelessWidget {
  final String title;
  final String price;
  final String tag;
  final Color tagColor;
  final String imagePath;

  const PromoCard({
    super.key,
    required this.title,
    required this.price,
    required this.tag,
    required this.tagColor,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade400,
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [Colors.black.withOpacity(0.8), Colors.transparent],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: tagColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag,
                    style: AppTypography.bold10.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: AppTypography.bold14.copyWith(
                    color: AppColors.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: AppTypography.regular10.copyWith(
                      color: AppColors.primary,
                    ),
                    children: [
                      const TextSpan(text: "Mulai dari "),
                      TextSpan(
                        text: price,
                        style: AppTypography.bold12.copyWith(
                          color: Colors.amber.shade400,
                        ),
                      ),
                    ],
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