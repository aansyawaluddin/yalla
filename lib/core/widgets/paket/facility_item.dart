import 'package:flutter/material.dart';

class FacilityItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const FacilityItem({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Lingkaran background untuk Icon
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFFEAF5FF), // Biru pucat
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF0084FF), // Biru ikon
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          // Teks Judul Fasilitas
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
