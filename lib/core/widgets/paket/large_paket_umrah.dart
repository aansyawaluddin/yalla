import 'package:flutter/material.dart';

class LargePaketCard extends StatelessWidget {
  final String titleNormal;
  final String titleHighlight;
  final String duration;
  final String price;
  final String imagePath;
  final bool isPopular;

  const LargePaketCard({
    super.key,
    required this.titleNormal,
    required this.titleHighlight,
    required this.duration,
    required this.price,
    required this.imagePath,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.8), 
                ],
              ),
            ),
          ),

          // Badge "Terpopuler" (Kiri Atas)
          if (isPopular)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0099FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Terpopuler",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Konten Teks (Bawah)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    children: [
                      TextSpan(
                        text: titleNormal,
                        style: const TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: titleHighlight,
                        style: const TextStyle(color: Color(0xFFFF9800)),
                      ), // Oranye
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      duration,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                        children: [
                          const TextSpan(text: "Mulai dari "),
                          TextSpan(
                            text: price,
                            style: const TextStyle(
                              color: Color(
                                0xFFFFD700,
                              ), 
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
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
        ],
      ),
    );
  }
}
