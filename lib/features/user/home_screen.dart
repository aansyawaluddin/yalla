import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';
// Sesuaikan path import ini jika letak folder Anda berbeda
import 'package:yalla/core/widgets/flight_info_card.dart';
import 'package:yalla/core/widgets/hotel_info_card.dart';
import 'package:yalla/core/widgets/promo_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedServiceIndex = 0;
  bool _isOneWay = true;
  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F6F8,
      ), // Latar belakang abu-abu terang Scaffold
      body: Stack(
        children: [
          // --- 1. FIXED BACKGROUND PESAWAT DENGAN GRADASI MEMUDAR (KUNCI blending) ---
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            // Tinggi background sedikit lebih rendah agar card utama bisa menggantung di bawahnya
            height: MediaQuery.of(context).size.height * 0.40,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF557799), // Warna fallback
                image: DecorationImage(
                  image: AssetImage('assets/images/pesawat.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment
                      .topCenter, // Memastikan gambar pesawat terlihat di atas
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(
                        0.6,
                      ), // Gelap di atas untuk teks putih agar terbaca
                      Colors.transparent, // Transparan di tengah
                      const Color(
                        0xFFF5F6F8,
                      ), // Warna memudar ke background solid agar blending mulus
                    ],
                    // stops diatur agar blending putihnya dimulai sekitar 60% ke bawah dan padat di 100%
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // --- 2. KONTEN YANG BISA DI-SCROLL (SingleChildScrollView Transparan) ---
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER (Profil & Notifikasi) - Background Transparan
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 24,
                              backgroundImage: AssetImage(
                                'assets/images/profile.png',
                              ),
                              backgroundColor: Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Selamat Datang,",
                                  style: AppTypography.regular12.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      "Syahdam ",
                                      style: AppTypography.bold14.copyWith(
                                        color: AppColors.primary,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Text(
                                      "👋",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications_none,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: AppColors.lightBlue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // CARD PEMESANAN UTAMA - Background Putih Menggantung
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary, // Putih Solid
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppColors.defaultShadow,
                    ),
                    child: Column(
                      children: [
                        // TAB BAR YANG MENYATU DENGAN GARIS
                        Row(
                          children: [
                            _buildServiceTab(
                              0,
                              "Pesawat",
                              'assets/icons/plane_3d.png',
                            ),
                            _buildServiceTab(
                              1,
                              "Hotel",
                              'assets/icons/hotel.png',
                            ),
                            _buildServiceTab(
                              2,
                              "Visa",
                              'assets/icons/visa.png',
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Column(
                              children: [
                                _buildLocationInput(
                                  leadingWidget: const Icon(
                                    Icons.location_on,
                                    color: AppColors.error,
                                    size: 24,
                                  ),
                                  title: "Makassar",
                                  subtitle: " - UPGC",
                                  isTop: true,
                                ),
                                const SizedBox(height: 12),
                                _buildLocationInput(
                                  leadingWidget: const Icon(
                                    Icons.flight_land,
                                    color: AppColors.lightBlue,
                                    size: 24,
                                  ),
                                  title: "",
                                  subtitle: "",
                                  isTop: false,
                                ),
                              ],
                            ),
                            Positioned(
                              right: 24,
                              child: Container(
                                height: 46,
                                width: 46,
                                decoration: BoxDecoration(
                                  color: AppColors.lightBlue,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.lightBlue.withOpacity(
                                        0.4,
                                      ),
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
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.line),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              _buildTripTypeButton("Sekali Jalan", true),
                              _buildTripTypeButton("Pulang - Pergi", false),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        _buildStandardInput(
                          Icons.calendar_today_outlined,
                          "Pilih Tanggal",
                        ),

                        const SizedBox(height: 16),

                        _buildStandardInput(
                          Icons.person_outline,
                          "Pilih Penumpang",
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.lightBlue,
                              foregroundColor: AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              "Cari Penerbangan",
                              style: AppTypography.bold14.copyWith(
                                color: AppColors.primary,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- 3. KONTEN BAWAH (BACKGROUND SOLID) ---
                  // Kita membungkus semua konten di bawah Card Pemesanan ke dalam Container
                  // dengan warna latar belakang yang sama dengan Scaffold agar menutupi
                  // background pesawat saat di-scroll ke bawah.
                  Container(
                    color: const Color(
                      0xFFF5F6F8,
                    ), // Latar Belakang Solid Abu/Putih
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        // KOLOM PENCARIAN
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            height: 54,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: AppColors.defaultShadow,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.search,
                                  color: AppColors.textGrey,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "Cari Penerbangan",
                                  style: AppTypography.regular14.copyWith(
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // --- INFORMASI PENTING ---
                        _buildSectionHeader("Informasi Penting"),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          clipBehavior:
                              Clip.none, // Agar bayangan tidak terpotong
                          child: const Row(
                            children: [
                              FlightInfoCard(),
                              SizedBox(width: 16),
                              HotelInfoCard(),
                            ],
                          ),
                        ),

                        const SizedBox(height: 36),

                        // --- PENAWARAN KHUSUS ---
                        _buildSectionHeader("Penawaran Khusus"),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              PromoCard(
                                title: "VVIP Umrah Sebulan Penuh",
                                price: "IDR 150 Jt",
                                tag: "Spesial Ramadhan",
                                tagColor: Colors.amber.shade600,
                                imagePath: 'assets/images/promo_kaabah.png',
                              ),
                              const SizedBox(width: 16),
                              PromoCard(
                                title: "Umrah Eksekutif",
                                price: "IDR 50 Jt",
                                tag: "Paket Keluarga",
                                tagColor: AppColors.lightBlue,
                                imagePath: 'assets/images/promo_kaabah.png',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 36),

                        // --- PENAWARAN TERBATAS ---
                        _buildSectionHeader("Penawaran Terbatas"),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              PromoCard(
                                title: "VVIP Umrah Sebulan Penuh",
                                price: "IDR 150 Jt",
                                tag: "Spesial Ramadhan",
                                tagColor: Colors.amber.shade600,
                                imagePath: 'assets/images/promo_kaabah.png',
                              ),
                              const SizedBox(width: 16),
                              PromoCard(
                                title: "Umrah Eksekutif",
                                price: "IDR 50 Jt",
                                tag: "Paket Keluarga",
                                tagColor: AppColors.lightBlue,
                                imagePath: 'assets/images/promo_kaabah.png',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(color: Color(0xFFD4D4D4)),
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomNavItem(0, Icons.home_filled, "Beranda"),
            _buildBottomNavItem(1, Icons.favorite_border, "Favorit"),
            _buildBottomNavItem(2, Icons.flight, "Jelajahi"),
            _buildBottomNavItem(3, Icons.receipt_long_outlined, "Pesanan"),
            _buildBottomNavItem(4, Icons.person_outline, "Profil"),
          ],
        ),
      ),
    );
  }

  // ─── FUNGSI HELPER WIDGET ───

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.bold18.copyWith(color: AppColors.textDark),
          ),
          Text(
            "Lihat Semua",
            style: AppTypography.regular12.copyWith(color: AppColors.lightBlue),
          ),
        ],
      ),
    );
  }

  // Tab yang menyatu dengan garis pembatas
  Widget _buildServiceTab(int index, String title, String imagePath) {
    bool isActive = _selectedServiceIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedServiceIndex = index),
        child: Container(
          padding: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            // Garis bawah akan menyatu untuk semua tab
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.secondary : AppColors.line,
                width: isActive
                    ? 2.5
                    : 1.0, // Tebal jika aktif, tipis jika tidak
              ),
            ),
          ),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: isActive
                    ? AppTypography.bold12.copyWith(color: AppColors.textDark)
                    : AppTypography.regular12.copyWith(
                        color: AppColors.textGrey,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Menggunakan Parameter Widget agar bisa diisi Icon biasa atau Image.asset 3D
  Widget _buildLocationInput({
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
          leadingWidget, // Menampilkan Icon atau Image 3D di sini
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

  Widget _buildTripTypeButton(String title, bool isOneWayButton) {
    bool isSelected = _isOneWay == isOneWayButton;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isOneWay = isOneWayButton),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.lightBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: AppTypography.bold12.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStandardInput(IconData icon, String hint) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textGrey, size: 22),
          const SizedBox(width: 12),
          Text(
            hint,
            style: AppTypography.regular14.copyWith(color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label) {
    bool isActive = _bottomNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _bottomNavIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.lightBlue : AppColors.primary,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: isActive
                ? AppTypography.bold10.copyWith(color: AppColors.lightBlue)
                : AppTypography.regular10.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
