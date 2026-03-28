import 'package:flutter/material.dart';

class JamaahDetailScreen extends StatelessWidget {
  final String jamaahName;
  final String jamaahId;

  const JamaahDetailScreen({
    super.key,
    required this.jamaahName,
    required this.jamaahId,
  });

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          "Detail Jamaah",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Foto Profil
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/profile.png',
                      ), // Sesuaikan asset
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Nama, ID, dan Progress Bar
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Saldan Rafli Shalihin",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "#J-0814",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Progress Bar Status Pembayaran
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Status Pembayaran:",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            "74% Dibayar",
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF005C99), // Biru gelap
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: 0.74, // 74%
                        backgroundColor: Colors.grey.shade200,
                        color: const Color(0xFF005C99),
                        minHeight: 4,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            _buildSectionTitle("Data Diri"),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildInfoItem("Nama Awal", "Saldan")),
                Expanded(child: _buildInfoItem("Nama Tengah", "Rafli")),
                Expanded(child: _buildInfoItem("Nama Akhir", "Shalihin")),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildInfoItem("Tanggal Lahir", "28 Agustus 2004"),
                ),
                Expanded(child: _buildInfoItem("Jenis Kelamin", "Laki - laki")),
                Expanded(child: _buildInfoItem("Asal Negara", "Indonesia")),
              ],
            ),

            const SizedBox(height: 32),

            _buildSectionTitle("Informasi Paspor"),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildInfoItem("Nomor Paspor", "8320912384")),
                Expanded(
                  child: _buildInfoItem("Tanggal Terbit", "18 Mei 2023"),
                ),
                Expanded(
                  child: _buildInfoItem("Tanggal Berakhir", "18 Mei 2027"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildInfoItem("Asal Negara", "Indonesia")),
              ],
            ),

            const SizedBox(height: 32),

            _buildSectionTitle("Status Dokumen"),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12, 
              runSpacing: 12, 
              children: [
                _buildDocumentBadge("Paspor"),
                _buildDocumentBadge("Visa"),
                _buildDocumentBadge("Tiket"),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF005C99), 
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
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8FAED),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check,
            color: Color(0xFF10B981),
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }
}
