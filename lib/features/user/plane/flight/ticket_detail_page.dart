import 'dart:math';
import 'package:flutter/material.dart';
import 'package:yalla/core/widgets/button/primary_gradient_button.dart';

class TicketData {
  final String origin = "UPG";
  final String originCity = "Makassar";
  final String destination = "JED";
  final String destinationCity = "Jeddah";
  final String passengerName = "Muhammad Fauzan";
  final String flightNumber = "SV - 817";
  final String departureTime = "24 Okt 2026,\n08:30 WITA";
  final String seatClass = "Ekonomi";
  final String barcodeNumber = "080819928277";
}

final ticketData = TicketData();

class TicketDetailPage extends StatelessWidget {
  final Animation<double> barcodeOpacity;
  final Animation<double> barcodeSlide;

  const TicketDetailPage({
    super.key,
    required this.barcodeOpacity,
    required this.barcodeSlide,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 24,
                right: 24,
                bottom: 8,
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF0084FF),
                        size: 18,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Tiket Anda",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 16,
                  bottom: 32,
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFDADADA),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 42,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Origin Label
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ticketData.origin,
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF1A1A1A),
                                        letterSpacing: -1,
                                      ),
                                    ),
                                    Text(
                                      ticketData.originCity,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                                // Flight Line
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color(0xFF0084FF),
                                              width: 1.5,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomPaint(
                                            size: const Size(
                                              double.infinity,
                                              2,
                                            ),
                                            painter: _DashedLinePainter(),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: Icon(
                                            Icons.flight,
                                            color: Color(0xFF0084FF),
                                            size: 24,
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomPaint(
                                            size: const Size(
                                              double.infinity,
                                              2,
                                            ),
                                            painter: _DashedLinePainter(),
                                          ),
                                        ),
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF0084FF),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Destination Label
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      ticketData.destination,
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF1A1A1A),
                                        letterSpacing: -1,
                                      ),
                                    ),
                                    Text(
                                      ticketData.destinationCity,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const TicketDivider(),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 42,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Passenger Name Cell
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Nama Penumpang',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            ticketData.passengerName,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1A1A1A),
                                              height: 1.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Flight Number Cell
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Nomor Penerbangan',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            ticketData.flightNumber,
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1A1A1A),
                                              height: 1.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 28),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Departure Time Cell
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Waktu Keberangkatan',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            ticketData.departureTime,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1A1A1A),
                                              height: 1.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Seat Class Cell
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Kelas Kursi',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            ticketData.seatClass,
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1A1A1A),
                                              height: 1.3,
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

                          const TicketDivider(),

                          AnimatedBuilder(
                            animation: Listenable.merge([
                              barcodeOpacity,
                              barcodeSlide,
                            ]),
                            builder: (context, _) {
                              return Opacity(
                                opacity: barcodeOpacity.value,
                                child: Transform.translate(
                                  offset: Offset(0, barcodeSlide.value),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 32,
                                      right: 32,
                                      top: 40,
                                      bottom: 40,
                                    ),
                                    child: Column(
                                      children: [
                                        CustomPaint(
                                          size: const Size(
                                            double.infinity,
                                            100,
                                          ),
                                          painter: _BarcodePainter(),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          ticketData.barcodeNumber,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                            letterSpacing: 4.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    PrimaryGradientButton(
                      text: 'Unduh Tiket Digital',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TicketDivider extends StatelessWidget {
  const TicketDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // --- Left Cutout ---
        Positioned(
          left: -1.5,
          top: -20,
          child: ClipRect(
            child: Align(
              alignment: Alignment.centerRight,
              widthFactor: 0.5,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFDADADA),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.25)),
                    const BoxShadow(
                      color: Colors.white,
                      spreadRadius: -2.0,
                      blurRadius: 4.0,
                      offset: Offset(-2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // --- Right Cutout ---
        Positioned(
          right: -1.5,
          top: -20,
          child: ClipRect(
            child: Align(
              alignment: Alignment.centerLeft,
              widthFactor: 0.5,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFDADADA),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.25)),
                    const BoxShadow(
                      color: Colors.white,
                      spreadRadius: -2.0,
                      blurRadius: 4.0,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomPaint(
            size: const Size(double.infinity, 1),
            painter: _DashedLinePainter(),
          ),
        ),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    double startX = 0;
    const dashWidth = 5.0;
    const dashSpace = 3.0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 1), Offset(startX + dashWidth, 1), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _BarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final random = Random(42);

    double x = 0;
    while (x < size.width) {
      final w = random.nextDouble() * 3 + 1;
      if (random.nextBool()) {
        canvas.drawRect(Rect.fromLTWH(x, 0, w, size.height), paint);
      }
      x += w + (random.nextDouble() * 2 + 0.5);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
