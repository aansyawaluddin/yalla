import 'package:flutter/material.dart';

class OrderHotelCard extends StatelessWidget {
  const OrderHotelCard({super.key});

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF0075FF);
    const Color textDark = Color(0xFF111827);
    const Color textGrey = Color(0xFF6B7280);

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
                    Icon(Icons.domain, color: brandBlue, size: 18),
                    SizedBox(width: 8),
                    Text(
                      "HOTEL",
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
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F0FF),
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Menunggu Pembayaran",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: brandBlue,
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/hotel.jpg', 
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),

                // Info Hotel
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hotel Borobudur Jakarta",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                            "Okt 12 - 15 Okt",
                            style: TextStyle(fontSize: 11, color: textGrey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            "3 Malam",
                            style: TextStyle(fontSize: 11, color: textGrey),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            width: 1,
                            height: 10,
                            color: Colors.grey.shade400,
                          ),
                          const Text(
                            "2 Tamu",
                            style: TextStyle(fontSize: 11, color: textGrey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Superior King Room",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: brandBlue,
                        ),
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
                  "IDR 1.250.000",
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
