import 'dart:math';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:yalla/core/models/order_model.dart';
import 'package:yalla/core/models/flight_model.dart';
import 'package:yalla/core/providers/order_provider.dart';
import 'package:yalla/core/widgets/button/primary_gradient_button.dart';
import 'package:yalla/core/widgets/snackbar/custom_snackbar.dart';
import 'package:yalla/features/user/home/home_screen.dart';

class PackageTicketDetailScreen extends StatelessWidget {
  final Animation<double> barcodeOpacity;
  final Animation<double> barcodeSlide;
  final OrderModel order;

  const PackageTicketDetailScreen({
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

      final file = File(
        '${Directory.systemTemp.path}/tiket_paket_${order.id}.pdf',
      );
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
    // --- Data dari order ---
    final FlightModel? departureFlight =
        order.package?.departureFlight ?? order.flight;
    final FlightModel? returnFlight =
        order.package?.returnFlight ?? order.returnFlight;

    final String passengerName = order.passengers.isNotEmpty
        ? order.passengers.first.fullName
        : "-";
    final String bookingRef = order.id.length >= 8
        ? order.id.substring(0, 8).toUpperCase()
        : order.id.toUpperCase();

    // Departure flight info
    final String depFlightNo = departureFlight?.flightNo ?? "-";
    final String depTime = _formatTime(departureFlight?.departureTime);
    final String depDate = _formatDate(departureFlight?.departureTime);

    // Return flight info
    final String retFlightNo = returnFlight?.flightNo ?? "-";
    final String retTime = _formatTime(returnFlight?.departureTime);
    final String retDate = _formatDate(returnFlight?.departureTime);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
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
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "E-Tiket Paket Umrah",
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
                    // --- KARTU TIKET UTAMA ---
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
                          // --- HEADER PAKET ---
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F8FF),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(
                                        0xFF0084FF,
                                      ).withOpacity(0.3),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.mosque,
                                    color: Color(0xFF0084FF),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.package?.packageName ??
                                            "Paket Umrah",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1A1A1A),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Paket Perjalanan Umrah",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F5E9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "CONFIRMED",
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2E7D32),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const PackageTicketDivider(),

                          // --- RUTE KEBERANGKATAN ---
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildRouteLabel("Keberangkatan"),
                                const SizedBox(height: 12),
                                _buildRouteRow(
                                  originCode: "UPG",
                                  originCity: "Makassar",
                                  destCode: "JED",
                                  destCity: "Jeddah",
                                  flightNo: depFlightNo,
                                  date: depDate,
                                  time: depTime,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // --- RUTE KEPULANGAN ---
                          if (returnFlight != null)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildRouteLabel("Kepulangan"),
                                  const SizedBox(height: 12),
                                  _buildRouteRow(
                                    originCode: "JED",
                                    originCity: "Jeddah",
                                    destCode: "UPG",
                                    destCity: "Makassar",
                                    flightNo: retFlightNo,
                                    date: retDate,
                                    time: retTime,
                                  ),
                                ],
                              ),
                            ),

                          const PackageTicketDivider(),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow(
                                  label: "Nama Penumpang",
                                  value: passengerName,
                                  align: CrossAxisAlignment.start,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildInfoRow(
                                        label: "No. Penerbangan (PP)",
                                        value: "$depFlightNo\n$retFlightNo",
                                        align: CrossAxisAlignment.start,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildInfoRow(
                                        label: "Kelas",
                                        value: "Ekonomi",
                                        align: CrossAxisAlignment.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const PackageTicketDivider(),

                          // --- BARCODE ---
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
                                    padding: const EdgeInsets.fromLTRB(
                                      32,
                                      40,
                                      32,
                                      40,
                                    ),
                                    child: Column(
                                      children: [
                                        CustomPaint(
                                          size: const Size(double.infinity, 90),
                                          painter: _PackageBarcodePainter(),
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

                    // --- TOMBOL UNDUH ---
                    order.manifestUrl != null
                        ? PrimaryGradientButton(
                            text: 'Unduh E-Tiket Paket',
                            onPressed: () => _downloadTicket(context),
                          )
                        : PrimaryGradientButton(
                            text: 'Tiket Belum Tersedia',
                            onPressed: () {
                              CustomSnackBar.showError(
                                context,
                                title: "Belum Tersedia",
                                message:
                                    "E-tiket paket belum diterbitkan. Silakan cek kembali nanti.",
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

  // --- HELPER WIDGETS ---

  Widget _buildRouteLabel(String label) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Color(0xFF0084FF),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRouteRow({
    required String originCode,
    required String originCity,
    required String destCode,
    required String destCity,
    required String flightNo,
    required String date,
    required String time,
  }) {
    return Column(
      children: [
        Row(
          children: [
            // Origin
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  originCode,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  originCity,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),

            // Arrow / flight
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomPaint(
                            size: const Size(double.infinity, 2),
                            painter: _PackageDashedLinePainter(),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            Icons.flight_takeoff,
                            color: Color(0xFF0084FF),
                            size: 18,
                          ),
                        ),
                        Expanded(
                          child: CustomPaint(
                            size: const Size(double.infinity, 2),
                            painter: _PackageDashedLinePainter(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      flightNo,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF0084FF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Destination
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  destCode,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  destCity,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ],
        ),

        // --- TAMBAHAN: tanggal & waktu ---
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F8FF),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFF0084FF).withOpacity(0.15),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 11,
                    color: Color(0xFF0084FF),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0084FF),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F8FF),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFF0084FF).withOpacity(0.15),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 11,
                    color: Color(0xFF0084FF),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "$time WITA",
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0084FF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required CrossAxisAlignment align,
  }) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          textAlign: align == CrossAxisAlignment.end
              ? TextAlign.right
              : TextAlign.left,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// --- DIVIDER TIKET ---
class PackageTicketDivider extends StatelessWidget {
  const PackageTicketDivider({super.key});

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
            painter: _PackageDashedLinePainter(),
          ),
        ),
      ],
    );
  }
}

class _PackageDashedLinePainter extends CustomPainter {
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

class _PackageBarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final random = Random(99); // seed berbeda dari tiket flight

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
