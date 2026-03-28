import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';
import 'package:yalla/features/travel/home/home_plane_travel_screen.dart';
import 'package:yalla/features/travel/profile/profile_screen_travel.dart';

class TravelCustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const TravelCustomBottomNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget targetScreen = const HomePlaneTravelScreen();

    switch (index) {
      case 0:
        targetScreen = const HomePlaneTravelScreen();
        break;
      case 1:
        targetScreen = const Scaffold(
          body: Center(child: Text("Halaman Favorit")),
        );
        break;
      case 2:
        targetScreen = const Scaffold(
          body: Center(child: Text("Halaman Jelajahi")),
        );
        break;
      case 3:
        // targetScreen = const OrderScreen();
        break;
      case 4:
        targetScreen = const ProfileScreenTravel();
        break;
      default:
        targetScreen = const HomePlaneTravelScreen();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBottomNavItem(context, 0, Icons.home_outlined, "Beranda"),
                _buildBottomNavItem(
                  context,
                  1,
                  Icons.favorite_border,
                  "Favorite",
                ),
                _buildCenterItem(context, 2),
                _buildBottomNavItem(
                  context,
                  3,
                  Icons.local_activity_outlined,
                  "Pesanan",
                ), // Ikon tiket
                _buildBottomNavItem(context, 4, Icons.person_outline, "Profil"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    bool isActive = currentIndex == index;
    Color itemColor = isActive ? AppColors.lightBlue : Colors.grey.shade400;

    return GestureDetector(
      onTap: () => _onItemTapped(context, index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        height: 65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(icon, color: itemColor, size: 26),
            const SizedBox(height: 6),
            Text(
              label,
              style: isActive
                  ? AppTypography.bold10.copyWith(color: itemColor)
                  : AppTypography.regular10.copyWith(color: itemColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(context, index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF004CBF),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(
            Icons.change_circle_outlined,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}
