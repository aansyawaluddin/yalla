import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yalla/core/widgets/card/profile_card.dart';

class SavedDocumentScreen extends StatelessWidget {
  const SavedDocumentScreen({super.key});

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
          "Dokumen Tersimpan",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileCard(),

            const SizedBox(height: 32),

            const Text(
              "Data Diri",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTextField("Nama Depan")),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField("Nama Belakang")),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField("Tanggal Lahir"),
            const SizedBox(height: 16),
            _buildCountrySelector(),

            const SizedBox(height: 32),

            const Text(
              "Informasi Paspor",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField("Nomor Paspor"),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTextField("Tanggal Terbit")),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField("Masa Berlaku")),
              ],
            ),

            const SizedBox(height: 32),

            // --- BAGIAN MASUKKAN DOKUMEN ---
            const Text(
              "Masukkan Dokumen",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            _buildUploadSection("Foto Paspor (Halaman Biodata)"),
            const SizedBox(height: 24),
            _buildUploadSection("Pas Foto Terbaru (4.5 x 3.5 Cm)"),
            const SizedBox(height: 24),
            _buildUploadSection("Bukti Pemesanan Hotel"),
            const SizedBox(height: 24),
            _buildUploadSection("Tiket Pesawat Pulang Pergi"),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: TextFormField(
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildCountrySelector() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Expanded(child: Container(color: Colors.red)),
                Expanded(child: Container(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Indonesia",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
        ],
      ),
    );
  }

  Widget _buildUploadSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54, 
              fontWeight: FontWeight.w500,
            ),
            children: const [
              TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildUploadBox(
                icon: Icons.camera_alt,
                label: "Ambil Foto",
                onTap: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildUploadBox(
                icon: Icons.photo_library,
                label: "Galeri",
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadBox({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: DashedRectPainter(
          color: Colors.grey.shade300,
          strokeWidth: 1,
          gap: 5.0,
        ),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F9FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFF0066CC), size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF0066CC),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(8),
        ),
      );

    Path dashedPath = Path();
    double distance = 0.0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashedPath.addPath(
          pathMetric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2;
      }
      distance = 0.0; 
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
