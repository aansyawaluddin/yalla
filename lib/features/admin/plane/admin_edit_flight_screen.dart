import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/models/flight_model.dart';
import 'package:yalla/core/providers/flight_provider.dart';
import 'package:yalla/core/utils/date_formatter.dart';

class AdminEditFlightScreen extends StatefulWidget {
  final FlightModel flight;

  const AdminEditFlightScreen({super.key, required this.flight});

  @override
  State<AdminEditFlightScreen> createState() => _AdminEditFlightScreenState();
}

class _AdminEditFlightScreenState extends State<AdminEditFlightScreen> {
  late TextEditingController _flightNoController;
  late TextEditingController _departureController;
  late TextEditingController _arrivalController;
  late TextEditingController _economyController;
  late TextEditingController _businessController;
  late TextEditingController _priceController;

  DateTime? _departureDate;
  DateTime? _arrivalDate;

  bool _isOutbound = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _flightNoController = TextEditingController(text: widget.flight.flightNo);

    if (widget.flight.departureTime != null &&
        widget.flight.departureTime!.length >= 19) {
      _departureDate = DateTime.tryParse(
        widget.flight.departureTime!.substring(0, 19),
      );
      _departureController = TextEditingController(
        text: _departureDate != null
            ? _formatDateForUI(_departureDate!)
            : widget.flight.departureTime,
      );
    } else {
      _departureController = TextEditingController(text: "");
    }

    if (widget.flight.arrivalTime != null &&
        widget.flight.arrivalTime!.length >= 19) {
      _arrivalDate = DateTime.tryParse(
        widget.flight.arrivalTime!.substring(0, 19),
      );
      _arrivalController = TextEditingController(
        text: _arrivalDate != null
            ? _formatDateForUI(_arrivalDate!)
            : widget.flight.arrivalTime,
      );
    } else {
      _arrivalController = TextEditingController(text: "");
    }

    _economyController = TextEditingController(
      text: widget.flight.economyClass?.toString() ?? '0',
    );
    _businessController = TextEditingController(
      text: widget.flight.businessClass?.toString() ?? '0',
    );

    final String initialPrice = widget.flight.price != null
        ? widget.flight.price!.toInt().toString()
        : '0';
    _priceController = TextEditingController(
      text: _formatInitialRupiah(initialPrice),
    );

