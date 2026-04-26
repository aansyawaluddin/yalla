import 'package:flutter/material.dart';
import 'package:yalla/core/widgets/button/custom_bottom_nav_bar.dart';

class JelajahScreen extends StatelessWidget {
  const JelajahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: Stack(
        children: [
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

          // --- 2. Konten Utama ---
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Judul
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      "Jelajah",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF003875), // Biru gelap
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: "",
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF0066CC),
                            size: 22,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- Section: Tempat Bersantai Favorit ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Tempat Bersantai Favorit",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "Lihat Semua",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0084FF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Grid Layout
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        // Card Atas (Besar)
                        _buildGridItem(
                          height: 140,
                          imageUrl:
                              'assets/images/cafe1.jpeg', // Ganti dengan gambar Anda
                          location: "Jeddah",
                          name: "Al - Balad Cafe & Resto",
                          rating: "4.9",
                        ),
                        const SizedBox(height: 12),
                        // Dua Card Bawah (Kecil)
                        Row(
                          children: [
                            Expanded(
                              child: _buildGridItem(
                                height: 110,
                                imageUrl: 'assets/images/cafe2.jpeg',
                                location: "Jeddah",
                                name: "Cortniche",
                                rating: null, // Tanpa rating di desain bawah
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildGridItem(
                                height: 110,
                                imageUrl: 'assets/images/cafe3.jpeg',
                                location: "Jeddah",
                                name: "Million Coffee",
                                rating: null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- Section: Mungkin Anda Suka ---
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      "Mungkin Anda Suka",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // List Vertical
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        _buildListItem(
                          imageUrl: 'assets/images/place1.jpeg',
                          title: "Bakery & Beans",
                          subtitle: "Mulai dari 10riyal • 1.2 Km",
                          rating: "4.9",
                        ),
                        const SizedBox(height: 16),
                        _buildListItem(
                          imageUrl: 'assets/images/place2.jpeg',
                          title: "Space Work",
                          subtitle: "Mulai dari 10riyal • 1.2 Km",
                          rating: "4.7",
                        ),
                        const SizedBox(height: 16),
                        _buildListItem(
                          imageUrl: 'assets/images/place3.jpeg',
                          title: "Kopi Nako",
                          subtitle: "Mulai dari 10riyal • 1.2 Km",
                          rating: "4.4",
                        ),
                        const SizedBox(
                          height: 32,
                        ), // Padding bawah sebelum nav bar
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Menggunakan CustomBottomNavBar (Asumsi icon tengah adalah index 2)
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }

  // --- Helper: Card Grid Gambar dengan Overlay Gelap ---
  Widget _buildGridItem({
    required double height,
    required String imageUrl,
    required String location,
    required String name,
    String? rating,
  }) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Gambar Background
            Positioned.fill(
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                // Fallback sementara jika gambar belum ada
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.grey.shade300),
              ),
            ),
            // Gradient Overlay agar teks terbaca
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Teks Kiri Bawah
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$location,",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Badge Rating (Jika ada)
            if (rating != null)
              Positioned(top: 12, left: 12, child: _buildRatingBadge(rating)),
          ],
        ),
      ),
    );
  }

  // --- Helper: List Item untuk "Mungkin Anda Suka" ---
  Widget _buildListItem({
    required String imageUrl,
    required String title,
    required String subtitle,
    required String rating,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        children: [
          // Gambar Kotak
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(width: 60, height: 60, color: Colors.grey.shade300),
            ),
          ),
          const SizedBox(width: 16),
          // Detail Teks
          Expanded(
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
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          // Badge Rating
          _buildRatingBadge(rating),
        ],
      ),
    );
  }

  // --- Helper: Badge Rating Biru ---
  Widget _buildRatingBadge(String rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0084FF), // Biru terang
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            color: Color(0xFFFFD700), // Kuning
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            rating,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
