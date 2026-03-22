import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';
import 'package:yalla/core/widgets/animated/animatedSearchBar.dart';
import 'package:yalla/core/widgets/card/flight_card.dart';
import 'package:yalla/core/widgets/button/custom_bottom_nav_bar.dart';
import 'package:yalla/core/widgets/card/flight_info_card.dart';
import 'package:yalla/core/widgets/card/promo_card.dart';
import 'package:yalla/core/widgets/card/travel_card.dart';
import 'package:yalla/features/user/home/paket/paket_umrah_screen.dart';
import 'package:yalla/features/user/home/travel/travel_list_screen.dart';
import 'package:yalla/features/user/plane/home_plane.dart';

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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -90.0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55 + 70,
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

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                image: const DecorationImage(
                                  image: AssetImage(
                                    'assets/images/profile.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Selamat Datang,",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF005C99),
                                  ),
                                ),
                                Text(
                                  "Syahdam 👋",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF005C99),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: Color(0xFF005C99),
                              size: 18,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 20,
                          height: 1.2,
                          color: Color(0xFF005C99),
                        ),
                        children: [
                          TextSpan(
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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0x00FFFFFF), Color(0xFFF2FAFF)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF2FAFF),
                                spreadRadius: 10,
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const FlightInfoCard(),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildDot(isActive: true),
                                  const SizedBox(width: 4),
                                  _buildDot(isActive: false),
                                  const SizedBox(width: 4),
                                  _buildDot(isActive: false),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

                  const SizedBox(height: 20),

                  _buildSectionHeader(
                    title: "Travel Populer",
                    subtitle: "Penyelenggara umroh terpercaya",
                    onActionTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          reverseTransitionDuration: const Duration(
                            milliseconds: 300,
                          ),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const TravelListScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                var curvedAnimation = CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOut,
                                );
                                return FadeTransition(
                                  opacity: curvedAnimation,
                                  child: child,
                                );
                              },
                        ),
                      );
                    },
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

                  const SizedBox(height: 20),

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

                  const SizedBox(height: 20),

                  _buildSectionHeader(
                    title: "Penawaran Khusus",
                    onActionTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          reverseTransitionDuration: const Duration(
                            milliseconds: 300,
                          ),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const PaketUmrahScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                var curvedAnimation = CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOut,
                                );
                                return FadeTransition(
                                  opacity: curvedAnimation,
                                  child: child,
                                );
                              },
                        ),
                      );
                    },
                  ),
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
                ],
              ),
            ),
          ),

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
    required String imagePath,
  }) {
    bool isActive = _selectedServiceIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedServiceIndex = index;
          });

          if (index == 0) {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 300),
                reverseTransitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const HomePlane(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      var curvedAnimation = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      );
                      return FadeTransition(
                        opacity: curvedAnimation,
                        child: child,
                      );
                    },
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
    VoidCallback? onActionTap,
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
            GestureDetector(
              onTap: onActionTap,
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  "Lihat Semua",
                  style: AppTypography.regular12.copyWith(
                    color: AppColors.lightBlue,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
