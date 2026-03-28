import 'package:flutter/material.dart';
import 'package:yalla/core/widgets/card/profile_card.dart';

class PaymentMethodScreenTravel extends StatelessWidget {
  const PaymentMethodScreenTravel({super.key});

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
                color: Color(0xFF0084FF), // Biru panah
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          "Metode Pembayaran",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: ProfileCard(),
            ),

            const SizedBox(height: 32),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Pembayaran yang disimpan",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildPaymentMethodItem(
              icon: Icons.account_balance_wallet_outlined,
              iconColor: const Color(0xFF10B981),
              iconBgColor: const Color(0xFFE8FAED),
              title: "Dompet Digital",
              trailingLogos: [
                _buildLogo(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/8/86/Gopay_logo.svg/256px-Gopay_logo.svg.png',
                ),
                _buildLogo(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Logo_dana_blue.svg/256px-Logo_dana_blue.svg.png',
                ),
              ],
              onTap: () {
                // Navigasi ke detail Dompet Digital
              },
            ),

            const Divider(height: 1, color: Color(0xFFF3F4F6)),

            _buildPaymentMethodItem(
              icon: Icons.account_balance_outlined,
              iconColor: const Color(0xFF0066CC),
              iconBgColor: const Color(0xFFF4F9FF),
              title: "Debit Instan",
              trailingLogos: [
                _buildLogo(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/Bank_Mandiri_logo_2016.svg/256px-Bank_Mandiri_logo_2016.svg.png',
                ),
                _buildLogo(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2e/BRI_2020.svg/256px-BRI_2020.svg.png',
                ),
                _buildLogo(
                  'https://upload.wikimedia.org/wikipedia/id/thumb/5/55/BNI_logo.svg/256px-BNI_logo.svg.png',
                ),
              ],
              onTap: () {
                // Navigasi ke detail Debit Instan
              },
            ),

            const Divider(height: 1, color: Color(0xFFF3F4F6)),

            _buildPaymentMethodItem(
              icon: Icons.credit_card_outlined,
              iconColor: const Color(0xFFF97316),
              iconBgColor: const Color(0xFFFFF7ED),
              title: "Kartu Saya",
              trailingLogos: [
                _buildLogo(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Visa_Inc._logo.svg/256px-Visa_Inc._logo.svg.png',
                ),
                _buildLogo(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/256px-Mastercard-logo.svg.png',
                ),
              ],
              onTap: () {
                // Navigasi ke detail Kartu Saya
              },
            ),

            const Divider(height: 1, color: Color(0xFFF3F4F6)),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required List<Widget> trailingLogos,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Row(
          children: [
            // Ikon Lingkaran
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),

            // Judul Menu
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),

            // Deretan Logo Metode Pembayaran
            Row(mainAxisSize: MainAxisSize.min, children: trailingLogos),

            const SizedBox(width: 12),

            // Panah Kanan
            const Icon(Icons.chevron_right, color: Colors.black87, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: Image.network(
        imageUrl,
        width: 24, // Ukuran logo kecil
        height: 16,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 24,
            height: 16,
            color: Colors.grey.shade200,
            child: const Icon(
              Icons.image_not_supported,
              size: 10,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
