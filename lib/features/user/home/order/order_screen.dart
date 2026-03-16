import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';
import 'package:yalla/core/widgets/button/custom_bottom_nav_bar.dart';
import 'package:yalla/core/widgets/card/order_card.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _bottomNavIndex = 3; // Index untuk tab 'Pesanan'

  @override
  Widget build(BuildContext context) {
    // Membungkus Scaffold dengan DefaultTabController untuk fitur TabBar
    return DefaultTabController(
      length: 2, // Jumlah tab (Aktif & Riwayat)
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F8), // Latar abu-abu terang
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Pesanan Saya",
            style: AppTypography.bold18.copyWith(color: AppColors.textDark),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE5E5E5),
                    width: 1.5,
                  ), // Garis bawah abu-abu
                ),
              ),
              child: TabBar(
                indicatorColor: AppColors.secondary, // Garis biru tab aktif
                indicatorWeight: 3,
                labelColor: AppColors.secondary,
                unselectedLabelColor: AppColors.textGrey,
                labelStyle: AppTypography.bold14,
                unselectedLabelStyle: AppTypography.regular14,
                tabs: const [
                  Tab(text: "Aktif"),
                  Tab(text: "Riwayat"),
                ],
              ),
            ),
          ),
        ),

        body: const TabBarView(
          children: [
            // --- TAB 1: AKTIF ---
            _TabAktifContent(),

            // --- TAB 2: RIWAYAT ---
            _TabRiwayatContent(),
          ],
        ),

        // Bottom Navigation Bar
        bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
      ),
    );
  }
}

// ==========================================
// KONTEN TAB "AKTIF"
// ==========================================
class _TabAktifContent extends StatelessWidget {
  const _TabAktifContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // 1. Kartu Hotel (Menunggu Pembayaran)
        OrderCard(
          icon: Icons.domain,
          categoryTitle: "HOTEL",
          statusText: "Menunggu Pembayaran",
          statusBgColor: const Color(0xFFEAF4FF),
          statusTextColor: AppColors.lightBlue,
          totalPrice: "IDR 1.250.000",
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Hotel
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/hotel_bg.png', // Ganti dengan path asset kamu
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info Hotel
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hotel Borobudur Jakarta",
                      style: AppTypography.bold14.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: AppColors.textGrey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Okt 12 - 15 Okt",
                          style: AppTypography.regular12.copyWith(
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "3 Malam | 2 Tamu",
                      style: AppTypography.regular12.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Superior King Room",
                      style: AppTypography.regular12.copyWith(
                        color: AppColors.lightBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 2. Kartu Pesawat (Transaksi Berhasil)
        OrderCard(
          icon: Icons.flight,
          categoryTitle: "PESAWAT",
          statusText: "Transaksi Berhasil",
          statusBgColor: const Color(0xFFE8F5E9),
          statusTextColor: const Color(0xFF20AD00),
          totalPrice: "IDR 11.000.000",
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6B2B85), // Warna ungu Flydeal
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        "flyadeal",
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Flydeal Air",
                        style: AppTypography.bold14.copyWith(
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: AppColors.textGrey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "08 Juni 2026",
                            style: AppTypography.regular12.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.access_time,
                            size: 12,
                            color: AppColors.textGrey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "08:30 WITA",
                            style: AppTypography.regular12.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "1 Dewasa | Ekonomi",
                        style: AppTypography.regular10.copyWith(
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Rute UPG -> JED
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "UPG",
                        style: AppTypography.bold14.copyWith(
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        "Makassar",
                        style: AppTypography.regular10.copyWith(
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: Container(height: 1, color: AppColors.line)),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      Text(
                        "JED",
                        style: AppTypography.bold14.copyWith(
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        "Jeddah",
                        style: AppTypography.regular10.copyWith(
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 3. Kartu Visa (Disetujui)
        OrderCard(
          icon: Icons.description_outlined,
          categoryTitle: "VISA",
          statusText: "Disetujui",
          statusBgColor: const Color(0xFFE8F5E9),
          statusTextColor: const Color(0xFF20AD00),
          totalPrice:
              "IDR 2.500.000", // Asumsi harga karena di desain terpotong
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tourist E-Visa (Jeddah)",
                style: AppTypography.bold14.copyWith(color: AppColors.textDark),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: AppColors.textGrey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "06 Juni 2026",
                    style: AppTypography.regular12.copyWith(
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================
// KONTEN TAB "RIWAYAT"
// ==========================================
class _TabRiwayatContent extends StatelessWidget {
  const _TabRiwayatContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Kartu Hotel (Riwayat - Status diganti Tanggal)
        OrderCard(
          icon: Icons.domain,
          categoryTitle: "HOTEL",
          statusText: "12 Okt 2026", // Di riwayat jadi tanggal abu-abu
          statusBgColor: const Color(0xFFF5F6F8),
          statusTextColor: AppColors.textGrey,
          totalPrice: "IDR 1.250.000",
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/hotel_bg.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hotel Borobudur Jakarta",
                      style: AppTypography.bold14.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: AppColors.textGrey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Okt 12 - 15 Okt",
                          style: AppTypography.regular12.copyWith(
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "3 Malam | 2 Tamu",
                      style: AppTypography.regular12.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Superior King Room",
                      style: AppTypography.regular12.copyWith(
                        color: AppColors.lightBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
