import 'package:flutter/material.dart';
import 'package:yalla/core/models/order_model.dart';

class AdminOrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const AdminOrderDetailScreen({super.key, required this.order});

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

  // Widget _buildDocumentBadge(String label) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFE8FCEF),
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         const Icon(Icons.check, color: Color(0xFF16A34A), size: 14),
  //         const SizedBox(width: 6),
  //         Text(
  //           label,
  //           style: const TextStyle(
  //             color: Color(0xFF16A34A),
  //             fontWeight: FontWeight.bold,
  //             fontSize: 12,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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

          // _buildSectionTitle("Status Dokumen"),
          // Wrap(
          //   spacing: 12,
          //   runSpacing: 12,
          //   children: [
          //     _buildDocumentBadge("Paspor"),
          //     _buildDocumentBadge("Visa"),
          //     _buildDocumentBadge("Tiket"),
          //   ],
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
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
          "Jamaah (${order.passengers.length})",
          style: const TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: order.passengers.isEmpty
          ? Center(
              child: Text(
                "Tidak ada data penumpang",
                style: TextStyle(color: Colors.grey.shade500),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: order.passengers.length,
              itemBuilder: (context, index) {
                return _buildPassengerCard(
                  index + 1,
                  order.passengers[index],
                  order.status,
                );
              },
            ),
    );
  }
}
