import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/models/flight_model.dart';
import 'package:yalla/core/models/order_model.dart';
import 'package:yalla/core/providers/order_provider.dart';
import 'package:yalla/core/widgets/animated/animated_payment_bottomBar.dart';
import 'package:yalla/core/widgets/animated/countdown_timer.dart';
import 'package:yalla/features/user/home/home_screen.dart';
import 'package:yalla/features/user/plane/flight/flight/payment_succes_screen.dart';

class PaymentScreen extends StatelessWidget {
  final FlightModel flight;
  final FlightModel? returnFlight;
  final num paymentAmount;
  final DateTime paymentDeadline;
  final OrderModel order;

  const PaymentScreen({
    super.key,
    required this.flight,
    required this.paymentAmount,
    required this.paymentDeadline,
    required this.order,
    this.returnFlight,
  });

  bool get _isRoundTrip => returnFlight != null;

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

  String _formatPaymentDeadline() {
    final date = paymentDeadline;
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
    String dayName = days[date.weekday - 1];
    String day = date.day.toString().padLeft(2, '0');
    String monthName = months[date.month - 1];
    String year = date.year.toString();
    String hour = date.hour.toString().padLeft(2, '0');
    String minute = date.minute.toString().padLeft(2, '0');
    return "$dayName, $day $monthName $year  •  $hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    final bool isOutbound = flight.isOutbound ?? true;
    final String originCode = isOutbound ? "UPG" : "JED";
    final String destCode = isOutbound ? "JED" : "UPG";
    final String originCity = isOutbound ? "Makassar" : "Jeddah";
    final String destCity = isOutbound ? "Jeddah" : "Makassar";
    final String flightNo = flight.flightNo ?? "-";
    final String duration = _calculateDuration(
      flight.departureTime,
      flight.arrivalTime,
    );
    final String priceText = _formatPrice(paymentAmount);
    final String deadlineText = _formatPaymentDeadline();

    final String retFlightNo = returnFlight?.flightNo ?? "-";
    final String retDuration = _calculateDuration(
      returnFlight?.departureTime,
      returnFlight?.arrivalTime,
    );

    final orderProvider = context.read<OrderProvider>();
    final String orderIdShort = orderProvider.lastOrderId.isNotEmpty
        ? orderProvider.lastOrderId.substring(0, 8).toUpperCase()
        : "TRV99281";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
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
                            builder: (context) => const HomeScreen(),
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

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    // --- RINGKASAN PESANAN ---
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

                          // --- FLIGHT KEBERANGKATAN ---
                          _buildFlightRow(
                            logoPath: 'assets/images/logo_flydeal.png',
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

                          // --- FLIGHT KEPULANGAN (jika PP) ---
                          if (_isRoundTrip) ...[
                            const SizedBox(height: 12),
                            Divider(color: Colors.grey.shade100, thickness: 1),
                            const SizedBox(height: 12),
                            _buildFlightRow(
                              logoPath: 'assets/images/logo_flydeal.png',
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
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // --- VIRTUAL ACCOUNT CARD ---
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
                                priceText,
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
                              const Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "988 3305 3013 3818 1782",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.copy,
                                    color: Colors.black87,
                                    size: 20,
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
                          child: CountdownTimer(deadline: paymentDeadline),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    _buildPaymentGuideCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedPaymentBottomBar(
        orderId: order.id,
        loadingText: "Menunggu Pembayaran Tiket...",
        successText: "Transaksi Tiket Berhasil! 🥳",
        onSuccess: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentSuccessScreen(order: order),
            ),
          );
        },
      ),
    );
  }

  // --- HELPER: baris info flight ---
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
