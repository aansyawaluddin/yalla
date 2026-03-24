import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';
import 'package:yalla/core/widgets/inputan/custom_text_field.dart';
import 'package:yalla/features/auth/register_screen.dart';
import 'package:yalla/features/travel/home_plane_travel_screen.dart';
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

  final List<Map<String, String>> _dummyAccounts = [
    {'email': 'user@gmail.com', 'password': '123', 'role': 'user'},
    {'email': 'travel@gmail.com', 'password': '123', 'role': 'travel'},
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan Password tidak boleh kosong!')),
      );
      return;
    }

    var matchedAccount = _dummyAccounts
        .where(
          (account) =>
              account['email'] == email && account['password'] == password,
        )
        .toList();

    if (matchedAccount.isNotEmpty) {
      String role = matchedAccount.first['role']!;
      Widget targetScreen;

      if (role == 'travel') {
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
        const SnackBar(
          content: Text('Email atau Password salah!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
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
                              onPressed: _handleLogin,
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

                    // Divider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(color: AppColors.line, thickness: 1),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Atau masuk menggunakan",
                              style: AppTypography.regular12.copyWith(
                                color: AppColors.textGrey,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: AppColors.line, thickness: 1),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Social
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(50),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const FaIcon(
                                FontAwesomeIcons.google,
                                color: Color(0xFFEA4335),
                                size: 20,
                              ),
                              label: const Text(
                                "Google",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: BorderSide(
                                  color: AppColors.line,
                                  width: 1.0,
                                ),
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(50),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Container(
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
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const FaIcon(
                                FontAwesomeIcons.facebook,
                                color: Color(0xFF1877F2),
                                size: 20,
                              ),
                              label: const Text(
                                "Facebook",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: BorderSide(
                                  color: AppColors.line,
                                  width: 1.0,
                                ),
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(50),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
