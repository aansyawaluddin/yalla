import 'package:flutter/material.dart';

class SmallPaketCard extends StatelessWidget {
  final String title;
  final String duration;
  final String price;
  final String imagePath;

  const SmallPaketCard({
    super.key,
    required this.title,
    required this.duration,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180, 
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
                colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
              ),
            ),
          ),

          // Konten Teks
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        duration,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 9,
                          height: 1.3,
                        ),
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white70,
                        ),
                        children: [
                          const TextSpan(text: "Mulai dari\n"),
                          TextSpan(
                            text: price,
                            style: const TextStyle(
                              color: Colors
                                  .white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
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
