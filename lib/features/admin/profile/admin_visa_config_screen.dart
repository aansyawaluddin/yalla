import 'package:flutter/material.dart';

class AdminVisaConfigScreen extends StatefulWidget {
  const AdminVisaConfigScreen({super.key});

  @override
  State<AdminVisaConfigScreen> createState() => _AdminVisaConfigScreenState();
}

class _AdminVisaConfigScreenState extends State<AdminVisaConfigScreen> {
  // State untuk form
  String _selectedCountry = "Indonesia";
  String _selectedVisaType = "Tourist";
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Data dummy untuk dropdown negara
  final List<String> _countries = [
    "Indonesia",
    "Malaysia",
    "Singapore",
    "Jepang",
    "Saudi Arabia",
  ];

  // State untuk daftar dokumen
  List<String> _requiredDocuments = ["Valid Passport (Minimal 6 bulan)"];

  @override
  void dispose() {
    _priceController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 8.0, bottom: 8.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF0084FF),
                size: 20,
              ),
            ),
          ),
        ),
        title: const Text(
          "Konfigurasi Visa",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFF0F0F0), height: 1.0),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCountryDropdown(),

                    const SizedBox(height: 24),

                    const Text(
                      "Tipe Visa",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildVisaTypeSelection(),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: const TextSpan(
                                  text: "Harga ",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "(IDR)",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildTextField(
                                controller: _priceController,
                                hintText: "",
                                prefixIcon: Icons.money,
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Jangka Waktu Proses",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildTextField(
                                controller: _durationController,
                                hintText: "",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "Deskripsi",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextArea(),

                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Dokumen yang diperlukan",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Row(
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                color: Color(0xFF0084FF),
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Tambah",
                                style: TextStyle(
                                  color: Color(0xFF0084FF),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(child: _buildDocumentList()),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 16.0,
                bottom: 24.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pesan Peringatan
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Color(0xFF0084FF),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            text: "Penting: ",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0084FF),
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "Periksa kembali data yang telah diubah sebelum menyimpan untuk menghindari kesalahan jadwal.",
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Tombol Simpan
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0084FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.save_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Simpan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCountry,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
          items: _countries.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  if (value == "Indonesia")
                    const Text("🇮🇩", style: TextStyle(fontSize: 18))
                  else
                    const Icon(Icons.flag, size: 18, color: Colors.grey),
                  const SizedBox(width: 12),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                _selectedCountry = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildVisaTypeSelection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildRadioOption("Tourist")),
            const SizedBox(width: 12),
            Expanded(child: _buildRadioOption("Business")),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildRadioOption("Student")),
            const SizedBox(width: 12),
            Expanded(child: _buildRadioOption("Medical")),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOption(String title) {
    bool isSelected = _selectedVisaType == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVisaType = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0084FF)
                      : Colors.grey.shade400,
                  width: isSelected ? 5 : 1,
                ),
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    IconData? prefixIcon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, size: 18, color: Colors.grey.shade400)
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: prefixIcon != null ? 14 : 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTextArea() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _descriptionController,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(fontSize: 14),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildDocumentList() {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: _requiredDocuments.length,
      itemBuilder: (context, idx) {
        String document = _requiredDocuments[idx];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.description_outlined,
                  color: Color(0xFF004CB9),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: document.split(' (')[0],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                      children: [
                        if (document.contains('('))
                          TextSpan(
                            text: " (${document.split(' (')[1]}",
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _requiredDocuments.removeAt(idx);
                    });
                  },
                  child: Icon(
                    Icons.cancel_outlined,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
