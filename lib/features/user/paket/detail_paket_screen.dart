import 'package:flutter/material.dart';
import 'package:yalla/core/widgets/paket/facility_item.dart';

class DetailPaketScreen extends StatelessWidget {
  const DetailPaketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ==========================================
      // TOMBOL BAWAH (Tetap Diam di Bawah)
      // ==========================================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0084FF),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Lanjutkan Pemesanan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),

      // ==========================================
      // KONTEN UTAMA (Sliver Scroll)
      // ==========================================
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // --- 1. HEADER GAMBAR YANG TETAP (STICKY) ---
          SliverAppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            expandedHeight: 320.0, // Tinggi maksimal gambar
            pinned: true, // Membuat app bar tetap terlihat saat discroll penuh
            floating: true, // AppBar muncul saat discroll sedikit ke bawah
            elevation: 0,
            scrolledUnderElevation: 0,

            // Tombol Back Custom
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors
                      .white, // Latar belakang putih agar terlihat di atas gambar
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

            // Judul kecil saat gambar sudah tertutup
            title: const Text(
              "Paket Umrah Spesial",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            // Isi Gambar & Teks Gradien
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gambar Background
                  Image.asset('assets/images/kaabah.jpeg', fit: BoxFit.cover),

                  // Gradien Hitam
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),

                  // Teks Header (Badge, Judul, Subjudul)
                  Positioned(
                    bottom: 24,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0099FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Terbatas",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                            children: [
                              TextSpan(
                                text: "VVIP Umrah Sebulan Penuh\n- ",
                                style: TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: "Spesial Ramadhan",
                                style: TextStyle(color: Color(0xFFFF9800)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "30 Hari - Ramadhan 1447 H",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- 2. KONTEN YANG BISA DI-SCROLL ---
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white, // Menutupi sisa ruang di bawah
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SECTION HARGA ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Harga Mulai dari",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "IDR 11.200.000",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.redAccent,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(height: 2),
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "IDR 8.599.000",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " /pax",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 6,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F8FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                right: -15,
                                bottom: -15,
                                child: Icon(
                                  Icons.info_outline,
                                  size: 60,
                                  color: const Color(
                                    0xFF0099FF,
                                  ).withOpacity(0.1),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Opsi Cicilan Ringan",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Mulai IDR 4.500.000",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "/bulan",
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // --- SECTION FASILITAS ---
                  const Text(
                    "Fasilitas Termasuk",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 2.8,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: const [
                      FacilityItem(
                        icon: Icons.flight_takeoff,
                        title: "Tiket Pulang -\nPergi",
                      ),
                      FacilityItem(
                        icon: Icons.business,
                        title: "Hotel Bintang 5",
                      ),
                      FacilityItem(
                        icon: Icons.article_outlined,
                        title: "Visa Umrah",
                      ),
                      FacilityItem(icon: Icons.restaurant, title: "Sarapan"),
                      FacilityItem(
                        icon: Icons.headset_mic_outlined,
                        title: "Mutawwif",
                      ),
                      FacilityItem(
                        icon: Icons.health_and_safety_outlined,
                        title: "Asuransi",
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // --- SECTION RENCANA PERJALANAN (TIMELINE) ---
                  const Text(
                    "Rencana Perjalanan Utama",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Item Timeline 1
                  _buildTimelineItem(
                    title: "Hari 1-3: Madinah Al Munawwarah",
                    desc:
                        "Kedatangan, Check-in Hotel, Ziarah Raudhah & Makam Rasulullah SAW.",
                    isLast: false,
                  ),

                  // Item Timeline 2
                  _buildTimelineItem(
                    title: "Hari 4-25: Makkah Al Mukarramah",
                    desc:
                        "Ibadah Umrah, Itikaf Ramadhan, & Tarawih berjamaah di Masjidil Haram.",
                    isLast: false,
                  ),

                  // Item Timeline 3
                  _buildTimelineItem(
                    title: "Hari 26-30: Idul Fitri & Kepulangan",
                    desc:
                        "Shalat Idul Fitri di Masjidil Haram dan persiapan kembali ke Tanah air.",
                    isLast: true,
                  ),

                  const SizedBox(
                    height: 40,
                  ), // Jarak ekstra di bagian paling bawah
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // WIDGET HELPER: TIMELINE ITEM (RENCANA PERJALANAN)
  // =========================================================
  Widget _buildTimelineItem({
    required String title,
    required String desc,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kolom Kiri: Titik Biru & Garis Abu-abu
          Column(
            children: [
              // Titik Biru
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Color(0xFF0099FF),
                  shape: BoxShape.circle,
                ),
              ),
              // Garis vertikal (hilang jika ini item terakhir)
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey.shade300,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 16), // Jarak titik ke teks
          // Kolom Kanan: Teks
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24), // Jarak antar item
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
