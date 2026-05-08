import 'package:flutter/material.dart';
import 'package:yalla/core/widgets/snackbar/custom_snackbar.dart';

class TambahPaketScreen extends StatefulWidget {
  const TambahPaketScreen({super.key});

  @override
  State<TambahPaketScreen> createState() => _TambahPaketScreenState();
}

class _TambahPaketScreenState extends State<TambahPaketScreen> {
  // Controllers untuk text input
  final TextEditingController batchC = TextEditingController();
  final TextEditingController namaPaketC = TextEditingController();
  final TextEditingController hargaC = TextEditingController();
  final TextEditingController durasiC = TextEditingController();

  // Variabel untuk menyimpan nilai Dropdown
  String? selectedAirline;
  String? selectedMakkahHotel;
  String? selectedMadinahHotel;

  bool isLoading = false;

  @override
  void dispose() {
    batchC.dispose();
    namaPaketC.dispose();
    hargaC.dispose();
    durasiC.dispose();
    super.dispose();
  }

  Future<void> _handleTambahPaket() async {
    // Validasi sederhana
    if (batchC.text.isEmpty || namaPaketC.text.isEmpty || hargaC.text.isEmpty) {
      CustomSnackBar.showError(
        context,
        title: "Data Belum Lengkap",
        message: "Mohon lengkapi detail paket terlebih dahulu.",
      );
      return;
    }

    setState(() => isLoading = true);

    // TODO: Hubungkan dengan fungsi POST ke API lewat Provider nantinya
    await Future.delayed(const Duration(seconds: 2)); // Simulasi loading API

    if (!mounted) return;
    setState(() => isLoading = false);

    CustomSnackBar.showSuccess(
      context,
      title: "Paket Ditambahkan",
      message: "Paket umrah baru berhasil disimpan dan sudah aktif.",
    );

    Navigator.pop(context); // Kembali ke halaman daftar paket
  }

  @override
  Widget build(BuildContext context) {
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
            // --- SECTION 1: Detail Paket ---
            _buildSectionTitle("Detail Paket"),
            const SizedBox(height: 16),
            _buildInputField(
              label: "Batch",
              controller: batchC,
              hint: "Batch 4",
            ),
            const SizedBox(height: 16),
            _buildInputField(
              label: "Nama Paket",
              controller: namaPaketC,
              hint: "e.g VVIP Ramadhan 2024",
            ),
            const SizedBox(height: 16),

            // Row untuk Harga dan Durasi
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: "Harga",
                    controller: hargaC,
                    hint: "0",
                    prefixText: "IDR  ", // Prefix khusus harga
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    label: "Durasi (Hari)",
                    controller: durasiC,
                    hint: "12",
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // --- SECTION 2: Logistik dan Akomodasi ---
            _buildSectionTitle("Logistik dan Akomodasi"),
            const SizedBox(height: 16),

            // Dropdown Maskapai
            _buildDropdownField(
              label: "Detail Penerbangan (Airline)",
              hint: "Pilih Maskapai",
              value: selectedAirline,
              items: [
                "Flyadeal",
                "Garuda Indonesia",
                "Saudia Airlines",
                "Lion Air",
              ],
              onChanged: (val) => setState(() => selectedAirline = val),
              isAirline: true, // Berikan gaya khusus untuk maskapai
            ),
            const SizedBox(height: 16),

            // Dropdown Hotel Makkah
            _buildDropdownField(
              label: "Hotel di Makkah",
              hint: "Pilih Hotel",
              value: selectedMakkahHotel,
              items: [
                "Pullman Zamzam",
                "Swissotel Makkah",
                "Clock Royal Tower",
                "Anjum Hotel",
              ],
              onChanged: (val) => setState(() => selectedMakkahHotel = val),
            ),
            const SizedBox(height: 16),

            // Dropdown Hotel Madinah
            _buildDropdownField(
              label: "Hotel di Madinah",
              hint: "Pilih Hotel",
              value: selectedMadinahHotel,
              items: [
                "Anwar Al Madinah",
                "Pullman Zamzam Madinah",
                "Rove Madinah",
                "Frontel Al Harithia",
              ],
              onChanged: (val) => setState(() => selectedMadinahHotel = val),
            ),

            const SizedBox(
              height: 100,
            ), // Spasi agar tidak tertutup tombol bawah
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF004CB9), // Biru gelap
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hint,
    String? prefixText,
    TextInputType keyboardType = TextInputType.text,
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

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    bool isAirline = false,
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
        DropdownButtonFormField<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
          decoration: InputDecoration(
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
          hint: Text(
            hint,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: isAirline && item == "Flyadeal"
                  ? Row(
                      children: [
                        const Icon(
                          Icons.flight_takeoff,
                          color: Color(0xFF0084FF),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item,
                          style: const TextStyle(
                            color: Color(0xFF0084FF),
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
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
                              "Pastikan seluruh data yang diisi sudah benar dan sesuai dengan dokumen resmi sebelum melanjutkan ke tahap berikutnya.",
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
