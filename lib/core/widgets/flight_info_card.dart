import 'package:flutter/material.dart';

class FlightInfoCard extends StatelessWidget {
  const FlightInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFF67B5FE),
            Colors.white,
            Colors.white,
            Color(0xFF67B5FE),
          ],
          stops: [0.0, 0.20, 0.80, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/logo_flydeal.png',
                        height: 44,
                        width: 44,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 80),
                            child: const Text(
                              "Flydeal Air",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 6),

                          Row(
                            children: const [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 12,
                                color: Color(0xFF005C99),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "06 Juni 2026",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(
                                Icons.access_time,
                                size: 12,
                                color: Color(0xFF005C99),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "08 : 30 WITA",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Tipe Penumpang
                          const Text(
                            "1 Dewasa  •  Ekonomi",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black45,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F8FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "2 Hari Lagi",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0099FF),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "JED",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "Jeddah",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: IntrinsicWidth(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment
                            .stretch,
                        children: [
                          Container(
                            height: 3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Color(0xFFCDE8FF), Color(0xFF4DB0FF)],
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "On Time",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF22C55E),
                              fontSize: 9,
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "UPG",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "Makassar",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
