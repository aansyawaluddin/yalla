import 'package:flutter/material.dart';

class OrderVisaCard extends StatelessWidget {
  const OrderVisaCard({super.key});

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF0075FF);
    const Color textDark = Color(0xFF111827);
    const Color textGrey = Color(0xFF6B7280);
    const Color greenSuccess = Color(0xFF4CAF50);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.description_outlined,
                      color: brandBlue,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "VISA",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: brandBlue,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8FAED),
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Disetujui",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: greenSuccess,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tourist E-Visa (Jeddah)",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 12,
                            color: brandBlue,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "06 Juni 2026",
                            style: TextStyle(fontSize: 11, color: textGrey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            color: const Color(0xFFF8FBFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Total Harga",
                  style: TextStyle(
                    fontSize: 13,
                    color: textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "IDR 1.500.000",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: brandBlue,
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
