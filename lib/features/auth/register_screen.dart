import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';
import 'package:yalla/core/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  final double screenHeight;

  const RegisterScreen({super.key, required this.screenHeight});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController firstNameC = TextEditingController();
  final TextEditingController middleNameC = TextEditingController();
  final TextEditingController lastNameC = TextEditingController();
  final TextEditingController dobC = TextEditingController();
  final TextEditingController countryC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController confirmPasswordC = TextEditingController();

  @override
  void dispose() {
    firstNameC.dispose();
    middleNameC.dispose();
    lastNameC.dispose();
    dobC.dispose();
    countryC.dispose();
    emailC.dispose();
    passwordC.dispose();
    confirmPasswordC.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dobC.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: widget.screenHeight - 200,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(top: 41, bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 10,
                              ),
                              side: BorderSide(
                                color: AppColors.secondary,
                                width: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              "Masuk",
                              style: AppTypography.bold14.copyWith(
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Sudah punya akun?",
                            style: AppTypography.regular12.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Selamat Datang",
                            style: AppTypography.bold18.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Siap Untuk Memulai\nPerjalanan Anda?",
                            style: AppTypography.bold26.copyWith(
                              color: AppColors.textDark,
                              height: 1.25,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Daftar dengan email dan buat kata sandi\nuntuk melanjutkan",
                            style: AppTypography.regular12.copyWith(
                              color: AppColors.textGrey,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Baris 1: Nama Awal | Nama Tengah | Nama Akhir
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: CustomTextField(
                              hint: "Nama Awal",
                              controller: firstNameC,
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(50),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: CustomTextField(
                              hint: "Nama Tengah",
                              controller: middleNameC,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: CustomTextField(
                              hint: "Nama Akhir",
                              controller: lastNameC,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(50),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Baris 2: Tanggal Lahir | Negara Asal
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () => _selectDate(context),
                              child: AbsorbPointer(
                                child: CustomTextField(
                                  hint: "Tanggal Lahir",
                                  controller: dobC,
                                  borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(50),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: CustomTextField(
                              hint: "Negara Asal",
                              controller: countryC,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(50),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Baris 3: Email
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: CustomTextField(
                        hint: "Email",
                        controller: emailC,
                        keyboardType: TextInputType.emailAddress,
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(50),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Baris 4: Kata Sandi | Ulangi Kata Sandi
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: CustomTextField(
                              hint: "Kata Sandi",
                              isPassword: true,
                              controller: passwordC,
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(50),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: CustomTextField(
                              hint: "Masukkan Ulang Kata Sandi",
                              isPassword: true,
                              controller: confirmPasswordC,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(50),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Tombol Daftar (Biru Gradien, Nempel Kanan)
                    Row(
                      children: [
                        const Expanded(flex: 3, child: SizedBox()),
                        Expanded(
                          flex: 7,
                          child: Container(
                            height: 54,
                            decoration: BoxDecoration(
                              gradient: AppColors.buttonGradient,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(50),
                              ),
                              boxShadow: AppColors.defaultShadow,
                            ),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(50),
                                  ),
                                ),
                              ),
                              child: const Text(
                                "Daftar",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
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
                              "Atau daftar menggunakan",
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

                    // Tombol Social Media
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
                                  offset: Offset(0, 4),
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
                                  offset: Offset(0, 4),
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
