import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:yalla/core/models/flight_model.dart';
import 'package:yalla/core/models/order_model.dart';
import 'package:yalla/features/travel/order/passenger_detail_screen.dart';

class DetailOrderTravel extends StatefulWidget {
  final OrderModel order;

  const DetailOrderTravel({super.key, required this.order});

  @override
  State<DetailOrderTravel> createState() => _DetailOrderTravelState();
}

class _DetailOrderTravelState extends State<DetailOrderTravel> {
  String _formatTime(String? isoString, String fallback) {
    if (isoString == null || isoString.isEmpty) return fallback;
    try {
      final date = DateTime.parse(isoString).toLocal();
      String hh = date.hour.toString().padLeft(2, '0');
      String mm = date.minute.toString().padLeft(2, '0');
      return "$hh:$mm";
    } catch (e) {
      return fallback;
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

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF0084FF);
    const Color textDark = Color(0xFF111827);
    const Color textGrey = Color(0xFF6B7280);

    final OrderModel order = widget.order;
    final FlightModel? flightData = order.flight ?? order.returnFlight;
    final List<PassengerModel> passengers = order.passengers;
    final int paxCount = passengers.isNotEmpty ? passengers.length : 1;

    final bool isOutbound = flightData?.isOutbound ?? true;
    final String originCode = isOutbound ? "UPG" : "JED";
    final String destCode = isOutbound ? "JED" : "UPG";
    final String depTime = _formatTime(flightData?.departureTime, "-");
    final String arrTime = _formatTime(flightData?.arrivalTime, "-");
    final String duration = _calculateDuration(
      flightData?.departureTime,
      flightData?.arrivalTime,
      "11j 15m",
    );

    final String createdDateLabel = _formatDateLong(order.createdAt);
    final bool isWaitingPayment = order.status == 'waiting_payment';

    double progressValue = isWaitingPayment ? 0.0 : 1.0;
    String progressText = isWaitingPayment ? "0%" : "100%";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(Icons.arrow_back, color: brandBlue, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Detail Pesanan",
          style: TextStyle(
            color: textDark,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Flydeal Air",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
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
                                      "$paxCount Dewasa",
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
                          const SizedBox(width: 100),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // if (isWaitingPayment)
                      //   Row(
                      //     children: [
                      //       const Icon(
                      //         Icons.warning_amber_rounded,
                      //         color: Colors.orange,
                      //         size: 16,
                      //       ),
                      //       const SizedBox(width: 6),
                      //       Text(
                      //         "$paxCount Jamaah belum melakukan pelunasan",
                      //         style: const TextStyle(
                      //           color: Colors.orange,
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.w500,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                depTime,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                originCode,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: textGrey,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  duration,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: textGrey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: brandBlue,
                                          width: 2,
                                        ),
                                        color: Colors.white,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildDashedLine(
                                        Colors.grey.shade300,
                                      ),
                                    ),
                                    Transform.rotate(
                                      angle: math.pi / 4,
                                      child: const Icon(
                                        Icons.flight,
                                        color: brandBlue,
                                        size: 24,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildDashedLine(
                                        Colors.grey.shade300,
                                      ),
                                    ),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: brandBlue,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "1 Transit",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                arrTime,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                destCode,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: textGrey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Progress Pembayaran",
                            style: TextStyle(fontSize: 10, color: textDark),
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
                      const SizedBox(height: 8),
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
                Positioned(
                  top: 24,
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
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.grey.shade500,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Cari Jamaah",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.tune, color: textDark),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: passengers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final pax = passengers[index];

                // bool isPaid = order.status != 'waiting_payment';
                // String paxStatusText = isPaid ? "Lunas" : "Belum Lunas";
                // Color paxBadgeBg = isPaid
                //     ? const Color(0xFFE8FCEF)
                //     : const Color(0xFFFFEDD5);
                // Color paxBadgeText = isPaid
                //     ? const Color(0xFF16A34A)
                //     : Colors.orange.shade700;

                // TAMBAHKAN GestureDetector di sini
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PassengerDetailScreen(
                          passenger: pax,
                          orderStatus: order.status,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey.shade200,
                          child: const Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pax.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: textDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                pax.passportNumber ??
                                    "#J-${pax.id.substring(0, 4).toUpperCase()}",
                                style: const TextStyle(
                                  color: textGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //     horizontal: 12,
                        //     vertical: 6,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     color: paxBadgeBg,
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        //   child: Text(
                        //     paxStatusText,
                        //     style: TextStyle(
                        //       color: paxBadgeText,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 12,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
