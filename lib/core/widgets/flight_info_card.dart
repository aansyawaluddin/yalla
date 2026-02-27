import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';

class FlightInfoCard extends StatelessWidget {
  const FlightInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Menerapkan gradien dari putih ke biru muda dari kiri atas ke kanan bawah
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary, // Putih
            AppColors.primary, // Putih (dominan di kiri)
            AppColors.lightBlue.withOpacity(0.15), // Biru muda di kanan
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.defaultShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo Maskapai - Menggunakan gambar yang sesuai desain
              CircleAvatar(
                radius: 28, // Diperbesar sesuai desain
                backgroundColor: Colors
                    .transparent, // Background transparan jika logo punya background sendiri
                // GANTI DENGAN PATH GAMBAR LOGO FLYDEAL ANDA:
                backgroundImage: const AssetImage(
                  'assets/images/logo_flydeal.png',
                ),
                // Jika Anda belum punya gambarnya dan ingin pakai warna solid sementara, gunakan ini:
                // backgroundColor: const Color(0xFF6A1B9A), // Warna ungu tua sebagai fallback
              ),
              const SizedBox(width: 16), // Jarak disesuaikan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Flydeal Air",
                      style: AppTypography.bold14.copyWith(
                        color: AppColors.textDark, // Warna hitam/gelap
                        fontSize: 16, // Sedikit diperbesar
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Menggunakan Wrap agar tidak error jika layar HP kecil
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 14, // Ukuran disesuaikan
                              color: AppColors
                                  .secondary, // Warna biru sesuai desain
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "06 Juni 2026",
                              style: AppTypography.regular10.copyWith(
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time, // Mengganti ikon
                              size: 14,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "08 : 30 WITA",
                              style: AppTypography.regular10.copyWith(
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "1 Dewasa  •  Ekonomi",
                      style: AppTypography.regular10.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              // Badge "2 Hari Lagi"
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary, // Latar putih untuk badge
                  borderRadius: BorderRadius.circular(12),
                  // Menambahkan shadow tipis agar terlihat seperti melayang
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  "2 Hari Lagi",
                  style: AppTypography.bold10.copyWith(
                    color: AppColors.lightBlue, // Teks biru muda
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24), // Jarak antara info dan rute
          // Rute JED -> UPG
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "JED",
                    style: AppTypography.bold18.copyWith(
                      color: AppColors.textDark,
                      fontSize: 20, // Diperbesar
                    ),
                  ),
                  Text(
                    "Jeddah",
                    style: AppTypography.regular12.copyWith(
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
              // Bagian Garis Tengah "On Time"
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Text(
                        "On Time",
                        style: AppTypography.bold10.copyWith(
                          color: AppColors.successDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Membuat efek garis sesuai desain (putus di pinggir, solid di tengah)
                      Row(
                        children: [
                          Expanded(
                            child: Container(height: 1, color: AppColors.line),
                          ),
                          Container(
                            width: 30,
                            height: 2,
                            color: AppColors.successDark,
                          ), // Bagian solid
                          Expanded(
                            child: Container(height: 1, color: AppColors.line),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "UPG",
                    style: AppTypography.bold18.copyWith(
                      color: AppColors.textDark,
                      fontSize: 20, // Diperbesar
                    ),
                  ),
                  Text(
                    "Makassar",
                    style: AppTypography.regular12.copyWith(
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
