import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';
import 'package:yalla/features/user/home/home_screen.dart';
import 'package:yalla/features/user/order/order_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});

  // --- LOGIKA NAVIGASI ---
  void _onItemTapped(BuildContext context, int index) {
    // Jika tap pada tab yang sedang aktif, tidak perlu melakukan apa-apa
    if (index == currentIndex) return;

    Widget targetScreen = const HomeScreen();

    // Tentukan halaman tujuan berdasarkan index
    switch (index) {
      case 0:
        targetScreen = const HomeScreen();
        break;
      case 1:
        // TODO: Ganti dengan halaman Favorit yang sebenarnya jika sudah ada
        targetScreen = const Scaffold(
          body: Center(child: Text("Halaman Favorit")),
        );
        break;
      case 2:
        // Index 2 untuk Jelajahi (Bisa diarahkan ke FlightListScreen atau halaman Jelajah utama)
        targetScreen = const Scaffold(
          body: Center(child: Text("Halaman Jelajahi")),
        );
        break;
      case 3:
        targetScreen = const OrderScreen();
        break;
      case 4:
        // TODO: Ganti dengan halaman Profil yang sebenarnya jika sudah ada
        targetScreen = const Scaffold(
          body: Center(child: Text("Halaman Profil")),
        );
        break;
      default:
        targetScreen = const HomeScreen();
    }

    // Gunakan pushReplacement agar halaman tidak menumpuk di memory
    // PageRouteBuilder dengan durasi 0 agar transisinya instan (seperti pindah tab)
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
    return Container(
      height: 80,
      decoration: const BoxDecoration(color: Color(0xFFD4D4D4)),
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomNavItem(context, 0, Icons.home_filled, "Beranda"),
          _buildBottomNavItem(context, 1, Icons.favorite_border, "Favorit"),
          _buildBottomNavItem(context, 2, Icons.flight, "Jelajahi"),
          _buildBottomNavItem(
            context,
            3,
            Icons.receipt_long_outlined,
            "Pesanan",
          ),
          _buildBottomNavItem(context, 4, Icons.person_outline, "Profil"),
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
    return GestureDetector(
      onTap: () =>
          _onItemTapped(context, index), // Panggil logika navigasi di sini
      child: Container(
        color: Colors.transparent, // Membuat seluruh area kolom bisa di-tap
        width: 60,
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
      ),
    );
  }
}
