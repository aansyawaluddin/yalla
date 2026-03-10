import 'package:flutter/material.dart';

class SmallTravelCard extends StatelessWidget {
  final String title;
  final double rating;
  final String reviews;
  final String logoPath;

  const SmallTravelCard({
    super.key,
    required this.title,
    required this.rating,
    required this.reviews,
    required this.logoPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
              // Placeholder Logo (Ganti dengan Image.asset)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                // Uncomment kode di bawah jika gambar sudah ada di assets
                // child: ClipRRect(
                //   borderRadius: BorderRadius.circular(8),
                //   child: Image.asset(logoPath, fit: BoxFit.cover),
                // ),
              ),

              // Ikon Centang Biru Kecil
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0099FF),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0099FF).withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 10),
              ),
            ],
          ),
          const SizedBox(height: 24), // Spacer
          // Rating & Ulasan
          Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFFFC107), size: 14),
              const SizedBox(width: 4),
              Text(
                "$rating",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "($reviews Ulasan)",
                style: const TextStyle(color: Colors.black54, fontSize: 9),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Judul Travel
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
