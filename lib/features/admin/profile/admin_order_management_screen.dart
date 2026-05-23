import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/widgets/card/profile_card.dart';
import 'package:yalla/core/providers/order_provider.dart';
import 'package:yalla/core/models/order_model.dart';
import 'package:yalla/core/widgets/snackbar/custom_snackbar.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchOrders();
    });
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

  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status) {
      case 'waiting_payment':
        return {
          'text': 'Menunggu',
          'bgColor': const Color(0xFFFFF8E1),
          'textColor': Colors.orange,
        };
      case 'on_process':
        return {
          'text': 'Proses',
          'bgColor': const Color(0xFFE3F2FD),
          'textColor': Colors.blue,
        };
      case 'approved':
      case 'finished':
        return {
          'text': 'Selesai',
          'bgColor': const Color(0xFFE8F5E9),
          'textColor': const Color(0xFF4CAF50),
        };
      case 'postponed':
        return {
          'text': 'Ditunda',
          'bgColor': const Color(0xFFFFF3E0),
          'textColor': Colors.deepOrange,
        };
      default:
        return {
          'text': status,
          'bgColor': Colors.grey.shade100,
          'textColor': Colors.grey.shade600,
        };
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

  Map<String, List<OrderModel>> _groupOrders(List<OrderModel> orders) {
    final List<OrderModel> sortedList = List.from(orders);
    sortedList.sort((a, b) {
      if (a.createdAt.isEmpty) return 1;
      if (b.createdAt.isEmpty) return -1;
      try {
        return DateTime.parse(
          b.createdAt,
        ).compareTo(DateTime.parse(a.createdAt));
      } catch (_) {
        return 0;
      }
    });

    Map<String, List<OrderModel>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var order in sortedList) {
      if (order.createdAt.isEmpty) continue;
      try {
        final date = DateTime.parse(order.createdAt).toLocal();
        final orderDate = DateTime(date.year, date.month, date.day);
        String key;
        if (orderDate == today) {
          key = "Hari Ini";
        } else if (orderDate == yesterday) {
          key = "Kemarin";
        } else {
          key = _formatDateShort(order.createdAt);
        }
        grouped.putIfAbsent(key, () => []).add(order);
      } catch (e) {
        grouped.putIfAbsent("Lainnya", () => []).add(order);
      }
    }
    return grouped;
  }

  void _showOrderDetailModal(BuildContext context, OrderModel order) {
    final bool canApprove = order.status == 'on_process';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: canApprove
                            ? const Color(0xFFE3F2FD)
                            : const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        canApprove
                            ? Icons.check_circle_outline
                            : Icons.info_outline,
                        color: canApprove ? Colors.blue : Colors.orange,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        canApprove ? "Konfirmasi Pesanan" : "Detail Pesanan",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  canApprove
                      ? "Apakah Anda yakin ingin menyetujui pesanan ini?"
                      : "Pesanan ini tidak dapat disetujui karena statusnya bukan 'Proses'.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Kembali",
                          style: TextStyle(
                            color: Color(0xFF374151),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    if (canApprove) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(ctx);

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const PopScope(
                                canPop: false,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF0084FF),
                                  ),
                                ),
                              ),
                            );

                            try {
                              await context.read<OrderProvider>().approveOrder(
                                order.id,
                              );

                              if (context.mounted) {
                                Navigator.pop(context); 
                                CustomSnackBar.showSuccess(
                                  context,
                                  title: "Berhasil",
                                  message: "Pesanan berhasil disetujui.",
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                Navigator.pop(context); 
                                CustomSnackBar.showError(
                                  context,
                                  title: "Gagal",
                                  message: e.toString().replaceAll(
                                    "Exception: ",
                                    "",
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0084FF),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Setuju",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    final List<OrderModel> allOrders = provider.orders;
    final bool isLoading = provider.isLoading;

    List<OrderModel> displayOrders;
    if (_selectedFilterIndex == 0) {
      displayOrders = allOrders;
    } else if (_selectedFilterIndex == 1) {
      displayOrders = allOrders
          .where((o) => o.status == 'approved' || o.status == 'finished')
          .toList();
    } else if (_selectedFilterIndex == 2) {
      displayOrders = allOrders.where((o) => o.status == 'on_process').toList();
    } else {
      displayOrders = allOrders
          .where((o) => o.status == 'waiting_payment')
          .toList();
    }

    final groupedOrders = _groupOrders(displayOrders);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
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
                color: Color(0xFF0084FF),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const ProfileCard(),
                  const SizedBox(height: 24),
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
                          value: "${allOrders.length}",
                          trendValue: "78%",
                          icon: Icons.receipt_long_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFilters(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0084FF),
                      ),
                    )
                  : displayOrders.isEmpty
                  ? Center(
                      child: Text(
                        _selectedFilterIndex == 0
                            ? "Belum ada pesanan masuk"
                            : "Tidak ada pesanan dengan status ini",
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: groupedOrders.keys.length,
                      itemBuilder: (context, index) {
                        String dateKey = groupedOrders.keys.elementAt(index);
                        List<OrderModel> ordersForDate =
                            groupedOrders[dateKey]!;
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 16.0,
                              ),
                              child: Column(
                                children: ordersForDate.map((order) {
                                  return _buildOrderCard(order);
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final statusConfig = _getStatusConfig(order.status);
    final String shortBookingId = order.id.length > 5
        ? order.id.substring(0, 6).toUpperCase()
        : order.id.toUpperCase();

    final String bookingName = order.passengers.isNotEmpty
        ? (order.passengers.first.fullName ?? "Pesanan Tiket")
        : "Pesanan Tiket";

    final flight = order.flight ?? order.returnFlight;
    final bool isOutbound = flight?.isOutbound ?? true;
    final String routeText = isOutbound
        ? "Makassar (UPG) - Jeddah (JED)"
        : "Jeddah (JED) - Makassar (UPG)";
    final String depDate = _formatDateShort(flight?.departureTime);
    final bool isActive = order.status != 'postponed';

    return GestureDetector(
      onTap: () => _showOrderDetailModal(context, order),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16.0),
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
            // ── Header ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ),
                    if (isActive)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1CB002),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookingName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Booking ID: #BK - $shortBookingId",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusConfig['bgColor'],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusConfig['text'],
                    style: TextStyle(
                      color: statusConfig['textColor'],
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade100, thickness: 1.5),
            const SizedBox(height: 16),

            // ── Detail ──
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.flight_takeoff,
                      size: 16,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        routeText,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          depDate,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${order.passengers.length} Orang",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _formatPrice(order.price),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF007BFF),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
                  color: Color(0xFF004CB9),
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

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildFilterChip(0, "Semua Pesanan", Colors.white, Colors.black87),
          const SizedBox(width: 12),
          _buildStatusFilterChip(
            1,
            "Disetujui",
            "82",
            const Color(0xFFE8F5E9),
            const Color(0xFF4CAF50),
          ),
          const SizedBox(width: 12),
          _buildStatusFilterChip(
            2,
            "Proses",
            "67",
            const Color(0xFFF0F8FF),
            const Color(0xFF0084FF),
          ),
          const SizedBox(width: 12),
          _buildStatusFilterChip(
            3,
            "Menunggu",
            "12",
            const Color(0xFFFFF8E1),
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    int index,
    String label,
    Color selectedBg,
    Color unselectedText,
  ) {
    bool isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilterIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF004CB9) : selectedBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF004CB9) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : unselectedText,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusFilterChip(
    int index,
    String label,
    String count,
    Color bgColor,
    Color themeColor,
  ) {
    bool isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilterIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? themeColor : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: themeColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: themeColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              count,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
