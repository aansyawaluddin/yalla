import 'package:flutter/material.dart';

class LargeTravelCard extends StatelessWidget {
  const LargeTravelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A4D3C), // Warna hijau gelap CMA
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "C",
                    style: TextStyle(
                      color: Color(0xFFD4AF37), // Warna emas
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Serif', // Gunakan font serif jika ada
                    ),
                  ),
                ),
              ),

              // Badge Terverifikasi
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0099FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.verified, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text(
                      "Terverifikasi",
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
          const SizedBox(height: 16),

          // Rating & Ulasan
          Row(
            children: const [
              Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
              SizedBox(width: 4),
              Text(
                "4.9",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              SizedBox(width: 4),
              Text(
                "(2.4k Ulasan)",
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Judul
          const Text(
            "CMA Tour & Travel",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // Deskripsi
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text:
                      "Kami adalah penyelenggara perjalanan ibadah umrah yang berkomitmen memberikan pelayanan terbaik dengan prinsip amanah, profesional, dan transparan. ",
                ),
                TextSpan(
                  text: "Selengkapnya...",
                  style: TextStyle(
                    color: Color(0xFF0099FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
