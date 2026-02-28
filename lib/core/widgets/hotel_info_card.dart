import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';

class HotelInfoCard extends StatelessWidget {
  const HotelInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFFBCE3FF), // Biru muda sudut kiri bawah
            Colors.white, // Putih dominan di tengah
            Colors.white,
            Color(0xFFDFF1FF), // Biru pudar sudut kanan atas
          ],
          stops: [0.0, 0.2, 0.8, 1.0],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Foto Hotel (Sisi Kiri)
          Container(
            width: 100,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage('assets/images/hotel.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Bagian Informasi Teks (Sisi Kanan)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "Hotel Borobudur Jakarta",
                        style: AppTypography.bold14.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // Badge Check-in (Pojok Kanan Atas Teks)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Check In 12:21:01",
                        style: AppTypography.regular10.copyWith(
                          fontSize: 8,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Baris Tanggal
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Okt 12 - 15 Okt",
                      style: AppTypography.regular10.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Baris Detail Tamu & Durasi
                Row(
                  children: [
                    Text(
                      "3 Malam",
                      style: AppTypography.regular10.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 1, height: 10, color: AppColors.line),
                    const SizedBox(width: 8),
                    Text(
                      "2 Tamu",
                      style: AppTypography.regular10.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
