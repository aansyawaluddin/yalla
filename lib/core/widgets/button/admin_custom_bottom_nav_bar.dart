import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';
import 'package:yalla/features/admin/beranda/admin_dashboard_screen.dart';
import 'package:yalla/features/admin/plane/admin_flight_scree.dart';
import 'package:yalla/features/admin/profile/admin_profile_screen.dart';

class CustomAdminBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomAdminBottomNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;


    Widget targetScreen = const AdminDashboardScreen();

    switch (index) {
      case 0:
        targetScreen = const AdminDashboardScreen();
        break;
      case 1:
        targetScreen = const AdminFlightScreen();
        break;
      // case 2:
      //   targetScreen = const AdminHotelScreen();
      //   break;
      // case 3:
      //   targetScreen = const AdminVisaScreen();
      //   break;
      case 4:
        targetScreen = const AdminProfileScreen();
        break;
      default:
        targetScreen = const AdminDashboardScreen();
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
      height: 95, // Tinggi sama dengan nav user
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
                _buildBottomNavItem(context, 1, Icons.flight, "Pesawat"),
                _buildBottomNavItem(context, 2, Icons.domain, "Hotel"),
                _buildBottomNavItem(context, 3, Icons.credit_card, "Visa"),
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
}
