import 'package:flutter/material.dart';
import 'package:yalla/features/travel/profile/jamaah_detail_screen.dart';

class BatchDetailScreen extends StatelessWidget {
  final String batchName;

  const BatchDetailScreen({super.key, required this.batchName});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> jamaahList = [
      {"name": "Raules Sinagar", "id": "#J-0184", "status": "Lunas"},
      {"name": "Raules Sinagar", "id": "#J-0184", "status": "Lunas"},
      {"name": "Raules Sinagar", "id": "#J-0184", "status": "Lunas"},
      {"name": "Raules Sinagar", "id": "#J-0184", "status": "Lunas"},
      {"name": "Raules Sinagar", "id": "#J-0184", "status": "Cicilan"},
      {"name": "Raules Sinagar", "id": "#J-0184", "status": "DP"},
      {"name": "Raules Sinagar", "id": "#J-0184", "status": "Cicilan"},
      {"name": "Raules Sinagar", "id": "#J-0184", "status": "DP"},
      {"name": "Raules Sinagar", "id": "#J-0184", "status": "Lunas"},
      {"name": "Raules Sinagar", "id": "#J-0184", "status": "Lunas"},
      {"name": "Raules Sinagar", "id": "#J-0184", "status": "Cicilan"},
      {"name": "Raules Sinagar", "id": "#J-0184", "status": "DP"},
      {"name": "Raules Sinagar", "id": "#J-0184", "status": "Cicilan"},
      {"name": "Raules Sinagar", "id": "#J-0184", "status": "DP"},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 8, bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF0084FF),
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          batchName.replaceAll("BATCH", "Batch"),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        isDense: true,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.black87,
                          size: 20,
                        ),
                        hintText: "Cari Jamaah",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () {
                    // Aksi filter
                  },
                  icon: const Icon(Icons.tune, color: Colors.black87),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              itemCount: jamaahList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final data = jamaahList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JamaahDetailScreen(
                          jamaahName: data['name'],
                          jamaahId: data['id'],
                        ),
                      ),
                    );
                  },
                  child: _buildJamaahCard(
                    name: data['name'],
                    id: data['id'],
                    status: data['status'],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJamaahCard({
    required String name,
    required String id,
    required String status,
  }) {
    Color badgeBgColor;
    Color badgeTextColor;

    switch (status.toLowerCase()) {
      case 'lunas':
        badgeBgColor = const Color(0xFFE8FAED);
        badgeTextColor = const Color(0xFF10B981);
        break;
      case 'cicilan':
        badgeBgColor = const Color(0xFFFFF1E6);
        badgeTextColor = const Color(0xFFF97316);
        break;
      case 'dp':
        badgeBgColor = const Color(0xFFE0F2FE);
        badgeTextColor = const Color(0xFF3B82F6);
        break;
      default:
        badgeBgColor = Colors.grey.shade100;
        badgeTextColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Foto Profil Jamaah
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/profile.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Nama & ID Jamaah
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  id,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          // Badge Status Pembayaran
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: badgeBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: badgeTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
