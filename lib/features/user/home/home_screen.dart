import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';
import 'package:yalla/core/widgets/animated/animatedSearchBar.dart';
import 'package:yalla/core/widgets/card/flight_card.dart';
import 'package:yalla/core/widgets/button/custom_bottom_nav_bar.dart';
import 'package:yalla/core/widgets/card/flight_info_card.dart';
import 'package:yalla/core/widgets/card/promo_card.dart';
import 'package:yalla/core/widgets/card/travel_card.dart';
import 'package:yalla/core/widgets/header/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedServiceIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_home.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.5),
                      const Color(0xFFF5F6F8),
                    ],
                    stops: const [0.4, 0.8, 1.0],
                  ),
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 180),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 36,
                          height: 1.2,
                          color: Color(0xFF005C99),
                        ),
                        children: [
                          const TextSpan(
                            text: "Langkah Mudah\nMenuju ",
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                          TextSpan(
                            text: "Tanah Suci",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF001F33),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  AnimatedSearchBar(
                    selectedServiceIndex: _selectedServiceIndex,
                  ),

                  const SizedBox(height: 30),

                  const Align(
                    alignment: Alignment.center,
                    child: FlightInfoCard(),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(isActive: true),
                      _buildDot(isActive: false),
                      _buildDot(isActive: false),
                    ],
                  ),

                  const SizedBox(height: 32),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBigServiceTab(
                          index: 0,
                          title: "Pesawat",
                          imagePath: 'assets/icons/planee.png',
                        ),
                        const SizedBox(width: 12),
                        _buildBigServiceTab(
                          index: 1,
                          title: "Hotel",
                          imagePath: 'assets/icons/hotel.png',
                        ),
                        const SizedBox(width: 12),
                        _buildBigServiceTab(
                          index: 2,
                          title: "Visa",
                          imagePath: 'assets/icons/visa.png',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  _buildSectionHeader(title: "Penawaran Khusus"),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    clipBehavior: Clip.none,
                    child: Row(
                      children: const [
                        PromoCard(
                          title: "VVIP Umrah Sebulan Penuh",
                          price: "IDR 150 Jt",
                          tag: "Spesial Ramadhan",
                          tagColor: Color(0xFFFFB300),
                          imagePath: 'assets/images/kaabah.jpeg',
                        ),
                        SizedBox(width: 16),
                        PromoCard(
                          title: "Umrah Eksekutif",
                          price: "IDR 50 Jt",
                          tag: "Paket Keluarga",
                          tagColor: AppColors.lightBlue,
                          imagePath: 'assets/images/kaabah.jpeg',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  _buildSectionHeader(
                    title: "Keberangkatan Terdekat",
                    subtitle: "Siapkan koper Anda segera",
                    showAction: false,
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: FlightOptionCard(),
                  ),

                  const SizedBox(height: 36),

                  _buildSectionHeader(
                    title: "Travel Populer",
                    subtitle: "Penyelenggara umroh terpercaya",
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    clipBehavior: Clip.none,
                    child: Row(
                      children: const [
                        TravelCard(
                          title: "CMA Tour &\nTravel",
                          rating: 4.9,
                          reviews: "2.4k",
                          badgeText: "Terverifikasi",
                          badgeColor: Color(0xFF0099FF),
                          badgeIcon: Icons.verified,
                          imagePath: 'assets/images/kaabah.jpeg',
                        ),
                        SizedBox(width: 16),
                        TravelCard(
                          title: "Rabbani Tour",
                          rating: 4.9,
                          reviews: "2.4k",
                          badgeText: "Top Rated",
                          badgeColor: Color(0xFFFF8C00),
                          badgeIcon: Icons.emoji_events,
                          imagePath: 'assets/images/kaabah.jpeg',
                        ),
                        SizedBox(width: 16),
                        TravelCard(
                          title: "Rabbani Tour",
                          rating: 4.9,
                          reviews: "2.4k",
                          badgeText: "Top Rated",
                          badgeColor: Color(0xFFFF8C00),
                          badgeIcon: Icons.emoji_events,
                          imagePath: 'assets/images/kaabah.jpeg',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Positioned(top: 0, left: 0, right: 0, child: HomeHeader()),
        ],
      ),

      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF005C99) : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildBigServiceTab({
    required int index,
    required String title,
    required String imagePath, // Diubah dari IconData ke String imagePath
  }) {
    bool isActive = _selectedServiceIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedServiceIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            // Border untuk isActive sudah dihapus di sini
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Menggunakan Image.asset alih-alih Icon
              Image.asset(
                imagePath,
                width: 32,
                height: 32,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w700,
                  color: const Color(0xFF005C99),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    String? subtitle,
    bool showAction = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bold18.copyWith(color: AppColors.textDark),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTypography.regular12.copyWith(
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ],
          ),
          if (showAction)
            Text(
              "Lihat Semua",
              style: AppTypography.regular12.copyWith(
                color: AppColors.lightBlue,
              ),
            ),
        ],
      ),
    );
  }
}
