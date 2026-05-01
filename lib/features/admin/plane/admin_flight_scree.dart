import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/providers/auth_provider.dart';
import 'package:yalla/core/providers/flight_provider.dart';
import 'package:yalla/core/utils/date_formatter.dart';
import 'package:yalla/core/widgets/button/admin_custom_bottom_nav_bar.dart';
import 'package:yalla/core/widgets/eror/error_state_widget.dart';
import 'package:yalla/features/admin/plane/admin_flight_form_screen.dart';
import 'package:yalla/features/admin/plane/flight_detail_screen.dart';

class AdminFlightScreen extends StatefulWidget {
  const AdminFlightScreen({super.key});

  @override
  State<AdminFlightScreen> createState() => _AdminFlightScreenState();
}

class _AdminFlightScreenState extends State<AdminFlightScreen> {
  int _selectedFilterIndex = 0;

  final List<String> _filters = [
    "Semua Penerbangan",
    "Dijadwalkan",
    "Tepat Waktu",
    "Terlambat",
    "Dibatalkan",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().fetchUserProfile();
      context.read<FlightProvider>().fetchFlights();
    });
  }

  String _determineFlightStatus(String? departureTimeIso) {
    if (departureTimeIso == null) return "Dijadwalkan";

    try {
      final now = DateTime.now();
      final departureDate = DateTime.parse(departureTimeIso).toLocal();

      if (now.isBefore(departureDate)) {
        return "Dijadwalkan";
      } else {
        return "Tepat Waktu";
      }
    } catch (e) {
      return "Dijadwalkan";
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final displayFirstName = authProvider.firstName.isNotEmpty
        ? authProvider.firstName
        : "Memuat...";
    final flightProvider = context.watch<FlightProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Background Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_admin_header.jpg'),
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    top: 0.0,
                    bottom: 20.0,
                  ),
                  child: _buildHeader(firstName: displayFirstName),
                ),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: _buildSearchBar(),
                        ),

                        const SizedBox(height: 20),

                        _buildFilterList(),

                        const SizedBox(height: 24),

                        Expanded(child: _buildFlightContent(flightProvider)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminFlightFormScreen(),
            ),
          ).then((_) {
            context.read<FlightProvider>().fetchFlights();
          });
        },
        backgroundColor: const Color(0xFF004CB9),
        shape: const CircleBorder(),
        elevation: 6,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      bottomNavigationBar: const CustomAdminBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildFlightContent(FlightProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF004CB9)),
      );
    }

    if (provider.errorMessage.isNotEmpty) {
      return ErrorStateWidget(
        errorMessage: provider.errorMessage,
        onRetry: () {
          context.read<FlightProvider>().fetchFlights();
        },
      );
    }

    if (provider.flights.isEmpty) {
      return const Center(
        child: Text(
          "Tidak ada jadwal penerbangan saat ini.",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 32.0),
      physics: const BouncingScrollPhysics(),
      itemCount: provider.flights.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final flight = provider.flights[index];
        final bool isOutbound = flight.isOutbound ?? true;

        final String originCode = isOutbound ? "UPG" : "JED";
        final String originName = isOutbound ? "Makassar" : "Jeddah";
        final String destCode = isOutbound ? "JED" : "UPG";
        final String destName = isOutbound ? "Jeddah" : "Makassar";

        final String calculatedStatus = _determineFlightStatus(
          flight.departureTime,
        );

        return _buildFlightCard(
          flightId: flight.id ?? "",
          flightNo: flight.flightNo ?? "Unknown",
          status: calculatedStatus,
          originCode: originCode,
          originName: originName,
          destCode: destCode,
          destName: destName,
          depTime: DateFormatter.formatTime(flight.departureTime),
          arrTime: DateFormatter.formatTime(flight.arrivalTime),
          depDate: DateFormatter.formatDate(flight.departureTime),
          arrDate: DateFormatter.formatDate(flight.arrivalTime),
          airlineLogoPath: 'assets/images/logo_flydeal.png',
        );
      },
    );
  }

  Widget _buildHeader({required String firstName}) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            image: const DecorationImage(
              image: AssetImage('assets/images/profile.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Selamat Datang,",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            Row(
              children: [
                Text(
                  firstName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 4),
                const Text("👋", style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
        const Spacer(),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.notifications_none,
                color: Color(0xFF004CB9),
                size: 24,
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Cari berdasarkan ID atau tujuan penerbangan",
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFilterList() {
    return SizedBox(
      height: 35,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedFilterIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilterIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF004CB9) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF004CB9)
                        : Colors.grey.shade300,
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    if (!isSelected && index != 0) ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getFilterDotColor(index),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      _filters[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getFilterDotColor(int index) {
    if (index == 1) return const Color(0xFF004CB9);
    if (index == 2) return const Color(0xFF4CAF50);
    if (index == 3) return Colors.orange;
    if (index == 4) return Colors.red;
    return Colors.transparent;
  }

  Widget _buildFlightCard({
    required String flightId,
    required String flightNo,
    required String status,
    required String originCode,
    required String originName,
    required String destCode,
    required String destName,
    required String depTime,
    required String depDate, // <--- Tambahan parameter baru
    required String arrTime,
    required String arrDate, // <--- Tambahan parameter baru
    required String airlineLogoPath,
  }) {
    Color statusBgColor = const Color(0xFFE8F5E9);
    Color statusTextColor = const Color(0xFF4CAF50);

    if (status == "Terlambat") {
      statusBgColor = Colors.orange.shade50;
      statusTextColor = Colors.orange;
    } else if (status == "Dibatalkan") {
      statusBgColor = Colors.red.shade50;
      statusTextColor = Colors.red;
    } else if (status == "Dijadwalkan") {
      statusBgColor = const Color(0xFFF0F8FF);
      statusTextColor = const Color(0xFF004CB9);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminFlightDetailScreen(flightId: flightId),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // ... (Bagian Header Maskapai dan Status Tetap Sama) ...
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(airlineLogoPath),
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
                        "ID Penerbangan",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        flightNo,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusTextColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusTextColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(color: Color(0xFFF0F0F0), height: 1),
            ),
            // ... (Bagian Rute UPG -> JED Tetap Sama) ...
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      originCode,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      originName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF0084FF),
                              width: 2,
                            ),
                          ),
                        ),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  (constraints.constrainWidth() / 6).floor(),
                                  (index) => SizedBox(
                                    width: 3,
                                    height: 1,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(
                            Icons.flight,
                            color: Color(0xFF004CB9),
                            size: 24,
                          ),
                        ),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  (constraints.constrainWidth() / 6).floor(),
                                  (index) => SizedBox(
                                    width: 3,
                                    height: 1,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF0084FF),
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
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      destName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- BAGIAN WAKTU DAN TANGGAL YANG DIPERBARUI ---
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Keberangkatan",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          depTime,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Menampilkan Tanggal Keberangkatan
                        Text(
                          depDate,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF004CB9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Kedatangan",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          arrTime,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Menampilkan Tanggal Kedatangan
                        Text(
                          arrDate,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF004CB9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
