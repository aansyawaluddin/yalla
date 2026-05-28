import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/models/flight_model.dart';
import 'package:yalla/core/models/order_model.dart';
import 'package:yalla/core/providers/order_provider.dart';
import 'package:yalla/core/utils/date_formatter.dart';
import 'package:yalla/core/widgets/button/payment_button.dart';
import 'package:yalla/core/widgets/modals/payment_method.dart';
import 'package:yalla/core/widgets/snackbar/custom_snackbar.dart';
import 'package:yalla/features/travel/home/payment_travel_screen.dart';

class PaymentMethodTravelScreen extends StatefulWidget {
  final FlightModel flight;
  final FlightModel? returnFlight;
  final List<dynamic> passengers;
  final OrderModel order;

  const PaymentMethodTravelScreen({
    super.key,
    required this.flight,
    this.returnFlight,
    required this.passengers,
    required this.order,
  });

  @override
  State<PaymentMethodTravelScreen> createState() =>
      _PaymentMethodTravelScreenState();
}

class _PaymentMethodTravelScreenState extends State<PaymentMethodTravelScreen> {
  String _selectedScheme = 'Lunas';
  String? _selectedPaymentMethod;
  late TextEditingController _nominalController;

  bool get _isRoundTrip => widget.returnFlight != null;

  int get _passengerCount => widget.passengers.length;

  int get _ticketPriceTotal {
    final depPrice = (widget.flight.price ?? 0).toInt();
    final retPrice = _isRoundTrip
        ? (widget.returnFlight!.price ?? 0).toInt()
        : 0;
    return (depPrice + retPrice) * _passengerCount;
  }

  int get _totalBill => _ticketPriceTotal;
  int get _dpMinimum => 2000000 * _passengerCount;
  int get _cicilDefault => (_totalBill / 3).toInt();

  @override
  void initState() {
    super.initState();
    _nominalController = TextEditingController();
    _updateNominalInput();
  }

  @override
  void dispose() {
    _nominalController.dispose();
    super.dispose();
  }

