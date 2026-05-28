import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yalla/core/models/flight_model.dart';
import 'package:yalla/core/models/order_model.dart';
import 'package:yalla/core/widgets/animated/animated_payment_bottomBar_travel.dart';
import 'package:yalla/core/widgets/animated/countdown_timer.dart';
import 'package:yalla/core/widgets/snackbar/custom_snackbar.dart';
import 'package:yalla/features/travel/home/home_plane_travel_screen.dart';

class PaymentTravelScreen extends StatefulWidget {
  final FlightModel flight;
  final FlightModel? returnFlight;
  final int paymentAmount;
  final DateTime paymentDeadline;
  final String orderId;
  final OrderModel order;

  const PaymentTravelScreen({
    super.key,
    required this.flight,
    this.returnFlight,
    required this.paymentAmount,
    required this.paymentDeadline,
    required this.orderId,
    required this.order,
  });

  @override
  State<PaymentTravelScreen> createState() => _PaymentTravelScreenState();
}

class _PaymentTravelScreenState extends State<PaymentTravelScreen> {
  bool get _isRoundTrip => widget.returnFlight != null;

  String _formatPrice(int price) {
    String priceStr = price.toString();
    String result = '';
    int count = 0;
    for (int i = priceStr.length - 1; i >= 0; i--) {
      result = priceStr[i] + result;
      count++;
      if (count % 3 == 0 && i != 0) result = '.$result';
    }
    return "IDR $result";
  }

  String _calculateDuration(String? dep, String? arr) {
    if (dep == null || arr == null) return "-";
    try {
      final d = DateTime.parse(dep);
      final a = DateTime.parse(arr);
      final diff = a.difference(d);
      return "${diff.inHours}j ${diff.inMinutes.remainder(60)}m";
    } catch (e) {
      return "-";
    }
  }

  String _formatPaymentDeadline() {
    final date = widget.paymentDeadline;
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return "${days[date.weekday - 1]}, ${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}  •  ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final bool isOutbound = widget.flight.isOutbound ?? true;
    final String originCode = isOutbound ? "UPG" : "JED";
    final String destCode = isOutbound ? "JED" : "UPG";
    final String originName = isOutbound ? "Makassar" : "Jeddah";
    final String destName = isOutbound ? "Jeddah" : "Makassar";
    final String flightNo = widget.flight.flightNo ?? "Airline";
    final String duration = _calculateDuration(
      widget.flight.departureTime,
      widget.flight.arrivalTime,
    );
    final String retDuration = _calculateDuration(
      widget.returnFlight?.departureTime,
      widget.returnFlight?.arrivalTime,
    );
    final String deadlineText = _formatPaymentDeadline();
    final String orderIdShort = widget.orderId.length >= 8
        ? widget.orderId.substring(0, 8).toUpperCase()
        : widget.orderId.toUpperCase();

    const String virtualAccountNumber = "988 3305 3013 3818 1782";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 24,
                  right: 24,
                  bottom: 8,
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
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const HomePlaneTravelScreen(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "Pembayaran",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Ringkasan Pesanan",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "#$orderIdShort",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0084FF),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Flight keberangkatan
                        _buildFlightRow(
                          logoPath: 'assets/images/logo_flydeal.png',
                          airlineName: "Flydeal Air",
                          flightNo: flightNo,
                          originCode: originCode,
                          originCity: originName,
                          destCode: destCode,
                          destCity: destName,
                          duration: duration,
                          accentColor: const Color(0xFF0084FF),
                          label: _isRoundTrip ? "Berangkat" : null,
                        ),

                        // Flight kepulangan jika PP
                        if (_isRoundTrip) ...[
                          const SizedBox(height: 12),
                          Divider(color: Colors.grey.shade100, thickness: 1),
                          const SizedBox(height: 12),
                          _buildFlightRow(
                            logoPath: 'assets/images/logo_flydeal.png',
                            airlineName: "Flydeal Air",
                            flightNo: widget.returnFlight?.flightNo ?? "-",
                            originCode: "JED",
                            originCity: "Jeddah",
                            destCode: "UPG",
                            destCity: "Makassar",
                            duration: retDuration,
                            accentColor: Colors.orange,
                            label: "Pulang",
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),


                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 32,
                          bottom: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xffDADADA)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Selesaikan sebelum",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              deadlineText,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              "TOTAL TAGIHAN",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black38,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatPrice(widget.paymentAmount),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0084FF),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              "NOMOR VIRTUAL ACCOUNT",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black38,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    virtualAccountNumber,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                      const ClipboardData(
                                        text: virtualAccountNumber,
                                      ),
                                    );
                                    CustomSnackBar.showSuccess(
                                      context,
                                      title: "Disalin",
                                      message:
                                          "Nomor virtual account berhasil disalin.",
                                    );
                                  },
                                  child: const Icon(
                                    Icons.copy,
                                    color: Colors.black87,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/icons/bni.png',
                                    height: 16,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.account_balance,
                                              size: 16,
                                              color: Colors.orange,
                                            ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    "BNI VIRTUAL ACCOUNT",
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: -20,
                        right: 20,
                        child: CountdownTimer(deadline: widget.paymentDeadline),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  _buildPaymentGuideCard(),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedPaymentBottombarTravel(order: widget.order),
    );
  }

  Widget _buildFlightRow({
    required String logoPath,
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xffDADADA)),
                image: DecorationImage(
                  image: AssetImage(logoPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    airlineName,
                    style: const TextStyle(
                      fontSize: 14,
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

  Widget _buildPaymentGuideCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: Colors.black38,
          collapsedIconColor: Colors.black38,
          title: Row(
            children: [
              Image.asset(
                'assets/icons/bni.png',
                height: 24,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.atm, color: Colors.blue, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                "ATM BNI",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "1. Masukkan Kartu ATM BNI & PIN\n"
                "2. Pilih menu Lainnya > Transfer\n"
                "3. Pilih jenis rekening asal dan pilih Virtual Account Billing\n"
                "4. Masukkan nomor Virtual Account\n"
                "5. Tagihan yang harus dibayarkan akan muncul pada layar\n"
                "6. Konfirmasi pembayaran",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
