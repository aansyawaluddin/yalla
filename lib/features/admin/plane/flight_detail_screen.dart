import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/models/flight_model.dart';
import 'package:yalla/core/providers/flight_provider.dart';
import 'package:yalla/core/utils/date_formatter.dart';

class AdminFlightDetailScreen extends StatefulWidget {
  final String flightId; 

  const AdminFlightDetailScreen({super.key, required this.flightId});

  @override
  State<AdminFlightDetailScreen> createState() =>
      _AdminFlightDetailScreenState();
}

class _AdminFlightDetailScreenState extends State<AdminFlightDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FlightProvider>().fetchFlightDetail(widget.flightId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlightProvider>();
    final flight = provider.selectedFlight;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Detail Penerbangan",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF004CB9)),
            onPressed: () {
              // TODO: Aksi Edit
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFF0F0F0), height: 1.0),
        ),
      ),
      body: SafeArea(child: _buildBody(provider, flight)),
    );
  }

  Widget _buildBody(FlightProvider provider, FlightModel? flight) {
    if (provider.isDetailLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF004CB9)),
      );
    }

    if (provider.detailErrorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              provider.detailErrorMessage,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.fetchFlightDetail(widget.flightId),
              child: const Text("Coba Lagi"),
            ),
          ],
        ),
      );
    }

    if (flight == null) {
      return const Center(child: Text("Data penerbangan tidak ditemukan"));
    }
    final bool isOutbound = flight.isOutbound ?? true;
    final String rute = isOutbound
        ? "Makassar (UPG) → Jeddah (JED)"
        : "Jeddah (JED) → Makassar (UPG)";
    final int ecoClass = flight.economyClass ?? 0;
    final int busClass = flight.businessClass ?? 0;
    final int totalSeats = ecoClass + busClass;
    final String formattedDepTime = DateFormatter.formatTime(
      flight.departureTime,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFlightInfo(flight.flightNo ?? "Unknown"),
              const SizedBox(height: 24),
              _buildInfoGrid(formattedDepTime, totalSeats.toString()),
              const SizedBox(height: 24),
              _buildTabBar(),
              const SizedBox(height: 24),
            ],
          ),
        ),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const BouncingScrollPhysics(),
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildManifestContent(
                      flight.flightNo ?? "Unknown",
                      rute,
                      totalSeats,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),

              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [_buildLogContent(), const SizedBox(height: 40)],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFlightInfo(String flightNo) {
    return Row(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/images/logo_flydeal.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    flightNo,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F8FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Dijadwalkan",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004CB9),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "Boeing 737 -800 - Flydeal\nAirlines",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoGrid(String depTime, String totalSeats) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildInfoCard("Gate", "B12", null),
        _buildInfoCard("Kapasitas", totalSeats, null),
        _buildInfoCard("Fuel", "85%", Icons.local_gas_station),
        _buildInfoCard("Departure", depTime, null),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData? icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: Colors.green),
                const SizedBox(width: 4),
              ],
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF004CB9),
        unselectedLabelColor: Colors.grey.shade400,
        indicatorColor: const Color(0xFF004CB9),
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        tabs: const [
          Tab(text: "Manifest"),
          Tab(text: "Log"),
        ],
      ),
    );
  }

  Widget _buildManifestContent(String flightNo, String rute, int totalSeats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PENERBANGAN $flightNo",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rute,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "Tepat Waktu",
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),
        _buildBoardingProgress(totalSeats),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "List Penumpang",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              "Filter",
              style: TextStyle(
                fontSize: 12,
                color: Colors.lightBlue.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        _buildPassengerItem(
          name: "Muhammad Rafli Dahlan",
          seat: "Seat 12 - Ekonomi",
          status: "Boarded",
          time: "10:14 AM",
        ),
        const SizedBox(height: 16),
        _buildPassengerItem(
          name: "Syahdam Dahlan",
          seat: "Seat 13 - Ekonomi",
          status: "Boarded",
          time: "10:14 AM",
        ),
      ],
    );
  }

  Widget _buildBoardingProgress(int totalSeats) {
    int total = totalSeats > 0 ? totalSeats : 180;
    int boarded = (total * 0.9).toInt(); 
    int checkedIn = (total * 0.96).toInt();
    int remaining = total - boarded;
    double progress = boarded / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Boarding Progress",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "$boarded ",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004CB9),
                      ),
                    ),
                    TextSpan(
                      text: "/ $total",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    height: 8,
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      color: const Color(0xFF004CB9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Checked - In",
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "$checkedIn",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004CB9),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Remaining",
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "$remaining",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004CB9),
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

  Widget _buildPassengerItem({
    required String name,
    required String seat,
    required String status,
    required String time,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
            image: const DecorationImage(
              image: AssetImage('assets/images/passenger.png'),
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
                name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                seat,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, size: 12, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              time,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Riwayat Aktivitas",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F8FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Live Update",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004CB9),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        _buildTimelineItem(
          isFirst: true,
          isLast: false,
          icon: Icons.check,
          iconColor: Colors.white,
          circleColor: const Color(0xFF22C55E),
          title: "Boarding Started",
          titleColor: const Color(0xFF22C55E),
          description:
              "Panggilan pertama untuk business class dan priority. Tim mengonfirmasi bahwa cabin telah diperiksa dan aman.",
          timeInfo: "10:45 AM - Gate B12",
        ),

        _buildTimelineItem(
          isFirst: false,
          isLast: false,
          icon: Icons.local_gas_station_outlined,
          iconColor: Colors.white,
          circleColor: const Color(0xFF0267C1),
          title: "Refueling Complete",
          titleColor: const Color(0xFF0267C1),
          description:
              "Total 42.000L. Telah di verifikasi oleh departemen mesin.",
          timeInfo: "11:15 AM - Station 4",
        ),

        _buildTimelineItem(
          isFirst: false,
          isLast: true,
          icon: Icons.person_outline,
          iconColor: Colors.grey.shade600,
          circleColor: Colors.grey.shade300,
          title: "Pre-Flight Check",
          titleColor: Colors.grey.shade600,
          description: "Menunggu jadwal notifikasi wawancara",
          timeInfo: "",
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required bool isFirst,
    required bool isLast,
    required IconData icon,
    required Color iconColor,
    required Color circleColor,
    required String title,
    required Color titleColor,
    required String description,
    required String timeInfo,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 45,
            child: Column(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: circleColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: circleColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 1, color: Colors.grey.shade300),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: titleColor,
                          ),
                        ),
                      ),
                      if (timeInfo.isNotEmpty)
                        Text(
                          timeInfo,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade400,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: titleColor.withOpacity(0.9),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
