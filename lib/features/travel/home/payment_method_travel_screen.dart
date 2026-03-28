import 'package:flutter/material.dart';
import 'package:yalla/core/widgets/button/payment_button.dart';
import 'package:yalla/core/widgets/modals/payment_method.dart';
import 'package:yalla/features/travel/home/payment_travel_screen.dart';

class PaymentMethodTravelScreen extends StatefulWidget {
  const PaymentMethodTravelScreen({super.key});

  @override
  State<PaymentMethodTravelScreen> createState() =>
      _PaymentMethodTravelScreenState();
}

class _PaymentMethodTravelScreenState extends State<PaymentMethodTravelScreen> {
  String _selectedScheme = 'Lunas';
  String? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(
                top: 16,
                left: 24,
                right: 24,
                bottom: 16,
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                  const SizedBox(width: 16),
                  const Text(
                    "Ringkasan Pembayaran",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF005C99),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            "Belum Dibayar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Text(
                          "#INV-2026-0301",
                          style: TextStyle(
                            color: Color(0xFF0066CC),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInvoiceDetailRow(
                      "No. Invoice",
                      "232/FAD-CMA/III/2026",
                    ),
                    _buildInvoiceDetailRow("Tanggal Terbit", "01 Maret 2026"),
                    _buildInvoiceDetailRow(
                      "Jatuh Tempo",
                      "03 Maret 2027",
                      isRed: true,
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      "Detail Penerbangan",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFlightItem(
                      "UPG - JED (Pergi)",
                      "11 Maret 2026 • Economy Class",
                      "EC",
                      false,
                    ),
                    const SizedBox(height: 8),
                    _buildFlightItem(
                      "JED - UPG (Pulang)",
                      "21 Maret 2026 • Economy Class",
                      "BC",
                      true,
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      "Rincian Harga",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInvoiceDetailRow(
                      "Tiket Pesawat (40)",
                      "IDR 24.500.000",
                    ),
                    _buildInvoiceDetailRow(
                      "Pajak dan Biaya Layanan",
                      "IDR 1.125.000",
                    ),
                    _buildInvoiceDetailRow("Biaya Administrasi", "IDR 50.000"),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(color: Colors.black12),
                    ),
                    _buildInvoiceDetailRow(
                      "Total Tagihan",
                      "IDR 25.800.000",
                      isBlueBold: true,
                    ),
                    const SizedBox(height: 32),

                    const Text(
                      "Skema Pembayaran",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSchemeCard(
                            title: "Lunas",
                            price: "IDR 11.000.000",
                            subtitle: "Sekali Bayar",
                            isSelected: _selectedScheme == 'Lunas',
                            onTap: () =>
                                setState(() => _selectedScheme = 'Lunas'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildSchemeCard(
                            title: "DP",
                            price: "IDR 3.300.000",
                            subtitle: "Uang Muka",
                            isSelected: _selectedScheme == 'DP',
                            onTap: () => setState(() => _selectedScheme = 'DP'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildSchemeCard(
                            title: "Cicil",
                            price: "IDR 4.000.000",
                            subtitle: "Bertahap",
                            isSelected: _selectedScheme == 'Cicil',
                            onTap: () =>
                                setState(() => _selectedScheme = 'Cicil'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      alignment: Alignment.topCenter,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeOut,
                        child: _buildExpandedArea(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () async {
                        final selectedMethod =
                            await showModalBottomSheet<String>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const PaymentMethod(),
                            );

                        if (selectedMethod != null) {
                          setState(() {
                            _selectedPaymentMethod = selectedMethod;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/payment.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                _selectedPaymentMethod ??
                                    "Pilih Metode Pembayaran",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Total Harga",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  "1 Penumpang",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _selectedScheme == 'Lunas'
                  ? "IDR 11.000.000"
                  : _selectedScheme == 'DP'
                  ? "IDR 3.300.000"
                  : "IDR 4.000.000",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            PaymentButton(
              text: "Bayar Sekarang",
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 800),
                    reverseTransitionDuration: const Duration(
                      milliseconds: 800,
                    ),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const PaymentTravelScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          var curvedAnimation = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          );

                          return FadeTransition(
                            opacity: curvedAnimation,
                            child: child,
                          );
                        },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceDetailRow(
    String title,
    String value, {
    bool isRed = false,
    bool isBlueBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isBlueBold ? Colors.black87 : Colors.black54,
              fontWeight: isBlueBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: isRed
                  ? Colors.red
                  : (isBlueBold ? const Color(0xFF005C99) : Colors.black87),
              fontWeight: (isBlueBold || isRed)
                  ? FontWeight.bold
                  : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightItem(
    String route,
    String details,
    String badgeText,
    bool isBlueBadge,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F9FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE1F0FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.flight_takeoff,
              color: Color(0xFF005C99),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  route,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  details,
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isBlueBadge
                  ? const Color(0xFF0084FF)
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isBlueBadge ? Colors.white : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedArea() {
    if (_selectedScheme == 'Lunas') {
      return Container(
        key: const ValueKey('LunasBanner'),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F8FF),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFE1F0FF)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Jumlah Bayar Sekarang:",
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
            Text(
              "IDR 11.000.000",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      );
    } else if (_selectedScheme == 'DP') {
      return Column(
        key: const ValueKey('DetailDP'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFC8E6C9)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8FAED),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.payments_outlined,
                            size: 16,
                            color: Color(0xFF1E8A00),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Skema Pembayaran",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        "DP",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E8A00),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Total Paket",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "IDR 11.000.000",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Text(
                                "DP Minimum ",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "(2jt/pax)",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            "IDR 3.300.000",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E8A00),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Sisa Tagihan",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "IDR 7.700.000",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8FAED),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(8),
                    ),
                  ),
                  child: RichText(
                    text: const TextSpan(
                      text: "Pelunasan Maksimal ",
                      style: TextStyle(fontSize: 10, color: Colors.black87),
                      children: [
                        TextSpan(
                          text: "H-7 ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E8A00),
                          ),
                        ),
                        TextSpan(
                          text: "(23 Juni 2026)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Column(
        key: const ValueKey('DetailCicil'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF66B2FF)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F8FF),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.payments_outlined,
                            size: 16,
                            color: Color(0xFF005C99),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Skema Pembayaran",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        "CICIL",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0084FF),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Total Tagihan",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "IDR 11.000.000",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Total Dibayar",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "IDR 4.000.000",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0084FF),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Sisa Tagihan",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "IDR 7.700.000",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "74% Dibayar",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0084FF),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: 0.74,
                          minHeight: 6,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF0084FF),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Pembayaran dapat dilakukan secara bertahap tanpa jumlah tetap. Pelunasan wajib dilakukan maksimal 7 hari sebelum keberangkatan",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Masukkan Nominal Pembayaran",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          _buildInputBox("4.000.000"),
        ],
      );
    }
  }

  Widget _buildInputBox(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Text(
            "IDR",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchemeCard({
    required String title,
    required String price,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF6FBFF) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF0084FF) : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? const Color(0xFF0084FF)
                        : const Color(0xFF005C99),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle_outline,
                    size: 14,
                    color: Color(0xFF0084FF),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              price,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
