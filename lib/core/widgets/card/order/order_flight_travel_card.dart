import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/models/flight_model.dart';
import 'package:yalla/core/models/order_model.dart';
import 'package:yalla/core/providers/order_provider.dart';
import 'package:yalla/core/widgets/snackbar/custom_snackbar.dart';
import 'package:yalla/features/travel/home/payment_travel_screen.dart';
import 'package:yalla/features/travel/order/detail_order_travel.dart';

class OrderFlightTravelCard extends StatelessWidget {
  final OrderModel order;

  const OrderFlightTravelCard({super.key, required this.order});

  void _navigateToDetail(BuildContext context, String currentStatus) {
    if (currentStatus == 'waiting_payment') {
      context.read<OrderProvider>().setLastOrderId(order.id);
      final double? safePrice = order.price.toDouble();

      DateTime createdAt = DateTime.now();
      if (order.createdAt.isNotEmpty) {
        createdAt = DateTime.parse(order.createdAt).toLocal();
      }
      final DateTime absoluteDeadline = createdAt.add(
        const Duration(hours: 24),
      );

      final dataFlight = FlightModel(
        id: order.departureFlightId,
        flightNo: order.flight?.flightNo ?? "Pesanan Lanjutan",
        departureTime: order.flight?.departureTime,
        arrivalTime: order.flight?.arrivalTime,
        price: safePrice,
      );

      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) =>
              PaymentTravelScreen(
                flight: dataFlight,
                paymentAmount: order.price.toInt(),
                paymentDeadline: absoluteDeadline,
                orderId: order.id,
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else if (currentStatus == 'on_process') {
      CustomSnackBar.showSuccess(
        context,
        title: 'Sedang Diverifikasi',
        message:
            'Pembayaran Anda sedang diverifikasi oleh Admin. Mohon tunggu.',
      );
    } else if (currentStatus == 'approved') {
      CustomSnackBar.showSuccess(
        context,
        title: 'Pesanan Lunas',
        message: 'Pesanan sudah lunas! Mengarahkan ke E-Ticket...',
      );
    }
  }

  String _formatPrice(num? price) {
    if (price == null || price == 0) return "IDR 0";
    String s = price.toInt().toString();
    String res = "";
    for (int i = 0; i < s.length; i++) {
      res += s[i];
      if ((s.length - 1 - i) % 3 == 0 && i != s.length - 1) res += ".";
    }
    return "IDR $res";
  }

  String _formatTime(String? isoString, String fallback) {
    if (isoString == null || isoString.isEmpty) return fallback;
    try {
      final date = DateTime.parse(isoString).toLocal();
      String hour = date.hour.toString().padLeft(2, '0');
      String minute = date.minute.toString().padLeft(2, '0');
      return "$hour:$minute";
    } catch (e) {
      return fallback;
    }
  }

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
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      return "${date.day} ${months[date.month]} ${date.year}";
    } catch (e) {
      return "-";
    }
  }

  String _formatDateLong(String? isoString) {
    if (isoString == null || isoString.isEmpty) return "-";
    try {
      final date = DateTime.parse(isoString).toLocal();
      const months = [
        '',
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];
      return "${date.day} ${months[date.month]} ${date.year}";
    } catch (e) {
      return "-";
    }
  }

  String _calculateDuration(String? dep, String? arr, String fallback) {
    if (dep == null || arr == null || dep.isEmpty || arr.isEmpty) {
      return fallback;
    }
    try {
      final d = DateTime.parse(dep);
      final a = DateTime.parse(arr);
      final diff = a.difference(d);
      final hours = diff.inHours;
      final mins = diff.inMinutes.remainder(60);
      return "${hours}j ${mins}m";
    } catch (e) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF0084FF);
    const Color textDark = Color(0xFF111827);
    const Color textGrey = Color(0xFF6B7280);

    final num price = order.price;
    final String status = order.status;
    final List<PassengerModel> passengers = order.passengers;
    final int paxCount = passengers.isNotEmpty ? passengers.length : 1;

    final FlightModel? flightData = order.flight;

    const String airline = "Flydeal Air";

    final bool isOutbound = flightData?.isOutbound ?? true;
    final String originCode = isOutbound ? "UPG" : "JED";
    final String destCode = isOutbound ? "JED" : "UPG";

    final String depTime = _formatTime(flightData?.departureTime, "07:00");
    final String arrTime = _formatTime(flightData?.arrivalTime, "14:45");
    final String depDate = _formatDate(flightData?.departureTime);
    final String arrDate = _formatDate(flightData?.arrivalTime);
    final String duration = _calculateDuration(
      flightData?.departureTime,
      flightData?.arrivalTime,
      "7j 45m",
    );

    final String createdDateLabel = _formatDateLong(order.createdAt);

    final bool isWaitingPayment = status == 'waiting_payment';
    final bool isOnProcess = status == 'on_process';

    Color badgeColor;
    String progressText;
    double progressValue;

    if (isWaitingPayment) {
      badgeColor = Colors.orange;
      progressText = "Belum Lunas";
      progressValue = 0.0;
    } else if (isOnProcess) {
      badgeColor = brandBlue;
      progressText = "Verifikasi";
      progressValue = 0.5;
    } else {
      badgeColor = Colors.green;
      progressText = "Lunas";
      progressValue = 1.0;
    }

    return GestureDetector(
      onTap: () {
        if (isWaitingPayment) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailOrderTravel(order: order),
            ),
          );
        } else {
          _navigateToDetail(context, status);
        }
      },
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
              child: Image.asset(
                'assets/images/bg_flight_card.png',
                width: 250,
                fit: BoxFit.contain,
                color: Colors.black.withOpacity(0.15),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              airline,
                              style: const TextStyle(
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
                                Text(
                                  "$paxCount Penumpang",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: textGrey,
                                  ),
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
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 120),
                    ],
                  ),

                  const SizedBox(height: 32),

                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                depTime,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: textDark,
                                ),
                              ),
                              Text(
                                depDate,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: textGrey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          Text(
                            duration,
                            style: const TextStyle(
                              fontSize: 11,
                              color: textGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                arrTime,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: textDark,
                                ),
                              ),
                              Text(
                                arrDate,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: textGrey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Text(
                            originCode,
                            style: const TextStyle(
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
                          Text(
                            destCode,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: textGrey,
                            ),
                          ),
                        ],
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
                            Text(
                              _formatPrice(price),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: brandBlue,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Progress Pembayaran",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: brandBlue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  progressText,
                                  style: const TextStyle(
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
                                  widthFactor: progressValue,
                                  child: Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: badgeColor,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (isWaitingPayment) ...[
                        const SizedBox(width: 24),
                        SizedBox(
                          height: 34,
                          width: 90,
                          child: ElevatedButton(
                            onPressed: () => _navigateToDetail(context, status),
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
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ] else if (isOnProcess || status == 'approved') ...[
                        const SizedBox(width: 24),
                        SizedBox(
                          height: 34,
                          width: 110,
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailOrderTravel(order: order),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Jemaah",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            Positioned(
              top: 30,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: const BoxDecoration(
                  color: brandBlue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Text(
                  createdDateLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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
