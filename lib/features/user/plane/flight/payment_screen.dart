import 'package:flutter/material.dart';
import 'package:yalla/core/widgets/animated/animated_payment_bottomBar.dart';
import 'package:yalla/core/widgets/animated/countdown_timer.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
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
                            children: const [
                              Text(
                                "Ringkasan Pesanan",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "#TRV99281",
                                style: TextStyle(
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
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Color(0xffDADADA)),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      'assets/images/logo_flydeal.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Flydeal Air",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "JT 6655  •  Ekonomi",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: const [
                                        Text(
                                          "UPG",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          "Makassar",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 1,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          "11j 15m",
                                          style: TextStyle(
                                            fontSize: 8,
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: const [
                                        Text(
                                          "JED",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          "Jeddah",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
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
                            border: Border.all(color: Color(0xffDADADA)),
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
                              const Text(
                                "Jum, 27 Feb 2026  •  16:00",
                                style: TextStyle(
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
                              const Text(
                                "IDR 11.000.000",
                                style: TextStyle(
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
                                children: const [
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
                        const Positioned(
                          top: -20,
                          right: 20,
                          child: CountdownTimer(),
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

      bottomNavigationBar: _buildBottomBar(),
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
                "1. Masukkan Kartu ATM BNI & PIN\n2. Pilih menu Lainnya > Transfer\n3. Pilih jenis rekening asal dan pilih Virtual Account Billing\n4. Masukkan nomor Virtual Account\n5. Tagihan yang harus dibayarkan akan muncul pada layar\n6. Konfirmasi pembayaran",
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

  Widget _buildBottomBar() {
    return const AnimatedPaymentBottomBar();
  }
}
