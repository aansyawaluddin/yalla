import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yalla/core/models/order_model.dart';
import 'package:yalla/core/widgets/animated/animated_payment_bottomBar.dart';
import 'package:yalla/core/widgets/animated/countdown_timer.dart';
import 'package:yalla/features/user/plane/flight/package/payment_succes_screen.dart';

class PaymentPackageScreen extends StatefulWidget {
  final String packageName;
  final int paymentAmount;
  final DateTime paymentDeadline;
  final String orderId;
  final OrderModel order;

  const PaymentPackageScreen({
    super.key,
    required this.packageName,
    required this.paymentAmount,
    required this.paymentDeadline,
    required this.orderId,
    required this.order,
  });

  @override
  State<PaymentPackageScreen> createState() => _PaymentPackageScreenState();
}

class _PaymentPackageScreenState extends State<PaymentPackageScreen> {
  String _formatPrice(int price) {
    String s = price.toString();
    String res = "";
    for (int i = 0; i < s.length; i++) {
      res += s[i];
      if ((s.length - 1 - i) % 3 == 0 && i != s.length - 1) res += ".";
    }
    return "IDR $res";
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
    final String orderIdShort = widget.orderId.length > 8
        ? widget.orderId.substring(0, 8).toUpperCase()
        : widget.orderId.toUpperCase();

    final String deadlineText = _formatPaymentDeadline();
    final String priceText = _formatPrice(widget.paymentAmount);

    const String virtualAccountNumber = "988 3305 3013 3818 1782";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header — ikuti PaymentScreen
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
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Pembayaran Paket",
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
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F8FF),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xffDADADA),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        fontSize: 10,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                              // BNI badge — ikuti PaymentScreen
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
                          child: CountdownTimer(
                            deadline: widget.paymentDeadline,
                          ),
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
        orderId: widget.orderId,
        loadingText: "Menunggu Pembayaran Paket Umrah...",
        successText: "Transaksi Paket Berhasil! 🥳",
        onSuccess: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PaymentSuccessPackageScreen(order: widget.order),
            ),
          );
        },
      ),
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
