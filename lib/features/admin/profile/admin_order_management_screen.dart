import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:yalla/core/models/flight_model.dart';
import 'package:yalla/core/widgets/card/profile_card.dart';
import 'package:yalla/core/providers/order_provider.dart';
import 'package:yalla/core/models/order_model.dart';
import 'package:yalla/core/widgets/snackbar/custom_snackbar.dart';
import 'package:yalla/features/admin/profile/admin_order_detail_screen.dart';

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
        return {
          'text': 'Disetujui',
          'bgColor': const Color(0xFFE8F5E9),
          'textColor': const Color(0xFF4CAF50),
        };
      case 'finished':
        return {
          'text': 'Selesai',
          'bgColor': const Color(0xFFEEF2FF),
          'textColor': const Color(0xFF3730A3),
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

  String _formatPriceShort(num price) {
    if (price >= 1000000000) {
      final val = (price / 1000000000);
      final str = val == val.truncate()
          ? val.toInt().toString()
          : val.toStringAsFixed(1);
      return "${str}M";
    } else if (price >= 1000000) {
      final val = (price / 1000000);
      final str = val == val.truncate()
          ? val.toInt().toString()
          : val.toStringAsFixed(1);
      return "${str}Jt";
    } else if (price >= 1000) {
      final val = (price / 1000);
      final str = val == val.truncate()
          ? val.toInt().toString()
          : val.toStringAsFixed(1);
      return "${str}Rb";
    }
    return price.toInt().toString();
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

  void _showManifestUploadModal(BuildContext context, OrderModel order) {
    File? selectedFile;
    String? selectedFileName;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                24 + MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.upload_file_outlined,
                          color: Color(0xFF4CAF50),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Upload Manifest",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Unggah file manifest e-tiket untuk pesanan ini",
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
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

                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );
                      if (result != null && result.files.single.path != null) {
                        setModalState(() {
                          selectedFile = File(result.files.single.path!);
                          selectedFileName = result.files.single.name;
                        });
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      decoration: BoxDecoration(
                        color: selectedFile != null
                            ? const Color(0xFFF0FFF4)
                            : const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selectedFile != null
                              ? const Color(0xFF4CAF50)
                              : Colors.grey.shade300,
                          width: selectedFile != null ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            selectedFile != null
                                ? Icons.insert_drive_file_rounded
                                : Icons.cloud_upload_outlined,
                            size: 36,
                            color: selectedFile != null
                                ? const Color(0xFF4CAF50)
                                : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            selectedFile != null
                                ? selectedFileName ?? "File dipilih"
                                : "Ketuk untuk memilih file",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: selectedFile != null
                                  ? const Color(0xFF2E7D32)
                                  : Colors.grey.shade500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            selectedFile != null
                                ? "Ketuk untuk mengganti file"
                                : "PDF only",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
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
                            "Batal",
                            style: TextStyle(
                              color: Color(0xFF374151),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: selectedFile == null
                              ? null
                              : () async {
                                  Navigator.pop(ctx);

                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => const PopScope(
                                      canPop: false,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF4CAF50),
                                        ),
                                      ),
                                    ),
                                  );

                                  try {
                                    await context
                                        .read<OrderProvider>()
                                        .uploadManifest(
                                          order.id,
                                          selectedFile!,
                                        );

                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      CustomSnackBar.showSuccess(
                                        context,
                                        title: "Berhasil",
                                        message: "Manifest berhasil diunggah.",
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
                            backgroundColor: const Color(0xFF4CAF50),
                            disabledBackgroundColor: Colors.grey.shade200,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Upload",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showFinishOrderModal(BuildContext context, OrderModel order) {
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
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.check_circle_outline_rounded,
                      color: Color(0xFF4CAF50),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Selesaikan Pesanan",
                      style: TextStyle(
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

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FFF4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF4CAF50).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.task_alt_rounded,
                      color: Color(0xFF4CAF50),
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        "Manifest e-tiket sudah tersedia untuk pesanan ini.",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Apakah Anda yakin ingin menyelesaikan pesanan ini? Status pesanan akan berubah menjadi selesai.",
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
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                          ),
                        );

                        try {
                          await context.read<OrderProvider>().finishOrder(
                            order.id,
                          );

                          if (context.mounted) {
                            Navigator.pop(context);
                            CustomSnackBar.showSuccess(
                              context,
                              title: "Berhasil",
                              message: "Pesanan berhasil diselesaikan.",
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
                        backgroundColor: const Color(0xFF4CAF50),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Selesaikan",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOrderDetailModal(BuildContext context, OrderModel order) {
    if (order.status == 'finished') {
      return;
    }
    if (order.status == 'approved') {
      if (order.manifestUrl != null) {
        _showFinishOrderModal(context, order);
      } else {
        _showManifestUploadModal(context, order);
      }
      return;
    }

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
      displayOrders = allOrders.where((o) => o.status == 'finished').toList();
    } else if (_selectedFilterIndex == 2) {
      displayOrders = allOrders.where((o) => o.status == 'approved').toList();
    } else if (_selectedFilterIndex == 3) {
      displayOrders = allOrders.where((o) => o.status == 'on_process').toList();
    } else {
      displayOrders = allOrders
          .where((o) => o.status == 'waiting_payment')
          .toList();
    }

    final groupedOrders = _groupOrders(displayOrders);

    final approvedAndFinished = allOrders
        .where((o) => o.status == 'approved' || o.status == 'finished')
        .toList();

    final totalPendapatan = approvedAndFinished.fold<num>(
      0,
      (sum, o) => sum + o.price,
    );

    final totalPesanan = allOrders.length;
    final completedCount = approvedAndFinished.length;
    final completedPercent = totalPesanan > 0
        ? ((completedCount / totalPesanan) * 100).toStringAsFixed(0)
        : "0";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        leadingWidth: 70,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF005C99),
              size: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
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
                          value: _formatPriceShort(totalPendapatan),
                          trendValue: "${approvedAndFinished.length} order",
                          icon: Icons.account_balance_wallet_outlined,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          title: "Pesanan",
                          value: "$totalPesanan",
                          trendValue: "$completedPercent%",
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
        ? order.passengers.first.fullName
        : "Pesanan Tiket";

    final bool isPackageOrder = order.package != null;
    final bool isActive = order.status != 'postponed';

    final flight =
        order.package?.departureFlight ??
        order.package?.returnFlight ??
        order.flight ??
        order.returnFlight;
    final FlightModel? returnFlight = order.package?.returnFlight;

    final bool isOutbound = flight?.isOutbound ?? true;
    final String routeText = isPackageOrder
        ? "Makassar (UPG) - Jeddah (JED)"
        : isOutbound
        ? "Makassar (UPG) - Jeddah (JED)"
        : "Jeddah (JED) - Makassar (UPG)";
    final String depDate = _formatDateShort(flight?.departureTime);
    final String retDate = isPackageOrder
        ? _formatDateShort(returnFlight?.departureTime)
        : "-";

    return GestureDetector(
      onTap: () => _showOrderDetailModal(context, order),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPackageOrder
                ? const Color(0xFF0084FF).withOpacity(0.25)
                : Colors.grey.shade200,
            width: isPackageOrder ? 1.5 : 1.0,
          ),
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
            if (isPackageOrder)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F8FF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.mosque,
                      size: 13,
                      color: Color(0xFF0084FF),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        order.package?.packageName ?? "Paket Umrah",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0084FF),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0084FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${order.package?.durationDays ?? 0} Hari",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0084FF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
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
                          if (order.status == 'approved' ||
                              order.status == 'finished') ...[
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  order.manifestUrl != null
                                      ? Icons.task_alt_rounded
                                      : Icons.upload_file_outlined,
                                  size: 11,
                                  color: order.manifestUrl != null
                                      ? const Color(0xFF4CAF50)
                                      : Colors.orange,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  order.manifestUrl != null
                                      ? "Manifest"
                                      : "Belum ada manifest",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: order.manifestUrl != null
                                        ? const Color(0xFF4CAF50)
                                        : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.shade100, thickness: 1.5),
                  const SizedBox(height: 12),

                  if (isPackageOrder) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.flight_takeoff,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            "Makassar (UPG) → Jeddah (JED)",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Row(
                        children: [
                          Text(
                            depDate,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          if (flight?.flightNo != null) ...[
                            Text(
                              "  •  ",
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                            Text(
                              flight!.flightNo!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF0084FF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.flight_land,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            "Jeddah (JED) → Makassar (UPG)",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Row(
                        children: [
                          Text(
                            retDate,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          if (returnFlight?.flightNo != null) ...[
                            Text(
                              "  •  ",
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                            Text(
                              returnFlight!.flightNo!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF7C3AED),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Icon(
                          isOutbound ? Icons.flight_takeoff : Icons.flight_land,
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
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Row(
                        children: [
                          Text(
                            depDate,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          if (flight?.flightNo != null) ...[
                            Text(
                              "  •  ",
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                            Text(
                              flight!.flightNo!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF0084FF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],

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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.bold,
                            ),
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

                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminOrderDetailScreen(order: order),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F5FF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF004CB9).withOpacity(0.2),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 13,
                              color: Color(0xFF004CB9),
                            ),
                            SizedBox(width: 6),
                            Text(
                              "Detail Passenger",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF004CB9),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 10,
                              color: Color(0xFF004CB9),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
    final provider = context.read<OrderProvider>();
    final allOrders = provider.orders;

    final finishedCount = allOrders.where((o) => o.status == 'finished').length;
    final approvedCount = allOrders.where((o) => o.status == 'approved').length;
    final processCount = allOrders
        .where((o) => o.status == 'on_process')
        .length;
    final waitingCount = allOrders
        .where((o) => o.status == 'waiting_payment')
        .length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildFilterChip(0, "Semua Pesanan", Colors.white, Colors.black87),
          const SizedBox(width: 12),
          _buildStatusFilterChip(
            1,
            "Selesai",
            "$finishedCount",
            const Color(0xFFEEF2FF),
            const Color(0xFF3730A3),
          ),
          const SizedBox(width: 12),
          _buildStatusFilterChip(
            2,
            "Disetujui",
            "$approvedCount",
            const Color(0xFFE8F5E9),
            const Color(0xFF4CAF50),
          ),
          const SizedBox(width: 12),
          _buildStatusFilterChip(
            3,
            "Proses",
            "$processCount",
            const Color(0xFFF0F8FF),
            const Color(0xFF0084FF),
          ),
          const SizedBox(width: 12),
          _buildStatusFilterChip(
            4,
            "Menunggu",
            "$waitingCount",
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
