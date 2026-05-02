import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:yalla/features/user/plane/flight/detail_flight_screen.dart';

class OrderFlightCard extends StatelessWidget {
  const OrderFlightCard({super.key});

  // void _navigateToDetail(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     PageRouteBuilder(
  //       transitionDuration: const Duration(milliseconds: 300),
  //       reverseTransitionDuration: const Duration(milliseconds: 300),
  //       pageBuilder: (context, animation, secondaryAnimation) =>
  //           const DetailFlightScreen(),
  //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //         var curvedAnimation = CurvedAnimation(
  //           parent: animation,
  //           curve: Curves.easeOut,
  //         );
  //         return FadeTransition(opacity: curvedAnimation, child: child);
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF0084FF);
    const Color textDark = Color(0xFF111827);
    const Color textGrey = Color(0xFF6B7280);

    return GestureDetector(
      // onTap: () => _navigateToDetail(context),
      child: Container(
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
        child: Stack(
          children: [
            Positioned(
              right: -30,
              top: -100,
              bottom: 0,
              child: Opacity(
                opacity: 1,
                child: Image.asset(
                  'assets/images/bg_flight_card.png',
                  width: 250,
                  fit: BoxFit.contain,
                  color: Colors.black.withOpacity(0.15),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo_flydeal.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Flydeal Air",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: const [
                              Icon(
                                Icons.work_outline,
                                size: 14,
                                color: textGrey,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "25 Kg",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textGrey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(
                                Icons.restaurant_menu,
                                size: 14,
                                color: textGrey,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text(
                                "1 Dewasa",
                                style: TextStyle(fontSize: 11, color: textGrey),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                width: 1,
                                height: 10,
                                color: Colors.grey.shade400,
                              ),
                              const Text(
                                "Ekonomi",
                                style: TextStyle(fontSize: 11, color: textGrey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "02:00 AM",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: textDark,
                            ),
                          ),
                          Text(
                            "11j 15m",
                            style: TextStyle(
                              fontSize: 11,
                              color: textGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "12:15 PM",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: textDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            "UPG",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: textGrey,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: brandBlue, width: 2),
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: _buildDashedLine(Colors.grey.shade300),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Transform.rotate(
                              angle: math.pi / 4,
                              child: const Icon(
                                Icons.flight,
                                color: brandBlue,
                                size: 24,
                              ),
                            ),
                          ),
                          Expanded(
                            child: _buildDashedLine(Colors.grey.shade300),
                          ),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: brandBlue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "JED",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: textGrey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "1 Transit",
                        style: TextStyle(
                          fontSize: 11,
                          color: textGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total Harga",
                              style: TextStyle(
                                fontSize: 11,
                                color: textDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "IDR 1.250.000",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: brandBlue,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "Progress Pembayaran",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: brandBlue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "70%",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: brandBlue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Stack(
                              children: [
                                Container(
                                  height: 6,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F5FF),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: 0.7,
                                  child: Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: brandBlue,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      SizedBox(
                        height: 34,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandBlue,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Bayar",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Positioned(
              top: 24,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF0099FF), Color(0xFF005C99)],
                  ),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(8),
                  ),
                ),
                child: const Text(
                  "12 Agustus 2026",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashedLine(Color color) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        const dashSpace = 3.0;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1.5,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
        );
      },
    );
  }
}
