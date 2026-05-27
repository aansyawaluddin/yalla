import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/models/order_model.dart';
import 'package:yalla/core/models/flight_model.dart';
import 'package:yalla/core/providers/order_provider.dart';
import 'package:yalla/core/widgets/button/primary_gradient_button.dart';
import 'package:yalla/core/widgets/snackbar/custom_snackbar.dart';

class TicketDetailPage extends StatelessWidget {
  final Animation<double> barcodeOpacity;
  final Animation<double> barcodeSlide;
  final OrderModel order;

  const TicketDetailPage({
    super.key,
    required this.barcodeOpacity,
    required this.barcodeSlide,
    required this.order,
  });

  String _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return "-";
    try {
      final date = DateTime.parse(isoString).toLocal();
      const months = [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return "${months[date.month]} ${date.day.toString().padLeft(2, '0')}, ${date.year}";
    } catch (e) {
      return "-";
    }
  }

  String _formatTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return "-";
    try {
      final date = DateTime.parse(isoString).toLocal();
      return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return "-";
    }
  }

  Future<void> _downloadTicket(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF0084FF)),
        ),
      ),
    );

    try {
      final bytes = await context.read<OrderProvider>().downloadManifest(
        order.id,
      );

      final file = File('${Directory.systemTemp.path}/tiket_${order.id}.pdf');
      await file.writeAsBytes(bytes);

      if (context.mounted) Navigator.pop(context);

      final result = await OpenFilex.open(file.path);

      if (result.type != ResultType.done) {
        if (context.mounted) {
          CustomSnackBar.showError(
            context,
            title: "Gagal",
            message: "Tidak ada aplikasi PDF di perangkat ini.",
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        CustomSnackBar.showError(
          context,
          title: "Gagal Mengunduh",
          message: e.toString().replaceAll("Exception: ", ""),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final FlightModel? flight = order.flight ?? order.returnFlight;
    final bool isOutbound = flight?.isOutbound ?? true;
    final String originCode = isOutbound ? "UPG" : "JED";
    final String originCity = isOutbound ? "Makassar" : "Jeddah";
    final String destCode = isOutbound ? "JED" : "UPG";
    final String destCity = isOutbound ? "Jeddah" : "Makassar";

    final String flightNo = flight?.flightNo ?? "-";
    final String depTime = _formatTime(flight?.departureTime);
    final String depDate = _formatDate(flight?.departureTime);

    final String passengerName = order.passengers.isNotEmpty
        ? order.passengers.first.fullName
        : "-";
    final String bookingRef = order.id.length >= 8
        ? order.id.substring(0, 8).toUpperCase()
        : order.id.toUpperCase();

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
                          // Route
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 42,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      originCode,
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF1A1A1A),
                                        letterSpacing: -1,
                                      ),
                                    ),
                                    Text(
                                      originCity,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      destCode,
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF1A1A1A),
                                        letterSpacing: -1,
                                      ),
                                    ),
                                    Text(
                                      destCity,
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

                          // Detail
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
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Nama Penumpang',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            passengerName,
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
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Nomor Penerbangan',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            flightNo,
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
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Waktu Keberangkatan',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "$depDate\n$depTime WITA",
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
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Kelas Kursi',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          const Text(
                                            "Ekonomi",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
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

                          // Barcode
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
                                          bookingRef,
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
                    order.manifestUrl != null
                        ? PrimaryGradientButton(
                            text: 'Unduh Tiket Digital',
                            onPressed: () => _downloadTicket(context),
                          )
                        : PrimaryGradientButton(
                            text: 'Tiket Belum Tersedia',
                            onPressed: () {
                              CustomSnackBar.showError(
                                context,
                                title: "Belum Tersedia",
                                message:
                                    "Tiket digital belum diterbitkan. Silakan cek kembali nanti.",
                              );
                            },
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
