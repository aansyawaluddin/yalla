import 'package:flutter/material.dart';

class ErrorStateWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    String title = "Gagal Memuat Data";
    String displayMessage =
        "Ups, sepertinya terjadi gangguan koneksi. Silakan coba beberapa saat lagi.";

    if (errorMessage.contains("401")) {
      title = "Sesi Berakhir";
      displayMessage =
          "Sesi login Anda telah habis demi keamanan. Silakan login ulang untuk melanjutkan.";
    } else if (errorMessage.toLowerCase().contains("timeout") ||
        errorMessage.toLowerCase().contains("jaringan") ||
        errorMessage.toLowerCase().contains("socket")) {
      displayMessage =
          "Koneksi internet Anda sepertinya tidak stabil. Pastikan Anda terhubung ke internet dan coba lagi.";
    } else if (errorMessage.isNotEmpty) {
      displayMessage = "Kendala teknis: $errorMessage\nSilakan coba lagi.";
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lingkaran dengan Ikon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F8FF), 
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE0F0FF), width: 2),
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: Color(0xFF004CB9),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              displayMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: 200,
              height: 48,
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004CB9),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  "Coba Lagi",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
