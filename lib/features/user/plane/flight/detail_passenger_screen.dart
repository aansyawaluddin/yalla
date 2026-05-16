import 'package:flutter/material.dart';
import 'package:yalla/core/models/flight_model.dart';
import 'package:yalla/core/utils/date_formatter.dart';
import 'package:yalla/core/widgets/button/primary_gradient_button.dart';
import 'package:yalla/core/widgets/snackbar/custom_snackbar.dart';
import 'package:yalla/features/user/plane/flight/payment_method_screen.dart';

class DetailPassengerScreen extends StatefulWidget {
  final FlightModel flight;

  const DetailPassengerScreen({super.key, required this.flight});

  @override
  State<DetailPassengerScreen> createState() => _DetailPassengerScreenState();
}

class _DetailPassengerScreenState extends State<DetailPassengerScreen> {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController dobC = TextEditingController();
  final TextEditingController passportNumC = TextEditingController();
  final TextEditingController passportNameC = TextEditingController();
  final TextEditingController passportIssueC = TextEditingController();
  final TextEditingController passportExpiryC = TextEditingController();

  String _selectedTitle = "Tuan";

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    dobC.dispose();
    passportNumC.dispose();
    passportNameC.dispose();
    passportIssueC.dispose();
    passportExpiryC.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller, {
    bool isPassport = false,
  }) async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isPassport ? now : DateTime(1995, 1, 1),
      firstDate: isPassport ? DateTime(2010) : DateTime(1920),
      lastDate: isPassport ? DateTime(2045) : now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0084FF),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0084FF),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      String day = picked.day.toString().padLeft(2, '0');
      String month = picked.month.toString().padLeft(2, '0');
      setState(() {
        controller.text = "${picked.year}-$month-$day";
      });
    }
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

  String _formatFullDate(String? isoDate) {
    if (isoDate == null) return "-";
    try {
      final date = DateTime.parse(isoDate).toLocal();
      const months = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];
      return "${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}";
    } catch (e) {
      return "-";
    }
  }

  void _handleNextStep() {
    if (nameC.text.isEmpty ||
        emailC.text.isEmpty ||
        phoneC.text.isEmpty ||
        dobC.text.isEmpty ||
        passportNumC.text.isEmpty ||
        passportNameC.text.isEmpty ||
        passportIssueC.text.isEmpty ||
        passportExpiryC.text.isEmpty) {
      CustomSnackBar.showError(
        context,
        title: "Form Belum Lengkap",
        message:
            "Mohon lengkapi seluruh detail data diri dan paspor bertanda bintang (*) terlebih dahulu.",
      );
      return;
    }

    Map<String, dynamic> passengerData = {
      "full_name": nameC.text.trim(),
      "email": emailC.text.trim(),
      "phone_number": phoneC.text.trim(),
      "date_of_birth": dobC.text.trim(),
      "passport_number": passportNumC.text.trim(),
      "passport_issue_date": passportIssueC.text.trim(),
      "passport_expiry_date": passportExpiryC.text.trim(),
      "passport_country_id": 100,
    };

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentMethodScreen(
          flight: widget.flight,
          passengerData: passengerData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isOutbound = widget.flight.isOutbound ?? true;
    final String originCode = isOutbound ? "UPG" : "JED";
    final String destCode = isOutbound ? "JED" : "UPG";
    final String originCity = isOutbound ? "Makassar" : "Jeddah";
    final String destCity = isOutbound ? "Jeddah" : "Makassar";

    final String depTime = DateFormatter.formatTime(
      widget.flight.departureTime,
    );
    final String depDateFull = _formatFullDate(widget.flight.departureTime);
    final String priceText = _formatPrice(widget.flight.price);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // APP BAR CUSTOM
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
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
                    "Rincian Penumpang",
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/logo_flydeal.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Flydeal Air",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.work_outline,
                                          size: 12,
                                          color: Colors.black45,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "25 Kg",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.black45,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.restaurant_menu,
                                          size: 12,
                                          color: Colors.black45,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(0xFF007BFF),
                                  ),
                                ),
                                child: const Text(
                                  "Ekonomi",
                                  style: TextStyle(
                                    color: Color(0xFF007BFF),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    originCode,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    originCity,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey.shade300,
                                          thickness: 1,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        child: Icon(
                                          Icons.flight_takeoff,
                                          color: Color(0xFF0084FF),
                                          size: 16,
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey.shade300,
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    destCode,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    destCity,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Divider(color: Colors.grey.shade100, thickness: 1),
                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 14,
                                    color: Color(0xFF0084FF),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    depDateFull,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_filled,
                                    size: 14,
                                    color: Color(0xFF0084FF),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "$depTime WITA",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
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

                    const SizedBox(height: 28),
                    const Text(
                      "Data Diri",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildCustomTextField(
                      "Nama Lengkap",
                      controller: nameC,
                      isRequired: true,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 16),
                    _buildCustomTextField(
                      "Email",
                      controller: emailC,
                      isRequired: true,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildCustomTextField(
                      "Nomor Telepon",
                      controller: phoneC,
                      isRequired: true,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildCustomTextField(
                      "Tanggal Lahir",
                      controller: dobC,
                      isRequired: true,
                      readOnly: true,
                      onTap: () => _selectDate(context, dobC),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(child: _buildTitleOption("Tuan")),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTitleOption("Nyonya")),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTitleOption("Nona")),
                      ],
                    ),
                    const SizedBox(height: 28),

                    const Text(
                      "Informasi Paspor",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildCustomTextField(
                      "Nomor Paspor",
                      controller: passportNumC,
                      keyboardType: TextInputType.text,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    _buildCustomTextField(
                      "Nama Lengkap (Sesuai Paspor)",
                      controller: passportNameC,
                      keyboardType: TextInputType.name,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    _buildCustomTextField(
                      "Tanggal Penerbitan Paspor",
                      controller: passportIssueC,
                      readOnly: true,
                      onTap: () => _selectDate(
                        context,
                        passportIssueC,
                        isPassport: true,
                      ),
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    _buildCustomTextField(
                      "Tanggal Kadaluarsa Paspor",
                      controller: passportExpiryC,
                      readOnly: true,
                      onTap: () => _selectDate(
                        context,
                        passportExpiryC,
                        isPassport: true,
                      ),
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    _buildCountrySelector(),
                    const SizedBox(height: 24),
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
              priceText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            PrimaryGradientButton(
              text: "Lanjut ke Metode Pembayaran",
              onPressed: _handleNextStep,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTextField(
    String hint, {
    required TextEditingController controller,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: InputBorder.none,
            label: RichText(
              text: TextSpan(
                text: hint,
                style: const TextStyle(color: Colors.black45, fontSize: 13),
                children: [
                  if (isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleOption(String title) {
    bool isSelected = _selectedTitle == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedTitle = title),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F8FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF0084FF) : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? const Color(0xFF0084FF) : Colors.black54,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountrySelector() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: const [
          Icon(Icons.flag, size: 16, color: Colors.red),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Indonesia",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          Icon(Icons.keyboard_arrow_down, color: Colors.black54),
        ],
      ),
    );
  }
}
