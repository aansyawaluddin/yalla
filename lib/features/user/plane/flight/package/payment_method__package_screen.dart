import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/providers/order_provider.dart';
import 'package:yalla/core/widgets/button/payment_button.dart';
import 'package:yalla/core/widgets/modals/payment_method.dart';
import 'package:yalla/core/widgets/snackbar/custom_snackbar.dart';
import 'package:yalla/features/user/plane/flight/package/payment_package_screen.dart';

class PaymentMethodPackageScreen extends StatefulWidget {
  final String packageId;
  final String packageName;
  final int packagePrice;
  final Map<String, dynamic> passengerData;

  const PaymentMethodPackageScreen({
    super.key,
    required this.packageId,
    required this.packageName,
    required this.packagePrice,
    required this.passengerData,
  });

  @override
  State<PaymentMethodPackageScreen> createState() =>
      _PaymentMethodPackageScreenState();
}

class _PaymentMethodPackageScreenState
    extends State<PaymentMethodPackageScreen> {
  String _selectedScheme = 'Lunas';
  String? _selectedPaymentMethod;

  String _formatPriceRaw(int price) {
    String priceStr = price.toString();
    String result = '';
    int count = 0;
    for (int i = priceStr.length - 1; i >= 0; i--) {
      result = priceStr[i] + result;
      count++;
      if (count % 3 == 0 && i != 0) {
        result = '.$result';
      }
    }
    return result;
  }

  String _formatPrice(int price) {
    if (price == 0) return "IDR 0";
    return "IDR ${_formatPriceRaw(price)}";
  }

  Future<void> _handleCheckoutAndPay() async {
    if (_selectedPaymentMethod == null) {
      CustomSnackBar.showError(
        context,
        title: "Metode Pembayaran",
        message: "Mohon pilih metode pembayaran terlebih dahulu.",
      );
      return;
    }

    final int totalPrice = widget.packagePrice;
    int amountToPay = totalPrice;

    if (_selectedScheme == 'DP') amountToPay = (totalPrice * 0.3).toInt();
    if (_selectedScheme == 'Cicil') amountToPay = (totalPrice * 0.4).toInt();

    Map<String, dynamic> payload = {
      "email": widget.passengerData["email"] ?? "",
      "phone_number": widget.passengerData["phone_number"] ?? "",
      "package_id": widget.packageId,
      "passengers": [widget.passengerData],
    };

    final orderProvider = context.read<OrderProvider>();
    final success = await orderProvider.processPackageCheckout(payload);

    if (!mounted) return;

    if (success) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          reverseTransitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) =>
              PaymentPackageScreen(
                packageName: widget.packageName,
                paymentAmount: amountToPay,
                paymentDeadline: DateTime.now().add(const Duration(hours: 24)),
                orderId: orderProvider.lastOrderId,
                order: orderProvider.lastOrder,
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
        ),
      );
    } else {
      CustomSnackBar.showError(
        context,
        title: "Checkout Gagal",
        message: orderProvider.errorMessage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalPrice = widget.packagePrice;
    final int dpPrice = (totalPrice * 0.3).toInt();
    final int cicilPrice = (totalPrice * 0.4).toInt();

    int currentPaymentAmount = totalPrice;
    if (_selectedScheme == 'DP') currentPaymentAmount = dpPrice;
    if (_selectedScheme == 'Cicil') currentPaymentAmount = cicilPrice;

    int remainingBalance = totalPrice - currentPaymentAmount;

    final isLoading = context.watch<OrderProvider>().isLoading;

    final String invoiceNumber =
        "INV-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}";

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // --- HEADER NAV ---
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
                        "Metode Pembayaran",
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
                        // --- KARTU RINGKASAN PESANAN PAKET ---
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Ringkasan Pesanan",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    "#$invoiceNumber",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0084FF),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF0F8FF),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(
                                          0xFF0084FF,
                                        ).withOpacity(0.2),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.mosque,
                                      color: Color(0xFF0084FF),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.packageName,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Paket Perjalanan Umrah",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Container(height: 1, color: Colors.grey.shade200),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Total Harga Paket",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    _formatPrice(totalPrice),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0084FF),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // --- SKEMA PEMBAYARAN ---
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
                                price: _formatPrice(totalPrice),
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
                                price: _formatPrice(dpPrice),
                                subtitle: "Uang Muka",
                                isSelected: _selectedScheme == 'DP',
                                onTap: () =>
                                    setState(() => _selectedScheme = 'DP'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildSchemeCard(
                                title: "Cicil",
                                price: _formatPrice(cicilPrice),
                                subtitle: "Bertahap",
                                isSelected: _selectedScheme == 'Cicil',
                                onTap: () =>
                                    setState(() => _selectedScheme = 'Cicil'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // --- EXPANDED DETAIL SKEMA ---
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          alignment: Alignment.topCenter,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _buildExpandedArea(
                              totalPrice,
                              currentPaymentAmount,
                              remainingBalance,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // --- METODE PEMBAYARAN ---
                        const Text(
                          "Metode Pembayaran",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
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
                              border: Border.all(
                                color: _selectedPaymentMethod == null
                                    ? Colors.grey.shade300
                                    : const Color(0xFF0084FF),
                                width: _selectedPaymentMethod == null
                                    ? 1.0
                                    : 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icons/payment.png',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.account_balance_wallet,
                                        color: Color(0xFF005C99),
                                        size: 32,
                                      ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    _selectedPaymentMethod ??
                                        "Pilih Metode Pembayaran",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: _selectedPaymentMethod == null
                                          ? Colors.black54
                                          : Colors.black87,
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
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Total Dibayar Sekarang",
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
                  _formatPrice(currentPaymentAmount),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                PaymentButton(
                  text: "Bayar Sekarang",
                  onPressed: isLoading ? () {} : _handleCheckoutAndPay,
                ),
              ],
            ),
          ),
        ),

        // --- LOADING OVERLAY ---
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFF0084FF)),
            ),
          ),
      ],
    );
  }

  // --- WIDGET REUSABLE ---
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
        padding: const EdgeInsets.all(10),
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
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 9, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedArea(int total, int current, int remaining) {
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
          children: [
            const Text(
              "Jumlah Bayar Sekarang:",
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
            Text(
              _formatPrice(current),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        key: ValueKey('Detail$_selectedScheme'),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF66B2FF)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF0F8FF),
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
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
                        "Detail Skema",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _selectedScheme,
                    style: const TextStyle(
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
                    children: [
                      const Text(
                        "Total Tagihan",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        _formatPrice(total),
                        style: const TextStyle(
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
                      const Text(
                        "Total Dibayar",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        _formatPrice(current),
                        style: const TextStyle(
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
                    children: [
                      const Text(
                        "Sisa Tagihan",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        _formatPrice(remaining),
                        style: const TextStyle(
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
          ],
        ),
      );
    }
  }
}