  void _updateNominalInput() {
    if (_selectedScheme == 'Lunas') {
      _nominalController.text = _formatPriceRaw(_totalBill);
    } else if (_selectedScheme == 'DP') {
      _nominalController.text = _formatPriceRaw(_dpMinimum);
    } else {
      _nominalController.text = _formatPriceRaw(_cicilDefault);
    }
  }

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
    return "IDR ${_formatPriceRaw(price)}";
  }

  Future<void> _handleCheckout() async {
    if (_selectedPaymentMethod == null) {
      CustomSnackBar.showError(
        context,
        title: "Metode Pembayaran",
        message: "Silakan pilih metode pembayaran terlebih dahulu.",
      );
      return;
    }

    int amountToPay = _totalBill;
    if (_selectedScheme == 'DP') amountToPay = _dpMinimum;
    if (_selectedScheme == 'Cicil') {
      amountToPay =
          int.tryParse(_nominalController.text.replaceAll('.', '')) ??
          _cicilDefault;
    }

    final Map<String, dynamic> payload = {
      "departure_flight_id": widget.flight.id,
      if (_isRoundTrip) "return_flight_id": widget.returnFlight!.id,
      "payment_scheme": _selectedScheme.toLowerCase(),
      "payment_method": _selectedPaymentMethod,
      "amount_paid": amountToPay,
      "passengers": widget.passengers,
    };

    final orderProvider = context.read<OrderProvider>();
    final success = await orderProvider.processCheckoutAndPayment(payload);

    if (!mounted) return;

    if (success) {
      final String newOrderId = orderProvider.lastOrderId;

      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          reverseTransitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) =>
              PaymentTravelScreen(
                flight: widget.flight,
                returnFlight: widget.returnFlight,
                paymentAmount: amountToPay,
                paymentDeadline: DateTime.now().add(const Duration(hours: 24)),
                orderId: newOrderId,
                order: widget.order,
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
    final isLoading = context.watch<OrderProvider>().isLoading;

    final bool isOutbound = widget.flight.isOutbound ?? true;
    final String routeTitle = isOutbound
        ? "UPG - JED (Pergi)"
        : "JED - UPG (Pulang)";
    final String flightDate = DateFormatter.formatDate(
      widget.flight.departureTime ?? '',
    );
    final String retFlightDate = _isRoundTrip
        ? DateFormatter.formatDate(widget.returnFlight!.departureTime ?? '')
        : '';

    final String invoiceNumber =
        "INV-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}";

    int activeBottomPrice = _totalBill;
    if (_selectedScheme == 'DP') activeBottomPrice = _dpMinimum;
    if (_selectedScheme == 'Cicil') {
      activeBottomPrice =
          int.tryParse(_nominalController.text.replaceAll('.', '')) ??
          _cicilDefault;
    }

    return Stack(
      children: [
        Scaffold(
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
                      Expanded(
                        child: Text(
                          _isRoundTrip
                              ? "Ringkasan Pembayaran (PP)"
                              : "Ringkasan Pembayaran",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
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
                        // --- STATUS & INVOICE ---
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
                            Text(
                              "#$invoiceNumber",
                              style: const TextStyle(
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
                          "BOM/WAVE-1/${DateTime.now().year}",
                        ),
                        _buildInvoiceDetailRow(
                          "Tanggal Terbit",
                          "Hari Ini (Sesuai Sistem)",
                        ),
                        _buildInvoiceDetailRow(
                          "Jatuh Tempo",
                          "Besok Hari",
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
                          routeTitle,
                          "$flightDate • ${widget.flight.flightNo ?? 'Flydeal'}",
                          "EC",
                          true,
                        ),

                        if (_isRoundTrip) ...[
                          const SizedBox(height: 8),
                          _buildFlightItem(
                            "JED - UPG (Pulang)",
                            "$retFlightDate • ${widget.returnFlight!.flightNo ?? 'Flydeal'}",
                            "EC",
                            false,
                          ),
                        ],

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

                        if (_isRoundTrip) ...[
                          _buildInvoiceDetailRow(
                            "Tiket Berangkat ($_passengerCount pax)",
                            _formatPrice(
                              (widget.flight.price ?? 0).toInt() *
                                  _passengerCount,
                            ),
                          ),
                          _buildInvoiceDetailRow(
                            "Tiket Pulang ($_passengerCount pax)",
                            _formatPrice(
                              (widget.returnFlight!.price ?? 0).toInt() *
                                  _passengerCount,
                            ),
                          ),
                        ] else
                          _buildInvoiceDetailRow(
                            "Tiket Pesawat ($_passengerCount pax)",
                            _formatPrice(_ticketPriceTotal),
                          ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(color: Colors.black12),
                        ),
                        _buildInvoiceDetailRow(
                          "Total Tagihan",
                          _formatPrice(_totalBill),
                          isBlueBold: true,
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
                                price: _formatPrice(_totalBill),
                                subtitle: "Sekali Bayar",
                                isSelected: _selectedScheme == 'Lunas',
                                onTap: () {
                                  setState(() => _selectedScheme = 'Lunas');
                                  _updateNominalInput();
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildSchemeCard(
                                title: "DP",
                                price: _formatPrice(_dpMinimum),
                                subtitle: "Uang Muka",
                                isSelected: _selectedScheme == 'DP',
                                onTap: () {
                                  setState(() => _selectedScheme = 'DP');
                                  _updateNominalInput();
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildSchemeCard(
                                title: "Cicil",
                                price: _formatPrice(_cicilDefault),
                                subtitle: "Bertahap",
                                isSelected: _selectedScheme == 'Cicil',
                                onTap: () {
                                  setState(() => _selectedScheme = 'Cicil');
                                  _updateNominalInput();
                                },
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
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Harga",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    Text(
                      _isRoundTrip
                          ? "PP • $_passengerCount Penumpang"
                          : "$_passengerCount Penumpang",
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
                  _formatPrice(activeBottomPrice),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                PaymentButton(
                  text: "Bayar Sekarang",
                  onPressed: isLoading ? () {} : _handleCheckout,
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
        color: isBlueBadge
            ? const Color(0xFFF4F9FF)
            : Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isBlueBadge
              ? Colors.transparent
              : Colors.orange.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isBlueBadge
                  ? const Color(0xFFE1F0FF)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isBlueBadge ? Icons.flight_takeoff : Icons.flight_land,
              color: isBlueBadge ? const Color(0xFF005C99) : Colors.orange,
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
              color: isBlueBadge ? const Color(0xFF0084FF) : Colors.orange,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              badgeText,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
          children: [
            const Text(
              "Jumlah Bayar Sekarang:",
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
            Text(
              _formatPrice(_totalBill),
              style: const TextStyle(
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
                      const Row(
                        children: [
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
                            _formatPrice(_totalBill),
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
                          Row(
                            children: [
                              const Text(
                                "DP Minimum ",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "(2jt x $_passengerCount pax)",
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _formatPrice(_dpMinimum),
                            style: const TextStyle(
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
                            _formatPrice(_totalBill - _dpMinimum),
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
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFE8FAED),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
            child: const Text(
              "Pelunasan maksimal H-7 sebelum keberangkatan sesuai aturan penerbangan.",
              style: TextStyle(fontSize: 10, color: Colors.black87),
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
            child: Padding(
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
                        _formatPrice(_totalBill),
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
                        "Sisa Tagihan Pokok",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        _formatPrice(_totalBill - _cicilDefault),
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
          _buildInputBox(),
        ],
      );
    }
  }

  Widget _buildInputBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: _nominalController,
              keyboardType: TextInputType.number,
              onChanged: (val) => setState(() {}),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
