import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';
import 'package:yalla/core/widgets/animated/animatedSearchBar.dart';
import 'package:yalla/core/widgets/card/flight_info_card.dart';
import 'package:yalla/core/widgets/card/hotel_info_card.dart';
import 'package:yalla/core/widgets/card/promo_card.dart';
import 'package:yalla/core/widgets/header/home_header.dart';
import 'package:yalla/features/user/home/tab/hotel_tab.dart';
import 'package:yalla/features/user/home/tab/pesawat_tab.dart';
import 'package:yalla/features/user/home/tab/visa_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedServiceIndex = 0;
  int _bottomNavIndex = 0;

  String _getBackgroundImage() {
    switch (_selectedServiceIndex) {
      case 0:
        return 'assets/images/pesawat.png';
      case 1:
        return 'assets/images/pesawat.png';
      case 2:
        return 'assets/images/pesawat.png'; 
      default:
        return 'assets/images/pesawat.png';
    }
  }

  Widget _buildSelectedTabContent() {
    switch (_selectedServiceIndex) {
      case 0:
        return const PesawatTab(key: ValueKey(0));
      case 1:
        return const HotelTab(key: ValueKey(1));
      case 2:
        return const VisaTab(key: ValueKey(2));
      default:
        return const PesawatTab(key: ValueKey(0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 40),
            child: Stack(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                  child: Container(
                    key: ValueKey<int>(_selectedServiceIndex),
                    height: MediaQuery.of(context).size.height * 0.45,
                    decoration: BoxDecoration(
                      color: const Color(0xFF557799),
                      image: DecorationImage(
                        image: AssetImage(_getBackgroundImage()),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [Color(0xFFF5F6F8), Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 220,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    const SizedBox(height: 180),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppColors.defaultShadow,
                      ),
                      child: Column(
                        children: [
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

                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            switchInCurve: Curves.easeInOut,
                            switchOutCurve: Curves.easeInOut,
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                            child: _buildSelectedTabContent(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    const AnimatedSearchBar(),
                    const SizedBox(height: 30),

                    // --- Informasi Penting ---
                    _buildSectionHeader("Informasi Penting"),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      clipBehavior: Clip.none,
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            FlightInfoCard(),
                            SizedBox(width: 16),
                            HotelInfoCard(),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    // --- Penawaran Khusus ---
                    _buildSectionHeader("Penawaran Khusus"),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: const [
                          PromoCard(
                            title: "VVIP Umrah Sebulan Penuh",
                            price: "IDR 150 Jt",
                            tag: "Spesial Ramadhan",
                            tagColor: Color(0xFFFFB300),
                            imagePath: 'assets/images/promo_kaabah.png',
                          ),
                          SizedBox(width: 16),
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

                    // --- Penawaran Terbatas ---
                    _buildSectionHeader("Penawaran Terbatas"),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: const [
                          PromoCard(
                            title: "VVIP Umrah Sebulan Penuh",
                            price: "IDR 150 Jt",
                            tag: "Spesial Ramadhan",
                            tagColor: Color(0xFFFFB300),
                            imagePath: 'assets/images/promo_kaabah.png',
                          ),
                          SizedBox(width: 16),
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
              ],
            ),
          ),

          const Positioned(top: 0, left: 0, right: 0, child: HomeHeader()),
        ],
      ),

      // Bottom Navigation Bar
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

  Widget _buildServiceTab(int index, String title, String imagePath) {
    bool isActive = _selectedServiceIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedServiceIndex = index),
        child: Container(
          padding: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.secondary : AppColors.line,
                width: isActive ? 2.5 : 1.0,
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
