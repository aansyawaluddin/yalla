import 'package:flutter/material.dart';

class TravelProfileScreen extends StatefulWidget {
  const TravelProfileScreen({super.key});

  @override
  State<TravelProfileScreen> createState() => _TravelProfileScreenState();
}

class _TravelProfileScreenState extends State<TravelProfileScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ["Tentang", "Paket", "Galeri", "Ulasan"];

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
          "Profil Travel",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF0084FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 180,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/kaabah.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.white],
                  stops: [0.6, 1.0],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage('assets/images/logo_flydeal.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text(
                            "CMA Tour & Travel",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.verified,
                            color: Color(0xFF0084FF),
                            size: 18,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Official Umrah provider",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Beroperasi sejak 2019",
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  _buildCustomTabBar(),

                  if (_selectedTabIndex == 0) _buildTentangTab(),
                  if (_selectedTabIndex == 1) _buildPaketTab(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Text(
                        _tabs[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isActive
                              ? const Color(0xFF005C99)
                              : Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 2,
                        width: 50,
                        color: isActive
                            ? const Color(0xFF005C99)
                            : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }

  Widget _buildTentangTab() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tentang CMA Tour & Travel",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Kami adalah penyelenggara perjalanan ibadah umrah yang berkomitmen memberikan pelayanan terbaik dengan prinsip amanah, profesional, dan transparan. Didukung oleh tim berpengalaman serta mitra resmi di Arab Saudi, kami memastikan setiap proses perjalanan — mulai dari pendaftaran, pengurusan dokumen, hingga kepulangan — berjalan lancar dan nyaman.\n\nKepercayaan jamaah adalah prioritas utama kami, sehingga kami terus menjaga kualitas layanan dan pendampingan ibadah agar setiap perjalanan menjadi pengalaman spiritual yang berkesan.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.5),
          ),

          const SizedBox(height: 32),

          _buildInfoCard(
            icon: Icons.security_outlined,
            title: "Penyedia Terpercaya",
            desc:
                "Berlisensi penuh dan terverifikasi oleh Kementerian\nAgama Republik Indonesia",
          ),
          _buildInfoCard(
            icon: Icons.diamond_outlined,
            title: "Kenyamanan Premium",
            desc: "Bermitra dengan Hotel bintang-5 terdekat",
          ),
          _buildInfoCard(
            icon: Icons.headset_mic_outlined,
            title: "Layanan 24/7",
            desc:
                "Mutawwif dan staf lapangan yang berdedikasi siap\nmembantu Anda sepanjang waktu.",
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFF0F8FF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF0084FF), size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaketTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        children: [
          _buildPaketCard(
            imageUrl: 'assets/images/kaabah.jpeg',
            title: "Umrah Premium Gold",
            subtitle: "9 Hari - Hotel bintang-5 di Mekkah - Sarapan",
            isBestSeller: true,
            features: ["Penerbangan Langsung", "Air Zamzam", "Gratis Visa"],
            originalPrice: "IDR 11.200.000",
            discountPrice: "IDR 8.599.000",
          ),
          const SizedBox(height: 24),
          _buildPaketCard(
            imageUrl: 'assets/images/kaabah.jpeg',
            title: "Umrah Reguler",
            subtitle: "12 Hari - Hotel bintang-4 - Full Board",
            isBestSeller: false,
            features: ["Penerbangan Transit", "Air Zamzam"],
            originalPrice: "IDR 25.000.000",
            discountPrice: "IDR 22.500.000",
          ),
        ],
      ),
    );
  }

  Widget _buildPaketCard({
    required String imageUrl,
    required String title,
    required String subtitle,
    required bool isBestSeller,
    required List<String> features,
    required String originalPrice,
    required String discountPrice,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (isBestSeller)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0099FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.verified, color: Colors.white, size: 10),
                            SizedBox(width: 4),
                            Text(
                              "Best Seller",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: features.map((feature) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F8FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0099FF),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Harga Coret
                        Text(
                          originalPrice,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red.shade400,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        // Harga Diskon + /pax
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              discountPrice,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.black87,
                              ),
                            ),
                            const Text(
                              "/pax",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () {
                          // Aksi lihat tawaran
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF0099FF,
                          ), // Biru tombol
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text(
                          "Lihat Tawaran",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
