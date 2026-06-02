import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:yalla/features/admin/beranda/admin_dashboard_screen.dart';
import 'package:yalla/features/auth/login_screen.dart';
import 'package:yalla/core/providers/auth_provider.dart';
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
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) setState(() => _step = 2);
    await Future.delayed(const Duration(milliseconds: 800));

    // Step 3: Dua cahaya muncul di sudut (kanan-atas & kiri-bawah)
    if (mounted) setState(() => _step = 3);
    await Future.delayed(const Duration(milliseconds: 1000));

    // Step 4: Cahaya menyatu jadi satu glow besar di tengah
    if (mounted) setState(() => _step = 4);
    await Future.delayed(const Duration(milliseconds: 1000));

    // Step 5: Cahaya memudar
    if (mounted) setState(() => _step = 5);
    await Future.delayed(const Duration(milliseconds: 600));

    // Step 6: Logo & Pesawat bergerak ke posisi akhir + trail asap
    if (mounted) setState(() => _step = 6);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    final role = await authProvider.checkLoginStatus();

    if (!mounted) return;

    if (role != null) {
      Widget targetScreen;
      if (role == 'admin') {
        targetScreen = const AdminDashboardScreen();
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

    const double alignCenterY = 120.0;
    final double planeTop = alignCenterY - (planeSize / 2);
    final double targetTop = alignCenterY - (logoContainerSize / 2);
    final double targetLeftForRightPos = screenWidth - logoContainerSize;

    // Ukuran glow besar saat menyatu di tengah (step 4)
    const double bigGlowSize = 300.0;
    final centerBigGlowTop = screenHeight / 2 - (bigGlowSize / 2);

    // Ukuran cahaya sudut (step 3)
    const double cornerGlowSize = 200.0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF004CB9),
      body: Stack(
        children: [
          // ── CAHAYA SUDUT KANAN-ATAS (step 3) ──
          AnimatedPositioned(
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOut,
            top: _step >= 4
                ? centerBigGlowTop
                : (_step == 3 ? -cornerGlowSize * 0.4 : -cornerGlowSize),
            right: _step >= 4
                ? (screenWidth / 2 - bigGlowSize / 2)
                : (_step == 3 ? -cornerGlowSize * 0.4 : -cornerGlowSize),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: (_step == 3 || _step == 4) ? 1.0 : 0.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeInOut,
                width: _step >= 4 ? bigGlowSize : cornerGlowSize,
                height: _step >= 4 ? bigGlowSize : cornerGlowSize,
                child: _buildGlowLight(
                  _step >= 4 ? bigGlowSize : cornerGlowSize,
                ),
              ),
            ),
          ),

          // ── CAHAYA SUDUT KIRI-BAWAH (step 3) ──
          AnimatedPositioned(
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOut,
            bottom: _step >= 4
                ? (screenHeight / 2 - bigGlowSize / 2)
                : (_step == 3 ? -cornerGlowSize * 0.4 : -cornerGlowSize),
            left: _step >= 4
                ? (screenWidth / 2 - bigGlowSize / 2)
                : (_step == 3 ? -cornerGlowSize * 0.4 : -cornerGlowSize),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: (_step == 3 || _step == 4) ? 1.0 : 0.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeInOut,
                width: _step >= 4 ? bigGlowSize : cornerGlowSize,
                height: _step >= 4 ? bigGlowSize : cornerGlowSize,
                child: _buildGlowLight(
                  _step >= 4 ? bigGlowSize : cornerGlowSize,
                ),
              ),
            ),
          ),

          // ── TRAIL ASAP PESAWAT (step 6) ──
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            top: planeTop + planeSize / 2 - 8,
            left: _step >= 6 ? -10 : -250,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 1000),
              opacity: _step >= 6 ? 1.0 : 0.0,
              child: Container(
                width: 90,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.lightBlueAccent.withOpacity(0.0),
                      Colors.lightBlueAccent.withOpacity(0.5),
                      Colors.white.withOpacity(0.8),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // ── ANIMASI PESAWAT ──
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

          // ── ANIMASI LOGO ──
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

          // ── LOGIN SCREEN ──
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutQuart,
            top: _step == 7 ? 0 : screenHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: LoginScreen(screenHeight: screenHeight),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowLight(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFF4DA8FF).withOpacity(0.85),
            const Color(0xFF4DA8FF).withOpacity(0.0),
          ],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}
