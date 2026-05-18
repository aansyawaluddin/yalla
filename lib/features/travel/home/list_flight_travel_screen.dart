import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/models/flight_model.dart';
import 'package:yalla/core/providers/flight_provider.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/widgets/card/flight_card_travel.dart';

class ListFlightTravelScreen extends StatefulWidget {
  final DateTime selectedDate;
  final bool isOutbound;

  const ListFlightTravelScreen({
    super.key,
    required this.selectedDate,
    required this.isOutbound,
  });

  @override
  State<ListFlightTravelScreen> createState() => _ListFlightTravelScreenState();
}

class _ListFlightTravelScreenState extends State<ListFlightTravelScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FlightProvider>().fetchFlights();
    });
  }

  String _formatIndonesianDate(DateTime date) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    const months = [
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
    return "${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final flightProvider = context.watch<FlightProvider>();
    final isLoading = flightProvider.isLoading;

    String pad(int n) => n.toString().padLeft(2, '0');
    String targetDateString =
        "${widget.selectedDate.year}-${pad(widget.selectedDate.month)}-${pad(widget.selectedDate.day)}";

    List<FlightModel> filteredFlights = flightProvider.flights.where((flight) {
      if (flight.departureTime == null) return false;

      bool isSameDate = flight.departureTime!.startsWith(targetDateString);
      bool isSameRoute = flight.isOutbound == widget.isOutbound;

      return isSameDate && isSameRoute;
    }).toList();

    DateTime now = DateTime.now();

    filteredFlights.sort((a, b) {
      if (a.departureTime == null || b.departureTime == null) return 0;
      try {
        final dateA = DateTime.parse(a.departureTime!);
        final dateB = DateTime.parse(b.departureTime!);
        final diffA = dateA.difference(now).inSeconds;
        final diffB = dateB.difference(now).inSeconds;

        if (diffA >= 0 && diffB >= 0) return diffA.compareTo(diffB);
        if (diffA < 0 && diffB < 0) return diffB.compareTo(diffA);
        if (diffA >= 0) return -1;
        return 1;
      } catch (e) {
        return 0;
      }
    });

    FlightModel? highlightedFlight = filteredFlights.isNotEmpty
        ? filteredFlights.first
        : null;
    List<FlightModel> otherFlights = filteredFlights.length > 1
        ? filteredFlights.sublist(1)
        : [];

    String displayDate = _formatIndonesianDate(widget.selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFE8F1F8),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background Seamless
            Positioned(
              top: -90.0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.55 + 70,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg_home.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFFE8F1F8).withOpacity(0.1),
                        const Color(0xFFE8F1F8).withOpacity(0.8),
                        const Color(0xFFE8F1F8),
                      ],
                      stops: const [0.3, 0.6, 0.85, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                size: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // 👇 4. Teks rute header dibuat dinamis 👇
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: widget.isOutbound
                                            ? 'Makassar '
                                            : 'Jeddah ',
                                        style: const TextStyle(
                                          color: AppColors.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      TextSpan(
                                        text: widget.isOutbound
                                            ? '- UPG'
                                            : '- JED',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.swap_horiz,
                                  color: Colors.blue,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: widget.isOutbound
                                            ? 'Jeddah '
                                            : 'Makassar ',
                                        style: const TextStyle(
                                          color: AppColors.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      TextSpan(
                                        text: widget.isOutbound
                                            ? '- JED'
                                            : '- UPG',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      height: 65,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 0,
                            right: 110,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Colors.white.withOpacity(0.0),
                                  ],
                                  stops: const [0.0, 1.0],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.1),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    displayDate,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '4 Dewasa, Ekonomi',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: -150,
                            top: -40,
                            child: TweenAnimationBuilder<Offset>(
                              tween: Tween<Offset>(
                                begin: const Offset(300, 0),
                                end: Offset.zero,
                              ),
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeOutQuart,
                              builder: (context, offset, child) {
                                return Transform.translate(
                                  offset: offset,
                                  child: child,
                                );
                              },
                              child: Image.asset(
                                'assets/images/plane.png',
                                width: 350,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterButton('💰', 'Termurah'),
                          const SizedBox(width: 10),
                          _buildFilterButton('🐯', 'Termahal'),
                          const SizedBox(width: 10),
                          _buildFilterButton('🎉', 'Promo'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  _buildRecommendationSection(
                    isLoading,
                    highlightedFlight,
                    otherFlights,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String emoji, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationSection(
    bool isLoading,
    FlightModel? highlightedFlight,
    List<FlightModel> otherFlights,
  ) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 1,
      ),
      padding: const EdgeInsets.only(bottom: 60),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 280,
                  child: Image.asset(
                    'assets/images/bg_flight_card_highlight.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 20.0,
                    right: 20.0,
                    bottom: 20.0,
                  ),
                  child: Column(
                    children: [
                      if (isLoading)
                        Column(
                          children: const [
                            FlightOptionCardTravel(
                              isLoading: true,
                              isHighlighted: true,
                            ),
                            SizedBox(height: 16),
                            FlightOptionCardTravel(
                              isLoading: true,
                              isHighlighted: false,
                            ),
                          ],
                        )
                      else if (highlightedFlight == null)
                        _buildEmptyState()
                      else
                        Column(
                          children: [
                            FlightOptionCardTravel(
                              flight: highlightedFlight,
                              isHighlighted: true,
                            ),
                            ...otherFlights
                                .map(
                                  (f) => Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: FlightOptionCardTravel(
                                      flight: f,
                                      isHighlighted: false,
                                    ),
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF005C99),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: const Text(
                'Tiket Rekomendasi',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.flight, size: 40, color: Color(0xFF005C99)),
          ),
          const SizedBox(height: 16),
          const Text(
            "Belum Ada Penerbangan",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Maaf, saat ini belum ada jadwal keberangkatan terdekat untuk rute dan tanggal yang Anda pilih.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
