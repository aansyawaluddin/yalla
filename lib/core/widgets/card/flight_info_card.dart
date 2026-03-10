import 'package:flutter/material.dart';

class FlightInfoCard extends StatelessWidget {
  const FlightInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Transform.scale(
                          scale: 1.5,
                          child: Image.asset(
                            'assets/images/logo_flydeal.png',
                            fit: BoxFit.cover,
                          ),
                        ),
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
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),

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
                                  fontSize: 8,
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
                                  fontSize: 8,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          const Text(
                            "1 Dewasa  •  Ekonomi",
                            style: TextStyle(
                              fontSize: 8,
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

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Jeddah",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 18, right: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 37.5,
                      height: 1.5,
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
                  ],
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
                      fontSize: 14,
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
