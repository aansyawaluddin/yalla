import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/providers/auth_provider.dart';
import 'package:yalla/core/providers/travel_provider.dart';
import 'package:yalla/core/providers/user_profile_provider.dart';
import 'package:yalla/core/widgets/snackbar/custom_snackbar.dart';

class EditTravelProfileScreen extends StatefulWidget {
  const EditTravelProfileScreen({super.key});

  @override
  State<EditTravelProfileScreen> createState() =>
      _EditTravelProfileScreenState();
}

class _EditTravelProfileScreenState extends State<EditTravelProfileScreen> {
  late TextEditingController nameC;
  late TextEditingController licenseC;
  late TextEditingController yearC;
  late TextEditingController bioC;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    final travelProvider = context.read<TravelProvider>();
    final detail = travelProvider.travelDetail;

    nameC = TextEditingController(
      text: authProvider.userData?.profile?.firstName ?? "",
    );
    licenseC = TextEditingController(text: detail?.licenseNumber ?? "");
    yearC = TextEditingController(text: detail?.operatingSince ?? "");
    bioC = TextEditingController(text: detail?.aboutText ?? "");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProfileProvider>().fetchProfile();
    });
  }

  @override
  void dispose() {
    nameC.dispose();
    licenseC.dispose();
    yearC.dispose();
    bioC.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime(2000);
    if (yearC.text.isNotEmpty) {
      try {
        initialDate = DateTime.parse(yearC.text);
      } catch (e) {
        initialDate = DateTime(2000);
      }
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
      String day = picked.day.toString().padLeft(2, '0');
      String month = picked.month.toString().padLeft(2, '0');
      setState(() {
        yearC.text = "${picked.year}-$month-$day";
      });
    }
  }

  Future<void> _pickAndUpload() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF004CB9)),
              title: const Text("Ambil Foto"),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Color(0xFF004CB9),
              ),
              title: const Text("Pilih dari Galeri"),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picked = await ImagePicker().pickImage(source: source);
    if (picked == null) return;

    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      maxWidth: 512,
      maxHeight: 512,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Sesuaikan Foto',
          toolbarColor: const Color(0xFF004CB9),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          hideBottomControls: true,
        ),
        IOSUiSettings(
          title: 'Sesuaikan Foto',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
          aspectRatioPickerButtonHidden: true,
        ),
      ],
    );

    if (cropped == null) return;
    if (!mounted) return;

    final provider = context.read<UserProfileProvider>();
    final success = await provider.uploadAvatar(File(cropped.path));
    if (!mounted) return;

    if (success) {
      CustomSnackBar.showSuccess(
        context,
        title: "Berhasil",
        message: "Foto profil berhasil diperbarui.",
      );
    } else {
      CustomSnackBar.showError(
        context,
        title: "Gagal",
        message: provider.errorMessage,
      );
    }
  }

  Future<void> _handleSimpan() async {
    final authProvider = context.read<AuthProvider>();
    final travelProvider = context.read<TravelProvider>();
    final userId = authProvider.userData?.userID;

    if (userId == null) return;

    Map<String, dynamic> body = {
      "license_number": licenseC.text.trim(),
      "operating_since": yearC.text.trim(),
      "about_text": bioC.text.trim(),
    };

    final success = await travelProvider.updateTravelDetail(userId, body);

    if (!mounted) return;

    if (success) {
      CustomSnackBar.showSuccess(
        context,
        title: "Profil Diperbarui",
        message: "Data profil travel Anda telah berhasil disimpan ke sistem.",
      );
      Navigator.pop(context);
    } else {
      CustomSnackBar.showError(
        context,
        title: "Gagal Menyimpan",
        message: travelProvider.errorMessage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<TravelProvider>().isDetailLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leadingWidth: 62,
        leading: _buildBackButton(),
        title: const Text(
          "Profil Travel",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto profil
            Center(
              child: Consumer<UserProfileProvider>(
                builder: (context, profileProvider, _) {
                  final avatarUrl = profileProvider.avatarUrl;
                  final isUploading = profileProvider.isUploadingAvatar;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF004CB9),
                            width: 2,
                          ),
                          image: DecorationImage(
                            image: (avatarUrl != null && avatarUrl.isNotEmpty)
                                ? NetworkImage(avatarUrl) as ImageProvider
                                : const AssetImage('assets/images/profile.png'),
                            fit: BoxFit.cover,
                            onError: (_, __) {},
                          ),
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: GestureDetector(
                          onTap: isUploading ? null : _pickAndUpload,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: const Color(0xFF004CB9),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                            child: isUploading
                                ? const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(
                                    Icons.camera_alt,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 28),

            _buildSectionTitle("Informasi Umum"),
            const SizedBox(height: 16),
            _buildInputField(
              label: "Nama Agensi",
              controller: nameC,
              isEnabled: false,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              label: "Nomor Lisensi",
              controller: licenseC,
              hint: "Contoh: PPIU-12345/2020",
            ),
            const SizedBox(height: 16),
            _buildInputField(
              label: "Tahun Beroperasi",
              controller: yearC,
              hint: "Pilih tanggal beroperasi",
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle("Tentang Travel"),
            const SizedBox(height: 16),
            _buildInputField(
              label: "Bio & Misi",
              controller: bioC,
              isMultiline: true,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(isLoading),
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, top: 8, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF0084FF),
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildBottomBar(bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildWarningText(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleSimpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0084FF),
                  disabledBackgroundColor: Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Simpan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningText() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(fontSize: 11, color: Color(0xFF0099FF), height: 1.4),
        children: [
          TextSpan(
            text: "Penting: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
                "Pastikan seluruh data yang diisi sudah benar dan sesuai dengan dokumen resmi sebelum melanjutkan ke tahap berikutnya.",
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF004CB9),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool isMultiline = false,
    bool isEnabled = true,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: isEnabled,
          readOnly: onTap != null,
          onTap: onTap,
          maxLines: isMultiline ? 5 : 1,
          style: TextStyle(
            fontSize: 14,
            color: isEnabled ? Colors.black87 : Colors.grey,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: !isEnabled,
            fillColor: isEnabled ? Colors.transparent : Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF0084FF),
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
      ],
    );
  }
}
