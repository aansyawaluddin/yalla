import 'package:flutter/material.dart';
import 'package:yalla/core/widgets/paket/large_paket_umrah.dart';
import 'package:yalla/core/widgets/paket/small_paket_umrah.dart';

class PaketUmrahScreen extends StatefulWidget {
  const PaketUmrahScreen({super.key});

  @override
  State<PaketUmrahScreen> createState() => _PaketUmrahScreenState();
}

class _PaketUmrahScreenState extends State<PaketUmrahScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ["Semua", "VVIP", "Ekonomi", "Eksklusif"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
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
          "Paket Umrah",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomTabBar(),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Penawaran Eksklusif",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Pilih paket terbaik untuk perjalanan Anda",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),

                  const LargePaketCard(
                    titleNormal: "VVIP Umrah Sebulan Penuh\n- ",
                    titleHighlight: "Spesial Ramadhan",
                    duration: "30 Hari - Ramadhan 1447 H",
                    price: "IDR 150 Jt",
                    imagePath: 'assets/images/kaabah.jpeg',
                    isPopular: true,
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: const [
                      Expanded(
                        child: SmallPaketCard(
                          title: "Umrah Eksekutif\nBersama Keluarga",
                          duration: "12 Hari • Hotel\nbintang 5",
                          price: "IDR 50 Jt",
                          imagePath: 'assets/images/kaabah.jpeg',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: SmallPaketCard(
                          title: "Umrah Ekonomi",
                          duration: "9 Hari • Hotel\nbintang 3",
                          price: "IDR 35 Jt",
                          imagePath: 'assets/images/kaabah.jpeg',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: const [
                      Expanded(
                        child: SmallPaketCard(
                          title: "Umrah Ekonomi",
                          duration: "9 Hari • Hotel\nbintang 3",
                          price: "IDR 35 Jt",
                          imagePath: 'assets/images/kaabah.jpeg',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: SmallPaketCard(
                          title: "Umrah Eksekutif\nBersama Keluarga",
                          duration: "12 Hari • Hotel\nbintang 5",
                          price: "IDR 50 Jt",
                          imagePath: 'assets/images/kaabah.jpeg',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const LargePaketCard(
                    titleNormal: "VVIP Umrah Sebulan Penuh\n- ",
                    titleHighlight: "Spesial Ramadhan",
                    duration: "30 Hari - Ramadhan 1447 H",
                    price: "IDR 150 Jt",
                    imagePath: 'assets/images/kaabah.jpeg',
                    isPopular: false,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_tabs.length, (index) {
          bool isActive = _selectedTabIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            child: Column(
              children: [
                Text(
                  _tabs[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive
                        ? const Color(0xFF007BFF)
                        : const Color(0xFF005C99), 
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 2,
                  width: isActive ? 40 : 0, 
                  color: const Color(0xFF007BFF),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}