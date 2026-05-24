import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/models/order_model.dart';
import 'package:yalla/core/providers/order_provider.dart';
import 'package:yalla/core/widgets/snackbar/custom_snackbar.dart';

class AdminOrderDetailScreen extends StatefulWidget {
  final OrderModel order;

  const AdminOrderDetailScreen({super.key, required this.order});

  @override
  State<AdminOrderDetailScreen> createState() => _AdminOrderDetailScreenState();
}

class _AdminOrderDetailScreenState extends State<AdminOrderDetailScreen> {
  late OrderModel _order;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  Map<String, String> _splitName(String fullName) {
    String first = "-";
    String middle = "-";
    String last = "-";

    List<String> names = fullName.trim().split(RegExp(r'\s+'));
    if (names.isNotEmpty && names[0].isNotEmpty) {
      first = names.first;
      if (names.length == 2) {
        last = names.last;
      } else if (names.length >= 3) {
        last = names.last;
        middle = names.sublist(1, names.length - 1).join(" ");
      }
    }
    return {"first": first, "middle": middle, "last": last};
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty || dateStr.startsWith("0001")) {
      return "-";
    }
    try {
      final date = DateTime.parse(dateStr).toLocal();
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

  void _confirmDeleteManifest() {
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
              // Header
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hapus Manifest",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Tindakan ini tidak dapat dibatalkan",
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

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.25)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        "File manifest e-tiket akan dihapus permanen dari pesanan ini.",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
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
                "Apakah Anda yakin ingin menghapus manifest pesanan ini? Anda dapat mengunggah ulang manifest setelahnya.",
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
                      onPressed: () async {
                        Navigator.pop(ctx);

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const PopScope(
                            canPop: false,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );

                        try {
                          await context.read<OrderProvider>().deleteManifest(
                            _order.id,
                          );

                          if (mounted) {
                            Navigator.pop(context);
                            setState(() {
                              _order = OrderModel(
                                id: _order.id,
                                buyerId: _order.buyerId,
                                status: _order.status,
                                email: _order.email,
                                phoneNumber: _order.phoneNumber,
                                departureFlightId: _order.departureFlightId,
                                returnFlightId: _order.returnFlightId,
                                price: _order.price,
                                createdAt: _order.createdAt,
                                updatedAt: _order.updatedAt,
                                payment: _order.payment,
                                passengers: _order.passengers,
                                flight: _order.flight,
                                returnFlight: _order.returnFlight,
                                manifestUrl: null,
                              );
                            });
                            CustomSnackBar.showSuccess(
                              context,
                              title: "Berhasil",
                              message: "Manifest berhasil dihapus.",
                            );
                          }
                        } catch (e) {
                          if (mounted) {
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
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Hapus",
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

  Future<void> _previewManifest() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
        ),
      ),
    );

    try {
      final bytes = await context.read<OrderProvider>().downloadManifest(
        _order.id,
      );

      final file = File(
        '${Directory.systemTemp.path}/manifest_${_order.id}.pdf',
      );
      await file.writeAsBytes(bytes);

      if (mounted) Navigator.pop(context);

      final result = await OpenFilex.open(file.path);

      if (result.type != ResultType.done) {
        if (mounted) {
          CustomSnackBar.showError(
            context,
            title: "Gagal",
            message: "Tidak ada aplikasi PDF di perangkat ini.",
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        CustomSnackBar.showError(
          context,
          title: "Gagal",
          message: e.toString().replaceAll("Exception: ", ""),
        );
      }
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 24.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF005BAC),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  Widget _buildPassengerCard(
    int index,
    PassengerModel passenger,
    String orderStatus,
  ) {
    final nameParts = _splitName(passenger.fullName);
    final String shortId = "#J-${passenger.id.substring(0, 4).toUpperCase()}";

    final bool isPaid = orderStatus != 'waiting_payment';
    final double progressValue = isPaid ? 1.0 : 0.0;
    final String progressText = isPaid ? "100% Dibayar" : "0% Dibayar";

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey.shade200,
                    child: const Icon(
                      Icons.person,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF004CB9),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          "$index",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                      passenger.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shortId,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Status Pembayaran:",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        Text(
                          progressText,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF005BAC),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Stack(
                      children: [
                        Container(
                          height: 6,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: progressValue,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFF005BAC),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          _buildSectionTitle("Data Diri"),
          Row(
            children: [
              Expanded(child: _buildInfoItem("Nama Awal", nameParts['first']!)),
              Expanded(
                child: _buildInfoItem("Nama Tengah", nameParts['middle']!),
              ),
              Expanded(child: _buildInfoItem("Nama Akhir", nameParts['last']!)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  "Tanggal Lahir",
                  _formatDate(passenger.dateOfBirth),
                ),
              ),
              Expanded(child: _buildInfoItem("Asal Negara", "Indonesia")),
            ],
          ),

          _buildSectionTitle("Informasi Paspor"),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  "Nomor Paspor",
                  passenger.passportNumber ?? "-",
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  "Tanggal Terbit",
                  _formatDate(passenger.passportIssueDate),
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  "Tanggal Berakhir",
                  _formatDate(passenger.passportExpiryDate),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF0084FF),
              size: 18,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Jamaah (${_order.passengers.length})",
          style: const TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: _order.manifestUrl != null && _order.status == 'approved'
            ? [
                IconButton(
                  onPressed: _previewManifest,
                  tooltip: "Lihat Manifest",
                  icon: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.visibility_outlined,
                      color: Color(0xFF4CAF50),
                      size: 18,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _confirmDeleteManifest,
                  tooltip: "Hapus Manifest",
                  icon: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFEBEE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ]
            : _order.manifestUrl != null && _order.status == 'finished'
            ? [
                IconButton(
                  onPressed: _previewManifest,
                  tooltip: "Lihat Manifest",
                  icon: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.visibility_outlined,
                      color: Color(0xFF4CAF50),
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ]
            : null,
      ),
      body: _order.passengers.isEmpty
          ? Center(
              child: Text(
                "Tidak ada data penumpang",
                style: TextStyle(color: Colors.grey.shade500),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _order.passengers.length,
              itemBuilder: (context, index) {
                return _buildPassengerCard(
                  index + 1,
                  _order.passengers[index],
                  _order.status,
                );
              },
            ),
    );
  }
}
