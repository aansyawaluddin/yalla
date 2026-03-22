import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F0F0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: Colors.black87,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tiket Anda',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  width: 100,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        bottom: 0,
                        child: CustomPaint(
                          size: const Size(90, 40),
                          painter: _AirplanePainter(),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 10,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFF48BB78),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Pembayaran Berhasil!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Transaksi sukses. Terima kasih atas pembayaran Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _TicketCard(
              barcodeOpacity: barcodeOpacity,
              barcodeSlide: barcodeSlide,
            ),
            const SizedBox(height: 28),

            AnimatedBuilder(
              animation: barcodeOpacity,
              builder: (context, _) {
                return Opacity(
                  opacity: barcodeOpacity.value,
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.download, color: Colors.white),
                      label: const Text(
                        'Unduh Tiket Digital',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class _TicketCard extends StatelessWidget {
  final Animation<double> barcodeOpacity;
  final Animation<double> barcodeSlide;

  const _TicketCard({required this.barcodeOpacity, required this.barcodeSlide});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _RouteLabel(
                      code: ticketData.origin,
                      city: ticketData.originCity,
                      align: CrossAxisAlignment.start,
                    ),
                    const _FlightLine(),
                    _RouteLabel(
                      code: ticketData.destination,
                      city: ticketData.destinationCity,
                      align: CrossAxisAlignment.end,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const _PerforatedDivider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoCell(
                      label: 'Nama Penumpang',
                      value: ticketData.passengerName,
                      flex: 1,
                    ),
                    _InfoCell(
                      label: 'Nomor Penerbangan',
                      value: ticketData.flightNumber,
                      flex: 1,
                      align: TextAlign.right,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoCell(
                      label: 'Waktu Keberangkatan',
                      value: ticketData.departureTime,
                      flex: 1,
                    ),
                    _InfoCell(
                      label: 'Kelas Kursi',
                      value: ticketData.seatClass,
                      flex: 1,
                      align: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const _PerforatedDivider(),
          AnimatedBuilder(
            animation: Listenable.merge([barcodeOpacity, barcodeSlide]),
            builder: (context, _) {
              return Opacity(
                opacity: barcodeOpacity.value,
                child: Transform.translate(
                  offset: Offset(0, barcodeSlide.value),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                    child: Column(
                      children: [
                        CustomPaint(
                          size: const Size(double.infinity, 72),
                          painter: _BarcodePainter(),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          ticketData.barcodeNumber,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            letterSpacing: 2,
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
    );
  }
}

class _RouteLabel extends StatelessWidget {
  final String code;
  final String city;
  final CrossAxisAlignment align;

  const _RouteLabel({
    required this.code,
    required this.city,
    required this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          code,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A1A),
            letterSpacing: -1,
          ),
        ),
        Text(city, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
      ],
    );
  }
}

class _FlightLine extends StatelessWidget {
  const _FlightLine();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400, width: 2),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: 60,
          child: CustomPaint(
            size: const Size(60, 2),
            painter: _DashedLinePainter(),
          ),
        ),
        const Icon(Icons.flight, color: Color(0xFF2563EB), size: 22),
        SizedBox(
          width: 60,
          child: CustomPaint(
            size: const Size(60, 2),
            painter: _DashedLinePainter(),
          ),
        ),
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF2563EB),
            shape: BoxShape.circle,
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

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;
  final int flex;
  final TextAlign align;

  const _InfoCell({
    required this.label,
    required this.value,
    required this.flex,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: align == TextAlign.right
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            label,
            textAlign: align,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: align,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _PerforatedDivider extends StatelessWidget {
  const _PerforatedDivider();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -14,
          top: -14,
          child: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F7FA),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          right: -14,
          top: -14,
          child: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F7FA),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: CustomPaint(
            size: const Size(double.infinity, 1),
            painter: _DashedLinePainter(),
          ),
        ),
      ],
    );
  }
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

class _AirplanePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bodyPaint = Paint()..color = const Color(0xFF3B82F6);
    final windowPaint = Paint()..color = const Color(0xFFBFDBFE);
    final whitePaint = Paint()..color = Colors.white;

    final bodyPath = Path()
      ..moveTo(0, size.height * 0.45)
      ..lineTo(size.width * 0.7, size.height * 0.35)
      ..lineTo(size.width, size.height * 0.4)
      ..lineTo(size.width * 0.7, size.height * 0.55)
      ..lineTo(0, size.height * 0.6)
      ..close();
    canvas.drawPath(bodyPath, bodyPaint);

    final bellyPath = Path()
      ..moveTo(size.width * 0.05, size.height * 0.52)
      ..lineTo(size.width * 0.7, size.height * 0.44)
      ..lineTo(size.width * 0.7, size.height * 0.55)
      ..lineTo(size.width * 0.05, size.height * 0.6)
      ..close();
    canvas.drawPath(bellyPath, whitePaint);

    final wingPath = Path()
      ..moveTo(size.width * 0.25, size.height * 0.48)
      ..lineTo(size.width * 0.5, size.height * 0.42)
      ..lineTo(size.width * 0.55, size.height * 0.1)
      ..lineTo(size.width * 0.25, size.height * 0.25)
      ..close();
    canvas.drawPath(wingPath, Paint()..color = const Color(0xFF2563EB));

    final tailPath = Path()
      ..moveTo(size.width * 0.02, size.height * 0.5)
      ..lineTo(size.width * 0.18, size.height * 0.48)
      ..lineTo(size.width * 0.18, size.height * 0.22)
      ..lineTo(size.width * 0.02, size.height * 0.38)
      ..close();
    canvas.drawPath(tailPath, Paint()..color = const Color(0xFF2563EB));

    for (int i = 0; i < 5; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.35 + i * 12, size.height * 0.37, 8, 6),
          const Radius.circular(2),
        ),
        windowPaint,
      );
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.38, size.height * 0.55, 22, 10),
        const Radius.circular(5),
      ),
      Paint()..color = const Color(0xFF1E40AF),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
