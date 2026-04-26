import 'dart:ui';
import 'package:flutter/material.dart';
// Pastikan path import ini sesuai dengan lokasi file CustomBottomNavBar Anda
import 'package:yalla/core/widgets/button/custom_bottom_nav_bar.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data untuk list hotel
    final List<Map<String, dynamic>> favoriteHotels = [
      {
        "name": "Hotel Borobudur Jakarta",
        "price": "IDR 11.000.000",
        "rating": 4.6,
        "location": "Gelora, Jakarta Pusat",
        "image": 'assets/images/hotel.jpg',
      },
      {
        "name": "Hotel Borobudur Jakarta",
        "price": "IDR 11.000.000",
        "rating": 4.6,
        "location": "Gelora, Jakarta Pusat",
        "image": 'assets/images/hotel.jpg',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F6F8,
      ), // Menyesuaikan warna latar bawah dengan OrderScreen
      body: Stack(
        children: [
          // --- Background bg_home.png dari OrderScreen ---
          Positioned(
            top: -90.0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55 + 70,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_home.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.5),
                      const Color(0xFFF5F6F8),
                    ],
                    stops: const [0.4, 0.8, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // --- Konten Utama ---
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul Halaman
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Text(
                    "Favorit",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(
                        0xFF003875,
                      ), // Biru tua serasi dengan OrderScreen
                    ),
                  ),
                ),

                // List Favorite
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: favoriteHotels.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 24),
                    itemBuilder: (context, index) {
                      final hotel = favoriteHotels[index];
                      return _buildHotelCard(
                        name: hotel['name'],
                        price: hotel['price'],
                        rating: hotel['rating'],
                        location: hotel['location'],
                        imageUrl: hotel['image'],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Menambahkan Bottom Navigation Bar dengan index 1 (Favorite)
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildHotelCard({
    required String name,
    required String price,
    required double rating,
    required String location,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Bagian Gambar & Overlay ---
          Stack(
            children: [
              // 1. Gambar Hotel
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.asset(
                  imageUrl, // Pastikan asset ini tersedia
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // 2. Tombol Heart (Kanan Atas)
              Positioned(
                top: 0,
                right: 16,
                child: Container(
                  width: 44,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Color(0xFFF44336), // Merah
                    size: 24,
                  ),
                ),
              ),

              // 3. Indikator Titik Carousel (Kiri Bawah)
              Positioned(
                bottom: 24,
                left: 16,
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFF004CB9), // Biru aktif
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.white, // Inaktif
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),

              // 4. Label Harga (Kanan Bawah) - Efek Glassmorphism
              Positioned(
                bottom: 12,
                right: 12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(
                          0.75,
                        ), // Putih transparan
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Mulai dari",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            price,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0077FF), // Biru harga
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // --- Bagian Teks Detail Hotel ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Kiri (Nama, Bintang, Rating, Lokasi)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // Bintang
                          Row(
                            children: List.generate(
                              4, // Bintang aktif
                              (index) => const Icon(
                                Icons.star,
                                color: Color(0xFFFFB800), // Kuning
                                size: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          // Rating & Lokasi
                          Text(
                            "$rating/5",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              "|",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              location,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Info Kanan (Fasilitas)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildAmenityBadge(Icons.wifi, "Wi-fi"),
                    const SizedBox(height: 4),
                    _buildAmenityBadge(Icons.directions_car, "Gratis Parkir"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widget: Teks Fasilitas Hijau ---
  Widget _buildAmenityBadge(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: const Color(0xFF22C55E), // Hijau
          size: 12,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF22C55E), // Hijau
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
