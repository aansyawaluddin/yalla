import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/providers/flight_provider.dart';
import 'package:yalla/core/models/flight_model.dart';
import 'package:yalla/core/models/passenger_model.dart';

class AdminFlightPassengersScreen extends StatefulWidget {
  final String flightId;

  const AdminFlightPassengersScreen({super.key, required this.flightId});

  @override
  State<AdminFlightPassengersScreen> createState() =>
      _AdminFlightPassengersScreenState();
}

class _AdminFlightPassengersScreenState
    extends State<AdminFlightPassengersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FlightProvider>().fetchFlightPassengers(widget.flightId);
    });
  }

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

  String _formatDateShort(String? isoString) {
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

  Map<String, List<PassengerModel>> _groupPassengers(
    List<PassengerModel> passengers,
  ) {
    final List<PassengerModel> sortedList = List.from(passengers);
    sortedList.sort((a, b) {
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      try {
        final dateA = DateTime.parse(a.createdAt!);
        final dateB = DateTime.parse(b.createdAt!);
        return dateB.compareTo(dateA);
      } catch (_) {
        return 0;
      }
    });

    Map<String, List<PassengerModel>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var pax in sortedList) {
      if (pax.createdAt == null) continue;
      try {
        final date = DateTime.parse(pax.createdAt!).toLocal();
        final paxDate = DateTime(date.year, date.month, date.day);

        String key;
        if (paxDate == today) {
          key = "Hari Ini";
        } else if (paxDate == yesterday) {
          key = "Kemarin";
        } else {
          key = _formatDateShort(pax.createdAt);
        }

        if (!grouped.containsKey(key)) {
          grouped[key] = [];
        }
        grouped[key]!.add(pax);
      } catch (e) {
        if (!grouped.containsKey("Lainnya")) grouped["Lainnya"] = [];
        grouped["Lainnya"]!.add(pax);
      }
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF0084FF);
    const Color textDark = Color(0xFF111827);
    const Color textGrey = Color(0xFF6B7280);

    final provider = context.watch<FlightProvider>();
    final paxData = provider.passengerData;
    final FlightModel? flightData = paxData?.flight;
    final passengers = paxData?.passengers ?? [];

    final bool isOutbound = flightData?.isOutbound ?? true;
    final String originCode = isOutbound ? "UPG" : "JED";
    final String destCode = isOutbound ? "JED" : "UPG";
    final int paxCount = paxData?.passengersCount ?? 0;
    final num flightPrice = flightData?.price ?? 0;

    final String depTime = _formatTime(flightData?.departureTime, "-");
    final String arrTime = _formatTime(flightData?.arrivalTime, "-");
    final String createdDateLabel = _formatDateLong(flightData?.departureTime);

    final groupedPassengers = _groupPassengers(passengers);

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
          "Detail Penumpang",
          style: TextStyle(
            color: textDark,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: provider.isPassengerLoading
          ? const Center(child: CircularProgressIndicator(color: brandBlue))
          : provider.passengerErrorMessage.isNotEmpty
          ? Center(
              child: Text(
                provider.passengerErrorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : Column(
              children: [
                // ── 1. Flight Detail Card ──
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
                          color: Colors.black.withOpacity(0.05),
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
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        flightData?.flightNo ?? "Flydeal Air",
                                        style: const TextStyle(
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

                Expanded(
                  child: passengers.isEmpty
                      ? Center(
                          child: Text(
                            "Belum ada penumpang terdaftar",
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: groupedPassengers.keys.length,
                          itemBuilder: (context, index) {
                            String dateKey = groupedPassengers.keys.elementAt(
                              index,
                            );
                            List<PassengerModel> paxs =
                                groupedPassengers[dateKey]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  color: const Color(0xFFFAFAFA),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                    vertical: 12.0,
                                  ),
                                  child: Text(
                                    dateKey,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                                ...paxs.map((pax) {
                                  final isLast = pax == paxs.last;
                                  return Column(
                                    children: [
                                      _buildPassengerOrderItem(
                                        pax,
                                        flightPrice,
                                      ),
                                      if (!isLast)
                                        const Divider(
                                          height: 1,
                                          color: Color(0xFFF3F4F6),
                                        ),
                                    ],
                                  );
                                }).toList(),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildPassengerOrderItem(PassengerModel pax, num price) {
    final String name = pax.fullName ?? "Tanpa Nama";
    final String shortBookingId = (pax.orderId ?? pax.id ?? "000000")
        .substring(0, 6)
        .toUpperCase();
    final String bookingIdLabel = "#BK - $shortBookingId";
    final String passportInfo = "Paspor: ${pax.passportNumber ?? '-'}";
    final String dateStr = _formatDateShort(pax.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person, // Icon default
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child: Container(
                  //     width: 14,
                  //     height: 14,
                  //     decoration: BoxDecoration(
                  //       color: const Color(0xFF22C55E),
                  //       shape: BoxShape.circle,
                  //       border: Border.all(color: Colors.white, width: 2),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Booking ID: $bookingIdLabel",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.badge_outlined,
                        size: 16,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        passportInfo,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatPrice(price),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0084FF),
                    ),
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
