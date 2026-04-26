import 'package:flutter/material.dart';
import 'package:yalla/core/widgets/card/profile_card.dart';

class AdminOrderManagementScreen extends StatefulWidget {
  const AdminOrderManagementScreen({super.key});

  @override
  State<AdminOrderManagementScreen> createState() =>
      _AdminOrderManagementScreenState();
}

class _AdminOrderManagementScreenState
    extends State<AdminOrderManagementScreen> {
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 8.0, bottom: 8.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF0084FF), // Biru panah
                size: 20,
              ),
            ),
          ),
        ),
        title: const Text(
          "Manajemen Pesanan",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // --- KONTEN ATAS (Statis) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // 1. Profile Card
                  const ProfileCard(),

                  const SizedBox(height: 24),

                  // 2. Summary Cards (Pendapatan & Pesanan)
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          title: "Pendapatan",
                          value: "182.000",
                          trendValue: "78%",
                          icon: Icons.account_balance_wallet_outlined,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          title: "Pesanan",
                          value: "72",
                          trendValue: "78%",
                          icon: Icons.receipt_long_outlined,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 3. Filter Chips
                  _buildFilters(),

                  const SizedBox(height: 16),
                ],
              ),
            ),

            // --- KONTEN BAWAH (Daftar Scrollable) ---
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  // Group: Hari Ini
                  _buildDateHeader("Hari Ini"),
                  _buildOrderItem(
                    name: "James Handerson",
                    bookingId: "#BK - 92374",
                    hotelName: "Hotel Borobudur Jakarta",
                    dateRange: "24 Okt - 26 Okt",
                    totalPrice: "IDR 11.000.000",
                    status: "Ditunda",
                  ),
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
                  _buildOrderItem(
                    name: "James Handerson",
                    bookingId: "#BK - 92374",
                    hotelName: "Hotel Borobudur Jakarta",
                    dateRange: "24 Okt - 26 Okt",
                    totalPrice: "IDR 11.000.000",
                    status: "Ditunda",
                  ),

                  // Group: Kemarin
                  _buildDateHeader("Kemarin"),
                  _buildOrderItem(
                    name: "James Handerson",
                    bookingId: "#BK - 92374",
                    hotelName: "Hotel Borobudur Jakarta",
                    dateRange: "24 Okt - 26 Okt",
                    totalPrice: "IDR 11.000.000",
                    status: "Ditunda",
                  ),
                  const SizedBox(height: 40), // Jarak aman scroll paling bawah
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Komponen: Summary Card ---
  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String trendValue,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004CB9), // Biru Yalla
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF004CB9),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14, color: Colors.white),
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
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004CB9),
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.trending_up,
                    color: Colors.greenAccent,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trendValue,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
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

  // --- Komponen: Filter Chips ---
  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          // Filter 1: Semua
          GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _selectedFilterIndex == 0
                    ? const Color(0xFF004CB9)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _selectedFilterIndex == 0
                      ? const Color(0xFF004CB9)
                      : Colors.grey.shade300,
                ),
              ),
              child: Text(
                "Semua Penerbangan",
                style: TextStyle(
                  color: _selectedFilterIndex == 0
                      ? Colors.white
                      : Colors.black87,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Filter 2: Disetujui
          GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = 1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _selectedFilterIndex == 1
                      ? const Color(0xFF4CAF50)
                      : Colors.transparent,
                ),
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
                    "Disetujui",
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "82",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Filter 3: Proses
          GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = 2),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F8FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _selectedFilterIndex == 2
                      ? const Color(0xFF0084FF)
                      : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0084FF),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "Proses",
                    style: TextStyle(
                      color: Color(0xFF0084FF),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "67",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Filter 4: Ditunda
          GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = 3),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1), // Kuning pudar
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _selectedFilterIndex == 3
                      ? Colors.orange
                      : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "Ditunda",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "12",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
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

  // --- Komponen: Date Header (Hari Ini / Kemarin) ---
  Widget _buildDateHeader(String title) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFAFAFA),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  // --- Komponen: Item List Pesanan ---
  Widget _buildOrderItem({
    required String name,
    required String bookingId,
    required String hotelName,
    required String dateRange,
    required String totalPrice,
    required String status,
  }) {
    // Logika pewarnaan badge status (Bisa ditambahkan status lain seperti Disetujui/Proses)
    Color badgeBgColor = const Color(
      0xFFFFF8E1,
    ); // Kuning pudar (Default Ditunda)
    Color badgeTextColor = Colors.orange;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Atas: Profil User & Badge Status
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/passenger.png',
                        ), // Sesuaikan asset
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
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
                      "Booking ID: $bookingId",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: badgeTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Bagian Tengah: Detail Pemesanan & Harga
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Kolom Info (Hotel & Tanggal)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        size: 16,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        hotelName,
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
                        dateRange,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Kolom Total Harga
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
                    totalPrice,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0084FF), // Biru Yalla
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
