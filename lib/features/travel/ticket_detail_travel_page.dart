import 'package:flutter/material.dart';
import 'package:yalla/core/widgets/button/primary_gradient_button.dart';

class TicketDetailTravelPage extends StatelessWidget {
  final Animation<double> barcodeOpacity;
  final Animation<double> barcodeSlide;

  const TicketDetailTravelPage({
    super.key,
    required this.barcodeOpacity,
    required this.barcodeSlide,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        leading: IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF0084FF),
              size: 18,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Tiket Anda",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Flyadeal",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF0084FF),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8FAED),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Terkonfirmasi",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E8A00),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Booking Reference (PNR)",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "ABC123XYZ",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(height: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Issuing Airline",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Flyadeal",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text(
                              "Issue Date",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "2025 - 10 - 23",
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
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Detail Penerbangan - Keberangkatan",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildFlightCard(
                flightNo: "F3 9103",
                date: "Mar 02, 2026",
                originCode: "UPG",
                originCity: "Makassar",
                originTime: "11:00",
                destCode: "JED",
                destCity: "Jeddah",
                destTime: "22:15",
              ),

              const SizedBox(height: 24),

              const Text(
                "Detail Penerbangan - Kepulangan",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildFlightCard(
                flightNo: "F3 9103",
                date: "Mar 02, 2026",
                originCode: "JED",
                originCity: "Jeddah",
                originTime: "22:15",
                destCode: "UPG",
                destCity: "Makassar",
                destTime: "11:00",
              ),

              const SizedBox(height: 32),

              const Text(
                "List Penumpang",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 220,
                decoration: BoxDecoration(),
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildPassengerItem(
                      "Muhammad Rafli Dahlan",
                      "123-12491245",
                    ),
                    _buildPassengerItem(
                      "Muhammad Rafli Dahlan",
                      "123-12491245",
                    ),
                    _buildPassengerItem(
                      "Muhammad Rafli Dahlan",
                      "193-19491945",
                    ),
                    _buildPassengerItem(
                      "Muhammad Rafli Dahlan",
                      "193-19491946",
                    ),
                    _buildPassengerItem(
                      "Muhammad Rafli Dahlan",
                      "193-19491947",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                "Check-In Procedures",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProcedureCard(
                    title: "Web Check-In",
                    content: const TextSpan(
                      text:
                          "Tersedia 48 jam sebelum keberangkatan via flyadeal app atau web",
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildProcedureCard(
                    title: "Check-In Counter",
                    content: const TextSpan(
                      children: [
                        TextSpan(text: "Check-In Counter akan ditutup di "),
                        TextSpan(
                          text: "60 menit",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: " sebelum keberangkatan"),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildProcedureCard(
                    title: "Boarding Gate",
                    content: const TextSpan(
                      children: [
                        TextSpan(text: "Boarding Gate akan ditutup di "),
                        TextSpan(
                          text: "30 menit",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: " sebelum keberangkatan"),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: PrimaryGradientButton(
            text: 'Unduh Tiket Digital',
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  Widget _buildFlightCard({
    required String flightNo,
    required String date,
    required String originCode,
    required String originCity,
    required String originTime,
    required String destCode,
    required String destCity,
    required String destTime,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF4F9FF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Text(
                  flightNo,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0084FF),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: 1,
                    height: 12,
                    color: Colors.grey.shade300,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const Spacer(),
                const Icon(Icons.work_outline, size: 12, color: Colors.black54),
                const SizedBox(width: 4),
                const Text(
                  "25 Kg",
                  style: TextStyle(fontSize: 10, color: Colors.black54),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.fastfood_outlined,
                  size: 12,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        originCode,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        originCity,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        originTime,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005C99),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF0084FF),
                            width: 2,
                          ),
                        ),
                      ),
                      Expanded(
                        child: CustomPaint(
                          painter: _DashedLinePainter(),
                          size: const Size(double.infinity, 1),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.flight,
                          color: Color(0xFF005C99),
                          size: 24,
                        ),
                      ),
                      Expanded(
                        child: CustomPaint(
                          painter: _DashedLinePainter(),
                          size: const Size(double.infinity, 1),
                        ),
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF0084FF),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        destCode,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        destCity,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        destTime,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005C99),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerItem(String name, String ticketNo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade200,
            child: const Icon(Icons.person, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Ticket: $ticketNo",
                  style: const TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Color(0xFF1E8A00), size: 24),
        ],
      ),
    );
  }

  Widget _buildProcedureCard({
    required String title,
    required InlineSpan content,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Color(0xFF005C99),
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF005C99),
                  height: 1.4,
                ),
                children: [content],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    double startX = 0;
    const dashWidth = 4.0;
    const dashSpace = 3.0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
