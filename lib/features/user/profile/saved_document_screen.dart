import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/providers/user_profile_provider.dart';
import 'package:yalla/core/widgets/card/profile_card.dart';
import 'package:yalla/core/widgets/snackbar/custom_snackbar.dart';

class SavedDocumentScreen extends StatefulWidget {
  const SavedDocumentScreen({super.key});

  @override
  State<SavedDocumentScreen> createState() => _SavedDocumentScreenState();
}

class _SavedDocumentScreenState extends State<SavedDocumentScreen> {
  late TextEditingController _emailController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _birthController;
  late TextEditingController _nationalityController;
  late TextEditingController _passportController;
  late TextEditingController _passportIssueDateController;
  late TextEditingController _passportExpiryController;

  bool _hasChanges = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _birthController = TextEditingController();
    _nationalityController = TextEditingController();
    _passportController = TextEditingController();
    _passportIssueDateController = TextEditingController();
    _passportExpiryController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<UserProfileProvider>().fetchProfile();
      _populateFields();
      _listenChanges();
    });
  }

  void _populateFields() {
    final profile = context.read<UserProfileProvider>().profile;
    _emailController.text = profile.email;
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _birthController.text = profile.birth;
    _nationalityController.text = profile.nationality;
  }

  void _listenChanges() {
    final controllers = [
      _emailController,
      _firstNameController,
      _lastNameController,
      _birthController,
      _nationalityController,
      _passportController,
      _passportIssueDateController,
      _passportExpiryController,
    ];
    for (final c in controllers) {
      c.addListener(() {
        if (!_hasChanges) setState(() => _hasChanges = true);
        if (!_isEditing) setState(() => _isEditing = true);
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthController.dispose();
    _nationalityController.dispose();
    _passportController.dispose();
    _passportIssueDateController.dispose();
    _passportExpiryController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Simpan Perubahan?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        content: const Text(
          "Anda memiliki perubahan yang belum disimpan. Simpan sebelum keluar?",
          style: TextStyle(fontSize: 13, color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Buang", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text("Batal", style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context, true);
              await _saveProfile();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF004CB9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (result == null) return false;
    if (result == false) return true;
    return true;
  }

  Future<void> _saveProfile() async {
    final provider = context.read<UserProfileProvider>();
    final success = await provider.updateProfile(
      email: _emailController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      nationality: _nationalityController.text.trim(),
      gender: provider.profile.gender,
    );

    if (!mounted) return;

    if (success) {
      setState(() {
        _hasChanges = false;
        _isEditing = false;
      });
      CustomSnackBar.showSuccess(
        context,
        title: "Berhasil",
        message: "Profil berhasil diperbarui.",
      );
    } else {
      CustomSnackBar.showError(
        context,
        title: "Gagal",
        message: provider.errorMessage,
      );
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime initialDate = DateTime(2000);
    if (controller.text.isNotEmpty) {
      try {
        final parts = controller.text.split('-');
        if (parts.length == 3) {
          initialDate = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        }
      } catch (_) {}
    }

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF004CB9),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF004CB9),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final String day = picked.day.toString().padLeft(2, '0');
      final String month = picked.month.toString().padLeft(2, '0');
      controller.text = "${picked.year}-$month-$day";

      setState(() {
        _hasChanges = true;
        _isEditing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProfileProvider>();
    final isLoading = provider.isLoading;
    final isSaving = provider.isSaving;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leadingWidth: 72,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF005C99),
                size: 20,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Dokumen Tersimpan",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
          actions: [
            if (_isEditing)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Color(0xFF004CB9),
                          strokeWidth: 2,
                        ),
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.check_circle,
                          color: Color(0xFF004CB9),
                          size: 26,
                        ),
                        onPressed: _saveProfile,
                        tooltip: "Simpan Perubahan",
                      ),
              ),
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF0084FF)),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileCard(onSave: _isEditing ? _saveProfile : null),

                    const SizedBox(height: 32),

                    const Text(
                      "Data Diri",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      "Email",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            "Nama Depan",
                            controller: _firstNameController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            "Nama Belakang",
                            controller: _lastNameController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildDateField(
                      "Tanggal Lahir",
                      controller: _birthController,
                      onTap: () {},
                      enabled: false,
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      "Kewarganegaraan",
                      controller: _nationalityController,
                    ),

                    const SizedBox(height: 32),

                    // const Text(
                    //   "Informasi Paspor",
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.black87,
                    //   ),
                    // ),
                    // const SizedBox(height: 16),

                    // _buildTextField(
                    //   "Nomor Paspor",
                    //   controller: _passportController,
                    // ),
                    // const SizedBox(height: 16),

                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: _buildDateField(
                    //         "Tanggal Terbit",
                    //         controller: _passportIssueDateController,
                    //         onTap: () => _selectDate(
                    //           context,
                    //           _passportIssueDateController,
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 16),
                    //     Expanded(
                    //       child: _buildDateField(
                    //         "Masa Berlaku",
                    //         controller: _passportExpiryController,
                    //         onTap: () =>
                    //             _selectDate(context, _passportExpiryController),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    // const SizedBox(height: 32),

                    // const Text(
                    //   "Masukkan Dokumen",
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.black87,
                    //   ),
                    // ),
                    // const SizedBox(height: 24),
                    // _buildUploadSection("Foto Paspor (Halaman Biodata)"),
                    // const SizedBox(height: 24),
                    // _buildUploadSection("Pas Foto Terbaru (4.5 x 3.5 Cm)"),
                    // const SizedBox(height: 24),
                    // _buildUploadSection("Bukti Pemesanan Hotel"),
                    // const SizedBox(height: 24),
                    // _buildUploadSection("Tiket Pesawat Pulang Pergi"),
                    // const SizedBox(height: 40),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTextField(
    String hintText, {
    TextEditingController? controller,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
            ),
          ),
          if (suffixIcon != null) suffixIcon,
        ],
      ),
    );
  }

  // Widget _buildUploadSection(String title) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       RichText(
  //         text: TextSpan(
  //           text: title,
  //           style: const TextStyle(
  //             fontSize: 12,
  //             color: Colors.black54,
  //             fontWeight: FontWeight.w500,
  //           ),
  //           children: const [
  //             TextSpan(
  //               text: " *",
  //               style: TextStyle(color: Colors.red),
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 12),
  //       Row(
  //         children: [
  //           Expanded(
  //             child: _buildUploadBox(
  //               icon: Icons.camera_alt,
  //               label: "Ambil Foto",
  //               onTap: () {},
  //             ),
  //           ),
  //           const SizedBox(width: 16),
  //           Expanded(
  //             child: _buildUploadBox(
  //               icon: Icons.photo_library,
  //               label: "Galeri",
  //               onTap: () {},
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildUploadBox({
  //   required IconData icon,
  //   required String label,
  //   required VoidCallback onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: CustomPaint(
  //       painter: DashedRectPainter(
  //         color: Colors.grey.shade300,
  //         strokeWidth: 1,
  //         gap: 5.0,
  //       ),
  //       child: Container(
  //         height: 80,
  //         decoration: BoxDecoration(
  //           color: const Color(0xFFF4F9FF),
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(icon, color: const Color(0xFF0066CC), size: 24),
  //             const SizedBox(height: 8),
  //             Text(
  //               label,
  //               style: const TextStyle(
  //                 fontSize: 12,
  //                 color: Color(0xFF0066CC),
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDateField(
    String hintText, {
    required TextEditingController controller,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(
              child: IgnorePointer(
                child: TextFormField(
                  controller: controller,
                  style: TextStyle(
                    fontSize: 14,
                    color: enabled ? Colors.black87 : Colors.black54,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            IgnorePointer(
              child: Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: enabled ? const Color(0xFF004CB9) : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(8),
        ),
      );

    Path dashedPath = Path();
    double distance = 0.0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashedPath.addPath(
          pathMetric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2;
      }
      distance = 0.0;
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
