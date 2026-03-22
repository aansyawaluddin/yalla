import 'package:flutter/material.dart';
import 'package:yalla/core/widgets/button/primary_gradient_button.dart';
import 'package:yalla/features/user/plane/flight/payment_method_screen.dart';

class DetailPassengerScreen extends StatelessWidget {
  const DetailPassengerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 24,
                right: 24,
                bottom: 8,
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                  const SizedBox(width: 16),
                  const Text(
                    "Rincian Penumpang",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- FLIGHT DETAIL CARD ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/logo_flydeal.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Flydeal Air",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.work_outline,
                                          size: 12,
                                          color: Colors.black54,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "25 Kg",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Icon(
                                          Icons.restaurant_menu,
                                          size: 12,
                                          color: Colors.black54,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF0084FF,
                                  ).withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFF004AAB),
                                    width: 1.5,
                                  ),
                                ),
                                child: const Text(
                                  "Ekonomi",
                                  style: TextStyle(
                                    color: Color(0xFF004AAB),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: const [
                                  Text(
                                    "UPG",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Makassar",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 2,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.transparent,
                                                const Color(
                                                  0xFF0084FF,
                                                ).withOpacity(0.5),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        child: Transform.rotate(
                                          angle: 1.5708,
                                          child: const Icon(
                                            Icons.flight,
                                            color: Color(0xFF0084FF),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 2,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                const Color(
                                                  0xFF0084FF,
                                                ).withOpacity(0.5),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                children: const [
                                  Text(
                                    "JED",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Jeddah",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 1,
                            color: const Color(0xFF0084FF).withOpacity(0.8),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16,
                                    color: Color(0xFF0084FF),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "06 Juni 2026",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Color(0xFF0084FF),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "08 : 30 WITA",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      "Data Diri",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildCustomTextField(
                      "Nama Lengkap",
                      isRequired: true,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 16),
                    _buildCustomTextField(
                      "Email",
                      isRequired: true,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildCustomTextField(
                      "Nomor Telepon",
                      isRequired: true,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    _buildCustomTextField(
                      "Tanggal Lahir",
                      isRequired: true,
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(child: _buildTitleOption("Tuan")),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTitleOption("Nyonya")),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTitleOption("Nona")),
                      ],
                    ),
                    const SizedBox(height: 32),

                    const Text(
                      "Informasi Paspor",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildCustomTextField(
                      "Nomor Paspor",
                      isRequired: true,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    _buildCustomTextField(
                      "Nama Lengkap (Sesuai Paspor)",
                      isRequired: true,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 16),
                    _buildCustomTextField(
                      "Tanggal Penerbitan Paspor",
                      isRequired: true,
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 16),
                    _buildCustomTextField(
                      "Tanggal Kadaluarsa Paspor",
                      isRequired: true,
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 16),
                    // Pilihan Negara
                    _buildCountrySelector(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Total Harga",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  "1 Penumpang",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              "IDR 11.000.000",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            PrimaryGradientButton(
              text: "Lanjut ke Metode Pembayaran",
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const PaymentMethodScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeOut; 

                          var tween = Tween(
                            begin: begin,
                            end: end,
                          ).chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTextField(
    String hint, {
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: TextField(
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            border: InputBorder.none,
            label: RichText(
              text: TextSpan(
                text: hint,
                style: const TextStyle(color: Colors.black45, fontSize: 14),
                children: [
                  if (isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleOption(String title) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF33A1FF), width: 1),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF33A1FF),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCountrySelector() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
              // Jika Anda sudah punya gambar bendera di assets, gunakan ini:
              // image: const DecorationImage(
              //   image: AssetImage('assets/images/flag_id.png'),
              //   fit: BoxFit.cover,
              // ),
            ),
            child: const Icon(Icons.flag, size: 16, color: Colors.red),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Indonesia",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
        ],
      ),
    );
  }
}
