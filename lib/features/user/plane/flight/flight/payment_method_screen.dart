import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yalla/core/models/flight_model.dart';
import 'package:yalla/core/providers/order_provider.dart';
import 'package:yalla/core/widgets/button/payment_button.dart';
import 'package:yalla/core/widgets/modals/payment_method.dart';
import 'package:yalla/core/widgets/snackbar/custom_snackbar.dart';
import 'package:yalla/features/user/plane/flight/flight/payment_screen.dart';

class PaymentMethodScreen extends StatefulWidget {
  final FlightModel flight;
  final FlightModel? returnFlight;
  final Map<String, dynamic> passengerData;

  const PaymentMethodScreen({
    super.key,
    required this.flight,
    this.returnFlight,
    required this.passengerData,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedScheme = 'Lunas';
  String? _selectedPaymentMethod;

  bool get _isRoundTrip => widget.returnFlight != null;

  num get _totalPrice {
    num dep = widget.flight.price ?? 0;
    num ret = widget.returnFlight?.price ?? 0;
    return dep + ret;
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

  String _calculateDuration(String? dep, String? arr) {
    if (dep == null || arr == null) return "-";
    try {
      final d = DateTime.parse(dep);
      final a = DateTime.parse(arr);
      final diff = a.difference(d);
      final hours = diff.inHours;
      final mins = diff.inMinutes.remainder(60);
      return "${hours}j ${mins}m";
    } catch (e) {
      return "-";
    }
  }

  void _handleCheckoutAndPay() async {
    if (_selectedPaymentMethod == null) {
      CustomSnackBar.showError(
        context,
        title: "Metode Pembayaran",
        message: "Mohon pilih metode pembayaran terlebih dahulu.",
      );
      return;
    }

    final num totalPrice = _totalPrice;
    num amountToPay = totalPrice;
    if (_selectedScheme == 'DP') amountToPay = totalPrice * 0.3;
    if (_selectedScheme == 'Cicil') amountToPay = totalPrice * 0.4;

    Map<String, dynamic> payload = {
      "email": widget.passengerData["email"],
      "phone_number": widget.passengerData["phone_number"],
      "departure_flight_id": widget.flight.id,
      if (_isRoundTrip) "return_flight_id": widget.returnFlight!.id,
      "passengers": [widget.passengerData],
    };

    final orderProvider = context.read<OrderProvider>();
    final success = await orderProvider.processCheckoutAndPayment(payload);

    if (!mounted) return;

    if (success && orderProvider.gatewayUrl.isNotEmpty) {
      final Uri url = Uri.parse(orderProvider.gatewayUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              flight: widget.flight,
              returnFlight: widget.returnFlight, 
              paymentAmount: amountToPay,
              paymentDeadline: DateTime.now().add(const Duration(hours: 24)),
              order: orderProvider.lastOrder,
            ),
          ),
        );
      } else {
        CustomSnackBar.showError(
          context,
          title: "Gagal",
          message: "Tidak dapat membuka link pembayaran.",
        );
      }
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
    final num totalPrice = _totalPrice;
    final num dpPrice = totalPrice * 0.3;
    final num cicilPrice = totalPrice * 0.4;

    num currentPaymentAmount = totalPrice;
    if (_selectedScheme == 'DP') currentPaymentAmount = dpPrice;
    if (_selectedScheme == 'Cicil') currentPaymentAmount = cicilPrice;

    num remainingBalance = totalPrice - currentPaymentAmount;

    final isLoading = context.watch<OrderProvider>().isLoading;

    final bool isOutbound = widget.flight.isOutbound ?? true;
    final String originCode = isOutbound ? "UPG" : "JED";
    final String destCode = isOutbound ? "JED" : "UPG";
    final String originCity = isOutbound ? "Makassar" : "Jeddah";
    final String destCity = isOutbound ? "Jeddah" : "Makassar";
    final String flightNo = widget.flight.flightNo ?? "-";
    final String duration = _calculateDuration(
      widget.flight.departureTime,
      widget.flight.arrivalTime,
    );

    final String retFlightNo = widget.returnFlight?.flightNo ?? "-";
    final String retDuration = _calculateDuration(
      widget.returnFlight?.departureTime,
      widget.returnFlight?.arrivalTime,
    );

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
                  Text(
                    _isRoundTrip
                        ? "Metode Pembayaran (PP)"
                        : "Metode Pembayaran",
                    style: const TextStyle(
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
                    Container(
                      width: double.infinity,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -30,
                            top: 75,
                            child: Opacity(
                              opacity: 1,
                              child: Image.asset(
                                'assets/images/bg_flight_card.png',
                                width: 250,
                                fit: BoxFit.contain,
                                color: Colors.black.withOpacity(0.15),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
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
                                      _isRoundTrip
                                          ? "#$flightNo • #$retFlightNo"
                                          : "#$flightNo",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0084FF),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                _buildFlightSummaryRow(
                                  logo: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xffDADADA),
                                      ),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          'assets/images/logo_flydeal.png',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  airlineName: "Flydeal Air",
                                  flightNo: flightNo,
                                  originCode: originCode,
                                  originCity: originCity,
                                  destCode: destCode,
                                  destCity: destCity,
                                  duration: duration,
                                  accentColor: const Color(0xFF0084FF),
                                  label: _isRoundTrip ? "Berangkat" : null,
                                ),

                                if (_isRoundTrip) ...[
                                  const SizedBox(height: 12),
                                  Divider(
                                    color: Colors.grey.shade100,
                                    thickness: 1,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildFlightSummaryRow(
                                    logo: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xffDADADA),
                                        ),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                            'assets/images/logo_flydeal.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    airlineName: "Flydeal Air",
                                    flightNo: retFlightNo,
                                    originCode: "JED",
                                    originCity: "Jeddah",
                                    destCode: "UPG",
                                    destCity: "Makassar",
                                    duration: retDuration,
                                    accentColor: Colors.orange,
                                    label: "Pulang",
                                  ),
                                ],

                                const SizedBox(height: 24),

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
                                        onTap: () => setState(
                                          () => _selectedScheme = 'Lunas',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _buildSchemeCard(
                                        title: "DP",
                                        price: _formatPrice(dpPrice),
                                        subtitle: "Uang Muka",
                                        isSelected: _selectedScheme == 'DP',
                                        onTap: () => setState(
                                          () => _selectedScheme = 'DP',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _buildSchemeCard(
                                        title: "Cicil",
                                        price: _formatPrice(cicilPrice),
                                        subtitle: "Bertahap",
                                        isSelected: _selectedScheme == 'Cicil',
                                        onTap: () => setState(
                                          () => _selectedScheme = 'Cicil',
                                        ),
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
                                    child: _buildExpandedArea(
                                      totalPrice,
                                      currentPaymentAmount,
                                      remainingBalance,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

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
                            width: _selectedPaymentMethod == null ? 1.0 : 1.5,
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
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Dibayar Sekarang",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  _isRoundTrip ? "Pulang-Pergi • 1 Penumpang" : "1 Penumpang",
                  style: const TextStyle(
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
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF0084FF)),
                  )
                : PaymentButton(
                    text: "Bayar Sekarang",
                    onPressed: _handleCheckoutAndPay,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightSummaryRow({
    required Widget logo,
    required String airlineName,
    required String flightNo,
    required String originCode,
    required String originCity,
    required String destCode,
    required String destCity,
    required String duration,
    required Color accentColor,
    String? label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            logo,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    airlineName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          "$flightNo  •  Ekonomi",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (label != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  originCode,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  originCity,
                  style: const TextStyle(fontSize: 9, color: Colors.black54),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Transform.rotate(
                          angle: 1.5708,
                          child: Icon(
                            Icons.flight,
                            size: 14,
                            color: accentColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    duration,
                    style: const TextStyle(fontSize: 8, color: Colors.black38),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  destCode,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  destCity,
                  style: const TextStyle(fontSize: 9, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ],
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

  Widget _buildExpandedArea(num total, num current, num remaining) {
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
                  const Row(
                    children: [
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
