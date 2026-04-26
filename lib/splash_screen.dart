import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:yalla/features/admin/beranda/admin_dashboard_screen.dart';

import 'package:yalla/features/auth/login_screen.dart';
import 'package:yalla/features/auth/providers/auth_provider.dart';
import 'package:yalla/features/travel/home/home_plane_travel_screen.dart';
import 'package:yalla/features/user/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _step = 1;

  @override
  void initState() {
    super.initState();
    _jalankanAnimasi();
  }

  void _jalankanAnimasi() async {
    // Step 1: Delay awal
    await Future.delayed(const Duration(seconds: 1));

    // Step 2: Logo membesar
    if (mounted) setState(() => _step = 2);
    await Future.delayed(const Duration(milliseconds: 800));

    // Step 3: Cahaya muncul
    if (mounted) setState(() => _step = 3);
    await Future.delayed(const Duration(milliseconds: 800));

    // Step 4: Cahaya menyatu ke tengah
    if (mounted) setState(() => _step = 4);
    await Future.delayed(const Duration(milliseconds: 800));

    // Step 5: Cahaya memudar (Fade out)
    if (mounted) setState(() => _step = 5);
    await Future.delayed(const Duration(milliseconds: 600));

    // Step 6: Logo & Pesawat bergerak ke posisi akhir
    if (mounted) setState(() => _step = 6);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    final role = await authProvider.checkLoginStatus();

    if (!mounted) return;

    if (role != null) {
      Widget targetScreen;
      if (role == 'admin') {
        targetScreen =
            const AdminDashboardScreen(); 
      } else if (role == 'travel') {
        targetScreen = const HomePlaneTravelScreen(); 
      } else {
        targetScreen = const HomeScreen(); 
      }
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else {
      if (mounted) setState(() => _step = 7);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const double logoContainerSize = 200.0;
    const double finalLogoSize = 150.0;
    const double planeSize = 60.0;

    final centerTop = screenHeight / 2 - (logoContainerSize / 2);
    final centerLeft = screenWidth / 2 - (logoContainerSize / 2);

    final double alignCenterY = 120.0;
    final double planeTop = alignCenterY - (planeSize / 2);
    final double targetTop = alignCenterY - (logoContainerSize / 2);
    final double targetLeftForRightPos = screenWidth - logoContainerSize;

    const double lightSize = 300.0;
    final centerLightTop = screenHeight / 2 - (lightSize / 2);
    final centerLightX = screenWidth / 2 - (lightSize / 2);

    return Scaffold(
      backgroundColor: const Color(0xFF004CB9),
      body: Stack(
        children: [
          // Efek Cahaya Glow 1
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            top: _step >= 4
                ? centerLightTop
                : (_step == 3 ? screenHeight - 200 : screenHeight),
            left: _step >= 4 ? centerLightX : (_step == 3 ? -150 : -300),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: (_step == 3 || _step == 4) ? 1.0 : 0.0,
              child: _buildGlowLight(),
            ),
          ),

          // Efek Cahaya Glow 2
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            top: _step >= 4 ? centerLightTop : (_step == 3 ? 0 : -200),
            right: _step >= 4 ? centerLightX : (_step == 3 ? -150 : -300),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: (_step == 3 || _step == 4) ? 1.0 : 0.0,
              child: _buildGlowLight(),
            ),
          ),

          // Animasi Logo
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
            top: _step >= 6 ? targetTop : centerTop,
            left: _step >= 6 ? targetLeftForRightPos : centerLeft,
            child: Container(
              width: logoContainerSize,
              height: logoContainerSize,
              alignment: Alignment.center,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutBack,
                scale: _step == 1
                    ? 0.3
                    : (_step >= 6 ? (finalLogoSize / logoContainerSize) : 1.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Animasi Pesawat
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            top: planeTop,
            left: _step >= 6 ? 40 : -100,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: _step >= 6 ? 1.0 : 0.0,
              child: Image.asset(
                'assets/icons/plane.png',
                width: planeSize,
                height: planeSize,
                color: Colors.white,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Layer Login Screen (Muncul jika belum login)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutQuart,
            top: _step == 7 ? 170 : screenHeight,
            left: 0,
            right: 0,
            height: screenHeight - 170,
            child: LoginScreen(screenHeight: screenHeight),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowLight() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.lightBlueAccent.withOpacity(0.6),
            blurRadius: 90,
            spreadRadius: 30,
          ),
        ],
      ),
    );
  }
}
