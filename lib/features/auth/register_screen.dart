import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';
import 'package:yalla/core/widgets/inputan/custom_text_field.dart';
import 'package:yalla/features/auth/providers/auth_provider.dart';

enum RegistrationType { none, jamaah, travel }

class RegisterScreen extends StatefulWidget {
  final double screenHeight;

  const RegisterScreen({super.key, required this.screenHeight});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegistrationType _selectedRegType = RegistrationType.none;

  // Controllers Jamaah
  final TextEditingController firstNameC = TextEditingController();
  final TextEditingController middleNameC = TextEditingController();
  final TextEditingController lastNameC = TextEditingController();
  final TextEditingController dobC = TextEditingController();
  final TextEditingController countryC = TextEditingController();

  // Controllers Travel
  final TextEditingController companyNameC = TextEditingController();
  final TextEditingController npwpC = TextEditingController();
  final TextEditingController travelLicenseC = TextEditingController();

  // Controllers Bersama
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
    companyNameC.dispose();
    npwpC.dispose();
    travelLicenseC.dispose();
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
      String day = picked.day.toString().padLeft(2, '0');
      String month = picked.month.toString().padLeft(2, '0');
      dobC.text = "$day/$month/${picked.year}";
    }
  }

  String _formatDateForApi(String date) {
    if (date.isEmpty) return "";
    try {
      final parts = date.split('/');
      if (parts.length == 3) {
        return "${parts[2]}-${parts[1]}-${parts[0]}";
      }
    } catch (e) {
      return date;
    }
    return date;
  }

  Future<void> _handleRegister() async {
    if (emailC.text.isEmpty || passwordC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan kata sandi tidak boleh kosong!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (passwordC.text != confirmPasswordC.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Kata sandi dan Masukkan Ulang Kata Sandi tidak cocok!',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Map<String, dynamic> payload = {};

    if (_selectedRegType == RegistrationType.jamaah) {
      payload = {
        "firstName": firstNameC.text.trim(),
        "middleName": middleNameC.text.trim(),
        "lastName": lastNameC.text.trim(),
        "birth": _formatDateForApi(dobC.text),
        "nationality": countryC.text.trim(),
        "email": emailC.text.trim(),
        "password": passwordC.text,
        "role": "jamaah", 
        "passportNumber": "",
        "passportIssueDate": "2026-01-01",
        "passportExpiryDate": "2026-01-01",
        "passportIssueCountry": "",
        "gender": "male",
      };
    } else {
      payload = {
        "firstName": companyNameC.text.trim(),
        "email": emailC.text.trim(),
        "password": passwordC.text,
        "role": "travel", // Ini sudah benar sesuai enum swagger
        "npwp": npwpC.text.trim(),
        "travelLicense": travelLicenseC.text.trim(),
      };
    }

    FocusScope.of(context).unfocus();

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(payload);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran Berhasil! Silakan Masuk.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
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
    // Pantau status loading dari provider
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
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: AppColors.secondary,
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextButton(
                                onPressed: () {
                                  if (_selectedRegType !=
                                      RegistrationType.none) {
                                    setState(() {
                                      _selectedRegType = RegistrationType.none;
                                    });
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  _selectedRegType == RegistrationType.none
                                      ? "Masuk"
                                      : "Kembali",
                                  style: AppTypography.bold14.copyWith(
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (_selectedRegType == RegistrationType.none)
                              Text(
                                "Sudah punya akun?",
                                style: AppTypography.regular12.copyWith(
                                  color: AppColors.secondary,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 19),

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
                      const SizedBox(height: 30),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _buildDynamicForm(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3), // Latar belakang redup
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF0084FF)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDynamicForm() {
    if (_selectedRegType == RegistrationType.none) {
      return _buildSelectionView();
    } else if (_selectedRegType == RegistrationType.jamaah) {
      return _buildJamaahForm();
    } else {
      return _buildTravelForm();
    }
  }

  Widget _buildSelectionView() {
    return Container(
      key: const ValueKey("SelectionView"),
      height: 250,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Daftar Sebagai:",
            style: AppTypography.bold14.copyWith(color: AppColors.secondary),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildRoleButton("Jamaah", RegistrationType.jamaah),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildRoleButton("Travel", RegistrationType.travel),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleButton(String title, RegistrationType type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRegType = type;
        });
      },
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFD4EEFF), Color(0xFFFFFFFF)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(0, 4),
              blurRadius: 4,
              spreadRadius: -2,
            ),
          ],
        ),
        child: Text(
          title,
          style: AppTypography.bold14.copyWith(color: AppColors.textDark),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return ElevatedButton(
      onPressed: isLoading ? null : _handleRegister,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(50)),
        ),
      ),
      child: const Text(
        "Daftar",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // --- FORM JAMAAH ---
  Widget _buildJamaahForm() {
    return Column(
      key: const ValueKey("JamaahForm"),
      children: [
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
        const SizedBox(height: 6),
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
        const SizedBox(height: 6),
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
        const SizedBox(height: 6),
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
                  hint: "Masukkan Ulang",
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
        Row(
          children: [
            const Expanded(flex: 3, child: SizedBox()),
            Expanded(
              flex: 7,
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF0099FF), Color(0xFF005C99)],
                  ),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(50),
                  ),
                  boxShadow: AppColors.defaultShadow,
                ),
                child: _buildSubmitButton(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 29),
      ],
    );
  }

  // --- FORM TRAVEL ---
  Widget _buildTravelForm() {
    return Column(
      key: const ValueKey("TravelForm"),
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 30),
          child: CustomTextField(
            hint: "Nama Perusahaan",
            controller: companyNameC,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(50),
            ),
          ),
        ),
        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.only(right: 30),
          child: CustomTextField(
            hint: "Email Perusahaan",
            controller: emailC,
            keyboardType: TextInputType.emailAddress,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(50),
            ),
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CustomTextField(
                  hint: "NPWP/NIB",
                  controller: npwpC,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(50),
                  ),
                ),
              ),
            ),
            const Expanded(flex: 4, child: SizedBox()),
          ],
        ),
        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.only(right: 30),
          child: CustomTextField(
            hint: "Nomor Izin Travel",
            controller: travelLicenseC,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(50),
            ),
          ),
        ),
        const SizedBox(height: 16),

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
        const SizedBox(height: 32),

        Row(
          children: [
            const Expanded(flex: 3, child: SizedBox()),
            Expanded(
              flex: 7,
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF0099FF), Color(0xFF005C99)],
                  ),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(50),
                  ),
                  boxShadow: AppColors.defaultShadow,
                ),
                child: _buildSubmitButton(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
