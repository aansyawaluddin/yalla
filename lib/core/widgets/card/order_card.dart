import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';

class OrderCard extends StatelessWidget {
  final IconData icon;
  final String categoryTitle;
  final String statusText;
  final Color statusBgColor;
  final Color statusTextColor;
  final Widget body;
  final String totalPrice;

  const OrderCard({
    super.key,
    required this.icon,
    required this.categoryTitle,
    required this.statusText,
    required this.statusBgColor,
    required this.statusTextColor,
    required this.body,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Header Kartu (Kategori & Status)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: AppColors.secondary, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      categoryTitle,
                      style: AppTypography.bold12.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: AppTypography.bold10.copyWith(
                      color: statusTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Garis pemisah tipis
          const Divider(height: 1, thickness: 1, color: Color(0xFFF5F6F8)),

          // 2. Body Kartu (Konten dinamis: Hotel/Pesawat/Visa)
          Padding(padding: const EdgeInsets.all(16.0), child: body),

          // Garis pemisah tipis
          const Divider(height: 1, thickness: 1, color: Color(0xFFF5F6F8)),

          // 3. Footer Kartu (Total Harga)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Harga",
                  style: AppTypography.regular12.copyWith(
                    color: AppColors.textGrey,
                  ),
                ),
                Text(
                  totalPrice,
                  style: AppTypography.bold14.copyWith(
                    color: AppColors.lightBlue,
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
