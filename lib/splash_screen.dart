import 'package:flutter/material.dart';
import 'dart:async';

import 'package:yalla/features/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
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
    // Tahan logo dalam posisi kecil selama 1 detik
    await Future.delayed(const Duration(seconds: 1));

    // Step 2: Logo membesar
    if (mounted) setState(() => _step = 2);
    await Future.delayed(const Duration(milliseconds: 800));

    // Step 3: Dua cahaya muncul di pojok
    if (mounted) setState(() => _step = 3);
    await Future.delayed(const Duration(milliseconds: 800));

    // Step 4: Cahaya bergerak ke tengah dan menyatu
    if (mounted) setState(() => _step = 4);
    await Future.delayed(const Duration(milliseconds: 800));

    // Step 5: Cahaya hilang (fade out)
    if (mounted) setState(() => _step = 5);
    await Future.delayed(const Duration(milliseconds: 600));

    // Step 6: Logo dan pesawat bergerak ke posisi akhir
    if (mounted) setState(() => _step = 6);
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) setState(() => _step = 7);
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
    final double targetRightMargin = 0.0;
    final double targetLeftForRightPos =
        screenWidth - logoContainerSize - targetRightMargin;

    const double lightSize = 300.0;
    final centerLightTop = screenHeight / 2 - (lightSize / 2);
    final centerLightX = screenWidth / 2 - (lightSize / 2);

    return Scaffold(
      backgroundColor: const Color(0xFF004CB9),
      body: Stack(
        children: [
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
                    : (_step == 6 ? (finalLogoSize / logoContainerSize) : 1.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

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

          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutQuart,
            top: _step == 7 ? 200 : screenHeight,
            left: 0,
            right: 0,
            height: screenHeight - 200,
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
