import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/models/admin_stats_model.dart';
import 'package:yalla/core/providers/admin_stats_provider.dart';
import 'package:yalla/core/providers/auth_provider.dart';
import 'package:yalla/core/widgets/button/admin_custom_bottom_nav_bar.dart';
import 'package:yalla/features/admin/plane/admin_flight_scree.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().fetchUserProfile();
      context.read<AdminStatsProvider>().fetchStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final statsProvider = context.watch<AdminStatsProvider>();
    final stats = statsProvider.stats;
    final isLoading = statsProvider.isLoading;

    final displayFirstName = authProvider.firstName.isNotEmpty
        ? authProvider.firstName
        : "Memuat...";

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
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
                    bottom: 40.0,
                  ),
                  child: _buildHeader(firstName: displayFirstName),
                ),
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF004CB9),
                          ),
                        )
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Admin Dashboard",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF004CB9),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Travel Management System",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 24),

                              _buildSummaryCards(stats),

                              const SizedBox(height: 32),

                              const Text(
                                "Fitur Utama",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF004CB9),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Menampilkan sistem manajemen pesawat, hotel dan visa",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Expanded(
                                    child: _buildFeatureButton(
                                      Icons.flight,
                                      "Pesawat",
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AdminFlightScreen(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildFeatureButton(
                                      Icons.domain,
                                      "Hotel",
                                      () {},
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildFeatureButton(
                                      Icons.credit_card,
                                      "Visa",
                                      () {},
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 32),

                              _buildChartSection(stats.dailyOrders),

                              const SizedBox(height: 24),

                              _buildRecentOrders(stats.latestOrders),

                              const SizedBox(height: 24),
                              _buildPassengerTypeSection(),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomAdminBottomNavBar(currentIndex: 0),
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

  Widget _buildSummaryCards(AdminStatsModel stats) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: "Total Pesanan",
                value: stats.totalOrders.toString(),
                icon: Icons.receipt_long,
                isDark: true,
                trendValue: "12%",
                isTrendUp: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                title: "Total Jamaah",
                value: stats.totalJamaah.toString(),
                icon: Icons.people,
                isDark: false,
                trendValue: "12%",
                isTrendUp: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: "Travel Aktif",
                value: stats.totalTravel.toString(),
                icon: Icons.business_center,
                isDark: false,
                trendValue: "78%",
                isTrendUp: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                title: "Paket Tersedia",
                value: stats.totalPackages.toString(),
                icon: Icons.inventory_2,
                isDark: true,
                trendValue: "12%",
                isTrendUp: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required bool isDark,
    required String trendValue,
    required bool isTrendUp,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF003875), Color(0xFF001533)],
              )
            : null,
        color: isDark ? null : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF004CB9),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white : const Color(0xFF004CB9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 14,
                  color: isDark ? const Color(0xFF004CB9) : Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF004CB9),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Icon(
                    isTrendUp ? Icons.trending_up : Icons.trending_down,
                    color: isTrendUp ? Colors.greenAccent : Colors.redAccent,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trendValue,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isTrendUp ? Colors.greenAccent : Colors.redAccent,
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

  Widget _buildFeatureButton(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
            Icon(icon, color: const Color(0xFF004CB9), size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004CB9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(List<DailyOrderModel> dailyOrders) {
    return Container(
      width: double.infinity,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pemesan Perbulan",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004CB9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Menampilkan pemesan harian",
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF004CB9),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Pesanan\nHarian",
                    style: TextStyle(fontSize: 10, color: Color(0xFF004CB9)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          SizedBox(
            height: 120,
            width: double.infinity,
            child: dailyOrders.isEmpty
                ? Center(
                    child: Text(
                      "Belum ada data",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  )
                : CustomPaint(
                    size: const Size(double.infinity, 120),
                    painter: DailyOrderChartPainter(dailyOrders: dailyOrders),
                  ),
          ),

          const SizedBox(height: 16),

          if (dailyOrders.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: dailyOrders.take(7).map((d) {
                final parts = d.date.split('-');
                final label = parts.length >= 3
                    ? "${parts[2]}/${parts[1]}"
                    : d.date;
                return Text(
                  label,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  [
                    "Jan",
                    "Feb",
                    "Mar",
                    "Apr",
                    "Mei",
                    "Jun",
                    "Jul",
                    "Agu",
                    "Sep",
                    "Okt",
                    "Nov",
                    "Des",
                  ].map((bulan) {
                    return Text(
                      bulan,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentOrders(List<LatestOrderModel> latestOrders) {
    return Container(
      width: double.infinity,
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
                    const Text(
                      "Pemesanan Terbaru",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004CB9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Menampilkan ${latestOrders.length} pesanan terakhir.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (latestOrders.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Belum ada pesanan.",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                ),
              ),
            )
          else
            ...latestOrders.map((order) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildOrderItem(order: order),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildOrderItem({required LatestOrderModel order}) {
    Color statusColor;
    String statusLabel;
    Color statusBg;

    switch (order.status) {
      case 'waiting_payment':
        statusColor = Colors.orange;
        statusBg = Colors.orange.withOpacity(0.1);
        statusLabel = "Belum Bayar";
        break;
      case 'on_process':
        statusColor = const Color(0xFF0084FF);
        statusBg = const Color(0xFFEFF6FF);
        statusLabel = "Verifikasi";
        break;
      case 'approved':
        statusColor = Colors.green;
        statusBg = const Color(0xFFE8F5E9);
        statusLabel = "Dikonfirmasi";
        break;
      case 'finished':
        statusColor = const Color(0xFF3730A3);
        statusBg = const Color(0xFFEDE9FE);
        statusLabel = "Selesai";
        break;
      default:
        statusColor = Colors.grey;
        statusBg = Colors.grey.withOpacity(0.1);
        statusLabel = order.status;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Icon kiri
          Container(
            width: 60,
            height: 55,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: Center(
              child: Icon(
                order.isPackage ? Icons.mosque : Icons.flight,
                color: const Color(0xFF004CB9),
                size: 24,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.isPackage
                        ? order.packageName
                        : "Flydeal Air ${order.flightNo}",
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        order.email,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (order.passengerCount > 0) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            Icons.circle,
                            size: 4,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        Text(
                          "${order.passengerCount} Pax",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                statusLabel,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerTypeSection() {
    return Container(
      width: double.infinity,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Jenis Penumpang",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004CB9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Menampilkan distribusi kategori penumpang berdasarkan tipe perjalanan pada rute Makassar – Jeddah.",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          _buildProgressBar(title: "Individu", percentage: 75),
          const SizedBox(height: 20),
          _buildProgressBar(title: "Keluarga", percentage: 80),
        ],
      ),
    );
  }

  Widget _buildProgressBar({required String title, required int percentage}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              "$percentage%",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
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
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: 6,
                  width: constraints.maxWidth * (percentage / 100),
                  decoration: BoxDecoration(
                    color: const Color(0xFF004CB9),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class DailyOrderChartPainter extends CustomPainter {
  final List<DailyOrderModel> dailyOrders;

  DailyOrderChartPainter({required this.dailyOrders});

  @override
  void paint(Canvas canvas, Size size) {
    if (dailyOrders.isEmpty) return;

    final maxCount = dailyOrders
        .map((e) => e.count)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    if (maxCount == 0) return;

    final paint = Paint()
      ..color = const Color(0xFF0084FF)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final total = dailyOrders.length;

    for (int i = 0; i < total; i++) {
      final x = (i / (total - 1)) * size.width;
      final y = size.height - (dailyOrders[i].count / maxCount) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    int peakIndex = 0;
    for (int i = 1; i < total; i++) {
      if (dailyOrders[i].count > dailyOrders[peakIndex].count) {
        peakIndex = i;
      }
    }

    final peakX = (peakIndex / (total - 1)) * size.width;
    final peakY =
        size.height - (dailyOrders[peakIndex].count / maxCount) * size.height;

    final dotBgPaint = Paint()..color = const Color(0xFFD4EEFF);
    final dotPaint = Paint()..color = const Color(0xFF0084FF);
    canvas.drawCircle(Offset(peakX, peakY), 7, dotBgPaint);
    canvas.drawCircle(Offset(peakX, peakY), 3.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