    _isOutbound = widget.flight.isOutbound ?? true;
  }

  @override
  void dispose() {
    _flightNoController.dispose();
    _departureController.dispose();
    _arrivalController.dispose();
    _economyController.dispose();
    _businessController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  String _formatDateForUI(DateTime dt) {
    final String isoString = dt.toIso8601String();

    final String datePart = DateFormatter.formatDate(isoString);
    final String timePart = DateFormatter.formatTime(isoString);

    return "$datePart | $timePart";
  }

  String _formatDateForAPI(DateTime dt) {
    String pad(int n) => n.toString().padLeft(2, '0');
    return "${dt.year}-${pad(dt.month)}-${pad(dt.day)}T${pad(dt.hour)}:${pad(dt.minute)}:00+08:00";
  }

  String _formatInitialRupiah(String numericString) {
    if (numericString.isEmpty || numericString == '0') return '';
    String numericOnly = numericString.replaceAll(RegExp(r'[^0-9]'), '');
    String formatted = 'Rp ';
    int length = numericOnly.length;
    for (int i = 0; i < length; i++) {
      formatted += numericOnly[i];
      if ((length - 1 - i) % 3 == 0 && i != length - 1) formatted += '.';
    }
    return formatted;
  }

  Future<void> _selectDateTime(BuildContext context, bool isDeparture) async {
    DateTime initialDate = isDeparture
        ? (_departureDate ?? DateTime.now())
        : (_arrivalDate ?? DateTime.now());

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF004CB9)),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (!context.mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF004CB9), // Warna Jam
              ),
            ),
            child: MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            ),
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          final newDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          if (isDeparture) {
            _departureDate = newDateTime;
            _departureController.text = _formatDateForUI(newDateTime);
          } else {
            _arrivalDate = newDateTime;
            _arrivalController.text = _formatDateForUI(newDateTime);
          }
        });
      }
    }
  }

  Future<void> _simpanPerubahan() async {
    setState(() => _isLoading = true);

    final cleanPriceString = _priceController.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    final payload = {
      "flightNo": _flightNoController.text.trim(),
      "departureTime": _departureDate != null
          ? _formatDateForAPI(_departureDate!)
          : widget.flight.departureTime,
      "arrivalTime": _arrivalDate != null
          ? _formatDateForAPI(_arrivalDate!)
          : widget.flight.arrivalTime,
      "economyClass": int.tryParse(_economyController.text.trim()) ?? 0,
      "businessClass": int.tryParse(_businessController.text.trim()) ?? 0,
      "isOutbound": _isOutbound,
      "price": int.tryParse(cleanPriceString) ?? 0,
      "Price": int.tryParse(cleanPriceString) ?? 0,
    };

    debugPrint("Payload yang akan dikirim: $payload");

    final provider = context.read<FlightProvider>();
    final isSuccess = await provider.updateFlightData(
      widget.flight.id!,
      payload,
    );

    setState(() => _isLoading = false);

    if (isSuccess) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Jadwal penerbangan berhasil diperbarui!"),
        ),
      );
      Navigator.pop(context);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal memperbarui: ${provider.detailErrorMessage}"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF0091FF),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      "Edit Jadwal Penerbangan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "Aktif",
                          style: TextStyle(
                            color: Color(0xFF4CAF50),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Informasi Penerbangan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F8FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.history,
                                    size: 12,
                                    color: Color(0xFF004CB9),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    "Terakhir di modifikasi:",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF004CB9),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Baru saja",
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
                    const SizedBox(height: 24),

                    _buildDropdownRoute(),
                    _buildTextField(
                      "Nomor Penerbangan (Cth: GA-123)",
                      _flightNoController,
                    ),

                    _buildDateTimeField(
                      "Waktu Keberangkatan",
                      _departureController,
                      true,
                    ),
                    _buildDateTimeField(
                      "Waktu Kedatangan",
                      _arrivalController,
                      false,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            "Kursi Ekonomi",
                            _economyController,
                            isNumber: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            "Kursi Bisnis",
                            _businessController,
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),

                    _buildTextField(
                      "Harga Tiket",
                      _priceController,
                      isNumber: true,
                      formatters: [CurrencyInputFormatter()],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Color(0xFF0091FF),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0091FF),
                              height: 1.4,
                            ),
                            children: [
                              TextSpan(
                                text: "Penting: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    "Periksa kembali data yang telah diubah sebelum menyimpan untuk menghindari kesalahan jadwal.",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _simpanPerubahan,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.save, color: Colors.white),
                      label: Text(
                        _isLoading ? "Menyimpan..." : "Simpan",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0091FF),
                        disabledBackgroundColor: Colors.grey.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String labelText,
    TextEditingController controller, {
    bool isNumber = false,
    List<TextInputFormatter>? formatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: formatters,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Color(0xFF004CB9), fontSize: 13),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF0091FF), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeField(
    String labelText,
    TextEditingController controller,
    bool isDeparture,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        readOnly: true, // Mencegah keyboard muncul
        onTap: () => _selectDateTime(context, isDeparture), // Membuka Kalender
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Color(0xFF004CB9), fontSize: 13),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon: const Icon(
            Icons.calendar_month,
            color: Color(0xFF004CB9),
          ), // Tambahan ikon kalender
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF0091FF), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownRoute() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<bool>(
        value: _isOutbound,
        decoration: InputDecoration(
          labelText: "Rute Perjalanan",
          labelStyle: const TextStyle(color: Color(0xFF004CB9), fontSize: 13),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF0091FF), width: 1.5),
          ),
        ),
        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF004CB9)),
        items: const [
          DropdownMenuItem(
            value: true,
            child: Text(
              "Makassar (UPG) → Jeddah (JED)",
              style: TextStyle(fontSize: 14),
            ),
          ),
          DropdownMenuItem(
            value: false,
            child: Text(
              "Jeddah (JED) → Makassar (UPG)",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
        onChanged: (value) {
          setState(() => _isOutbound = value ?? true);
        },
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue.copyWith(text: '');
    String numericOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericOnly.isEmpty) return newValue.copyWith(text: '');

    String formatted = 'Rp ';
    int length = numericOnly.length;
    for (int i = 0; i < length; i++) {
      formatted += numericOnly[i];
      if ((length - 1 - i) % 3 == 0 && i != length - 1) formatted += '.';
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
