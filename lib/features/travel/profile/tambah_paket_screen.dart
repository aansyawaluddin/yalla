import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/providers/package_provider.dart';
import 'package:yalla/core/widgets/snackbar/custom_snackbar.dart';

class TambahPaketScreen extends StatefulWidget {
  const TambahPaketScreen({super.key});

  @override
  State<TambahPaketScreen> createState() => _TambahPaketScreenState();
}

class _TambahPaketScreenState extends State<TambahPaketScreen> {
  final TextEditingController batchC = TextEditingController();
  final TextEditingController batchDateC = TextEditingController();
  final TextEditingController namaPaketC = TextEditingController();
  final TextEditingController hargaC = TextEditingController();
  final TextEditingController durasiC = TextEditingController();

  @override
  void dispose() {
    batchC.dispose();
    batchDateC.dispose();
    namaPaketC.dispose();
    hargaC.dispose();
    durasiC.dispose();
    super.dispose();
  }

  Future<void> _selectBatchDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
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
        batchDateC.text = "${picked.year}-$month-$day";
      });
    }
  }

  Future<void> _handleTambahPaket() async {
    // 1. Validasi Inputan
    if (batchC.text.isEmpty ||
        batchDateC.text.isEmpty ||
        namaPaketC.text.isEmpty ||
        hargaC.text.isEmpty ||
        durasiC.text.isEmpty) {
      CustomSnackBar.showError(
        context,
        title: "Data Belum Lengkap",
        message: "Mohon lengkapi seluruh detail paket terlebih dahulu.",
      );
      return;
    }

    Map<String, dynamic> payload = {
      "batch_date": batchDateC.text.trim(),
      "package_name": namaPaketC.text.trim(),
      "duration_days": int.tryParse(durasiC.text.trim()) ?? 0,
      "batch_name": batchC.text.trim(),
      "price": int.tryParse(hargaC.text.trim()) ?? 0,
    };

    FocusScope.of(context).unfocus();

    final packageProvider = context.read<PackageProvider>();
    final success = await packageProvider.createPackage(payload);

    if (!mounted) return;

    if (success) {
      CustomSnackBar.showSuccess(
        context,
        title: "Paket Ditambahkan",
        message: "Paket umrah baru berhasil disimpan dan sudah aktif.",
      );
      Navigator.pop(context);
    } else {
      CustomSnackBar.showError(
        context,
        title: "Gagal Menambahkan",
        message: packageProvider.errorMessage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<PackageProvider>().isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 62,
        leading: Padding(
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
        ),
        title: const Text(
          "Tambah Paket",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Detail Paket"),
            const SizedBox(height: 16),

            _buildInputField(
              label: "Nama Batch",
              controller: batchC,
              hint: "e.g Gelombang 1 - Agustus",
            ),
            const SizedBox(height: 16),

            _buildInputField(
              label: "Nama Paket",
              controller: namaPaketC,
              hint: "e.g Umrah Hemat Bintang 3",
            ),
            const SizedBox(height: 16),

            _buildInputField(
              label: "Tanggal Keberangkatan",
              controller: batchDateC,
              hint: "Pilih tanggal keberangkatan",
              onTap: () => _selectBatchDate(context),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: _buildInputField(
                    label: "Harga",
                    controller: hargaC,
                    hint: "25500000",
                    prefixText: "IDR  ",
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 4,
                  child: _buildInputField(
                    label: "Durasi (Hari)",
                    controller: durasiC,
                    hint: "9",
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(isLoading),
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
    String? prefixText,
    TextInputType keyboardType = TextInputType.text,
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
          keyboardType: keyboardType,
          readOnly: onTap != null,
          onTap: onTap,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.normal,
            ),
            prefixText: prefixText,
            prefixStyle: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
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
          ),
        ),
      ],
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF0099FF),
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(
                          text: "Penting: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              "Pastikan seluruh data yang diisi sudah benar sebelum paket diterbitkan ke jamaah.",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleTambahPaket,
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
                        "Tambah Paket",
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
}
