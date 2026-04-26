import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/widgets/button/admin_custom_bottom_nav_bar.dart';
import 'package:yalla/features/auth/providers/auth_provider.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final displayFirstName = authProvider.firstName.isNotEmpty
        ? authProvider.firstName
        : "Memuat...";
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Background Tetap (Fixed)
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

                // Area Konten yang Bisa Di-scroll
                Expanded(
                  child: SingleChildScrollView(
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

                        _buildSummaryCards(),

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
                          "Menampilkan sistem manajemen pesawat, hotel dan\nvisa",
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
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildFeatureButton(Icons.domain, "Hotel"),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildFeatureButton(
                                Icons.credit_card,
                                "Visa",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        _buildChartSection(),

                        const SizedBox(height: 24),
                        _buildRecentOrders(),

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

  Widget _buildSummaryCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: "Total Pesanan",
                value: "1.273",
                icon: Icons.receipt_long,
                isDark: true,
                trendValue: "12%",
                isTrendUp: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                title: "Pengguna Aktif",
                value: "383",
                icon: Icons.people,
                isDark: false,
                trendValue: "12%",
                isTrendUp: false,
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
                value: "182.000",
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
                value: "81",
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
                colors: [
                  Color(0xFF003875),
                  Color(0xFF001533),
                ], // Biru sangat gelap
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
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF004CB9),
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

  Widget _buildFeatureButton(IconData icon, String title) {
    return Container(
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
    );
  }

  Widget _buildChartSection() {
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
                    "Menampilkan pemesan 7 hari terakhir",
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
                    "Pemesan\nPerbulan",
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
            child: CustomPaint(
              size: const Size(double.infinity, 120),
              painter: MockLineChartPainter(),
            ),
          ),

          const SizedBox(height: 16),

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

  Widget _buildRecentOrders() {
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
          // Header: Judul & Lihat Semua
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
                        color: Color(0xFF004CB9), // Biru gelap
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Menampilkan 3 pesanan terakhir.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                "Lihat Semua",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0084FF),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Daftar Pesanan
          _buildOrderItem(
            hotelName: "Hotel Jakarta Borobudur",
            customerName: "Muhammad Fauzan",
            timeAgo: "2 Jam Lalu",
            status: "Dikonfirmasi",
            imageAsset: 'assets/images/hotel_bg.jpg',
          ),
          const SizedBox(height: 12),
          _buildOrderItem(
            hotelName: "Hotel Jakarta Borobudur",
            customerName: "Muhammad Fauzan",
            timeAgo: "2 Jam Lalu",
            status: "Dikonfirmasi",
            imageAsset: 'assets/images/hotel_bg.jpg',
          ),
          const SizedBox(height: 12),
          _buildOrderItem(
            hotelName: "Hotel Jakarta Borobudur",
            customerName: "Muhammad Fauzan",
            timeAgo: "2 Jam Lalu",
            status: "Dikonfirmasi",
            imageAsset: 'assets/images/hotel_bg.jpg',
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem({
    required String hotelName,
    required String customerName,
    required String timeAgo,
    required String status,
    required String imageAsset,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Gambar di sisi kiri
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            child: Container(
              width: 70,
              height: 55,
              color: Colors.grey.shade300,
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
                    hotelName,
                    style: const TextStyle(
                      fontSize: 10,
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
                        customerName,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(
                          Icons.circle,
                          size: 4,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4CAF50), // Hijau
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

          // Progress Bar: Individu
          _buildProgressBar(title: "Individu", percentage: 75),

          const SizedBox(height: 20),

          // Progress Bar: Keluarga
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
        // Layout Progress Bar
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
                    color: const Color(0xFF004CB9), // Biru gelap
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

class MockLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0084FF)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    path.moveTo(0, size.height * 0.8);
    path.lineTo(size.width * 0.1, size.height * 0.5);
    path.lineTo(size.width * 0.2, size.height * 0.7);
    path.lineTo(size.width * 0.35, size.height * 0.4);
    path.lineTo(size.width * 0.45, size.height * 0.6);
    path.lineTo(size.width * 0.6, size.height * 0.2);
    path.lineTo(size.width * 0.65, size.height * 0.4);

    final peakX = size.width * 0.78;
    final peakY = size.height * 0.05;
    path.lineTo(peakX, peakY);

    path.lineTo(size.width, size.height * 0.3);

    canvas.drawPath(path, paint);

    final dashPaint = Paint()
      ..color = const Color(0xFF0084FF).withOpacity(0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    double dashY = peakY + 8;
    while (dashY < size.height) {
      canvas.drawLine(
        Offset(peakX, dashY),
        Offset(peakX, dashY + 4),
        dashPaint,
      );
      dashY += 8;
    }

    final dotPaint = Paint()..color = const Color(0xFF0084FF);
    final dotBgPaint = Paint()..color = const Color(0xFFD4EEFF);

    final dotCenter = Offset(peakX, peakY);
    canvas.drawCircle(dotCenter, 7, dotBgPaint);
    canvas.drawCircle(dotCenter, 3.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
