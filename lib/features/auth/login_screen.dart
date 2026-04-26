import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';
import 'package:yalla/core/widgets/inputan/custom_text_field.dart';
import 'package:yalla/features/admin/beranda/admin_dashboard_screen.dart';
import 'package:yalla/features/auth/providers/auth_provider.dart';
import 'package:yalla/features/auth/register_screen.dart';
import 'package:yalla/features/travel/home/home_plane_travel_screen.dart';
import 'package:yalla/features/user/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  final double screenHeight;

  const LoginScreen({super.key, required this.screenHeight});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan Password tidak boleh kosong!')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(email, password);

    if (!mounted) return;

    if (success) {
      final role = await authProvider.checkLoginStatus();

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
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeIn,
            );
            return FadeTransition(opacity: curvedAnimation, child: child);
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: widget.screenHeight - 170,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 41, bottom: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Belum punya akun?",
                                style: AppTypography.regular12.copyWith(
                                  color: AppColors.secondary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      transitionDuration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => RegisterScreen(
                                            screenHeight: widget.screenHeight,
                                          ),
                                      transitionsBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                            child,
                                          ) {
                                            final curved = CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeIn,
                                            );
                                            return FadeTransition(
                                              opacity: curved,
                                              child: child,
                                            );
                                          },
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white,
                                        Color(0x4D004CB9),
                                        Color(0xFF004CB9),
                                      ],
                                      stops: [0.1, 0.5, 1.0],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 28,
                                          vertical: 10,
                                        ),
                                        child: Text(
                                          "Daftar",
                                          style: AppTypography.bold14.copyWith(
                                            color: AppColors.secondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 47),

                        // Title
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Selamat Datang",
                                style: AppTypography.bold18.copyWith(
                                  color: AppColors.secondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Siap Untuk Perjalanan\nBerikutnya?",
                                style: AppTypography.bold26.copyWith(
                                  color: AppColors.textDark,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Masukkan email dan kata sandi Anda untuk\nmulai perjalanan",
                                style: AppTypography.regular12.copyWith(
                                  color: AppColors.textGrey,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Input Email
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: CustomTextField(
                            controller: _emailController,
                            icon: Icons.alternate_email,
                            hint: "Masukkan Email Anda",
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Input Password
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: _passwordController,
                                icon: Icons.key_outlined,
                                hint: "Masukkan kata sandi Anda",
                                isPassword: true,
                                obscurePassword: _obscurePassword,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              height: 54,
                              width: 65,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(50),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 4,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.secondary,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                height: 54,
                                decoration: BoxDecoration(
                                  gradient: AppColors.buttonGradient,
                                  borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(50),
                                  ),
                                  boxShadow: AppColors.defaultShadow,
                                ),
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.horizontal(
                                        right: Radius.circular(50),
                                      ),
                                    ),
                                  ),
                                  // ---> PERUBAHAN: Kembalikan Teks Masuk <---
                                  child: const Text(
                                    "Masuk",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 4,
                              child: Container(
                                height: 54,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(50),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(50),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Lupa Password?",
                                    style: AppTypography.regular12.copyWith(
                                      color: AppColors.secondary,
                                      decoration: TextDecoration.underline,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 36),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF0084FF)),
              ),
            ),
        ],
      ),
    );
  }
}
