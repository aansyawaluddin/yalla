import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart' as fp;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla/core/services/flight_service.dart';
import 'package:yalla/core/widgets/snackbar/custom_snackbar.dart';

class AdminFlightFormScreen extends StatefulWidget {
  const AdminFlightFormScreen({super.key});

  @override
  State<AdminFlightFormScreen> createState() => _AdminFlightFormScreenState();
}

class _AdminFlightFormScreenState extends State<AdminFlightFormScreen> {
  bool isManual = true;
  bool isLoading = false;

  String? _selectedFileName;
  String? _selectedFilePath;

  final _formKey = GlobalKey<FormState>();

  final _flightNoCtrl = TextEditingController();
  final _economyClassCtrl = TextEditingController();
  final _businessClassCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  DateTime? _departureTime;
  DateTime? _arrivalTime;
  bool _isOutbound = true;

  @override
  void dispose() {
    _flightNoCtrl.dispose();
    _economyClassCtrl.dispose();
    _businessClassCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<DateTime?> _pickDateTime(
    BuildContext context, {
    DateTime? initial,
  }) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF0091FF),
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (pickedDate == null) return null;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial ?? now),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF0091FF),
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (pickedTime == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Ags',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  String _formatDateTime(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = _monthNames[dt.month - 1];
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day $month ${dt.year}, $hour:$minute';
  }

  Future<void> _pickFile() async {
    try {
      fp.FilePickerResult? result = await fp.FilePicker.platform.pickFiles(
        type: fp.FileType.custom,
        allowedExtensions: ['xlsx'],
      );
      if (result != null) {
        setState(() {
          _selectedFileName = result.files.single.name;
          _selectedFilePath = result.files.single.path;
        });
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
    }
  }

  String _rawPrice = '';

  String _formatRupiah(String digits) {
    if (digits.isEmpty) return '';
    final buffer = StringBuffer();
    int count = 0;
    for (int i = digits.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
      count++;
    }
    return buffer.toString().split('').reversed.join();
  }

  void _onPriceChanged(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    _rawPrice = digits;
    if (digits.isEmpty) {
      _priceCtrl.value = const TextEditingValue(text: '');
      return;
    }
    final formatted = _formatRupiah(digits);
    _priceCtrl.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  Future<void> _simpanData() async {
    if (!isManual) {
      if (_selectedFilePath == null) {
        CustomSnackBar.showError(
          context,
          title: "File Belum Dipilih",
          message:
              "Silakan pilih dokumen Excel jadwal penerbangan terlebih dahulu!",
        );
        return;
      }

      setState(() => isLoading = true);
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token == null || token.isEmpty) {
          throw Exception("Sesi telah habis. Silakan login kembali.");
        }

        final isSuccess = await FlightService().uploadFlightExcel(
          _selectedFilePath!,
          token,
        );

        if (!mounted) return;
        if (isSuccess) {
          CustomSnackBar.showSuccess(
            context,
            title: "Jadwal Penerbangan Berhasil Ditambahkan",
            message:
                "Jadwal penerbangan telah berhasil disimpan dan kini tersedia dalam daftar.",
          );
          Navigator.pop(context);
        } else {
          CustomSnackBar.showError(
            context,
            title: "Gagal Mengunggah",
            message:
                "Terjadi kesalahan saat memproses file Excel. Silakan coba lagi.",
          );
        }
      } catch (e) {
        if (!mounted) return;
        CustomSnackBar.showError(
          context,
          title: "Terjadi Kesalahan",
          message: e.toString().replaceAll("Exception: ", ""),
        );
      } finally {
        if (mounted) setState(() => isLoading = false);
      }
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    if (_departureTime == null) {
      CustomSnackBar.showError(
        context,
        title: "Waktu Keberangkatan Kosong",
        message: "Silakan pilih waktu keberangkatan terlebih dahulu.",
      );
      return;
    }

    if (_arrivalTime == null) {
      CustomSnackBar.showError(
        context,
        title: "Waktu Kedatangan Kosong",
        message: "Silakan pilih waktu kedatangan terlebih dahulu.",
      );
      return;
    }

    if (!_arrivalTime!.isAfter(_departureTime!)) {
      CustomSnackBar.showError(
        context,
        title: "Waktu Tidak Valid",
        message: "Waktu kedatangan harus setelah waktu keberangkatan.",
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null || token.isEmpty) {
        throw Exception("Sesi telah habis. Silakan login kembali.");
      }

      final payload = {
        "flightNo": _flightNoCtrl.text.trim().toUpperCase(),
        "departureTime": _departureTime!.toUtc().toIso8601String(),
        "arrivalTime": _arrivalTime!.toUtc().toIso8601String(),
        "economyClass": int.parse(_economyClassCtrl.text.trim()),
        "businessClass": int.parse(_businessClassCtrl.text.trim()),
        "price": double.parse(_rawPrice),
        "isOutbound": _isOutbound,
      };

      final isSuccess = await FlightService().createFlight(payload, token);

      if (!mounted) return;
      if (isSuccess) {
        CustomSnackBar.showSuccess(
          context,
          title: "Penerbangan Berhasil Ditambahkan",
          message:
              "Data penerbangan telah berhasil disimpan dan kini tersedia dalam daftar.",
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.showError(
        context,
        title: "Terjadi Kesalahan",
        message: e.toString().replaceAll("Exception: ", ""),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 70,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF005C99),
              size: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Formulir Jadwal Penerbangan",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Form Content
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                "Informasi Penerbangan",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildToggleSwitch(),
                          ],
                        ),
                        const SizedBox(height: 24),

                        if (isManual) ...[
                          // Nomor Penerbangan
                          _buildTextField(
                            controller: _flightNoCtrl,
                            label: "Nomor Penerbangan",
                            hint: "Contoh: GA-123",
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9\-]'),
                              ),
                            ],
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return "Nomor penerbangan tidak boleh kosong";
                              }
                              return null;
                            },
                          ),

                          // Waktu Keberangkatan
                          _buildDateTimeField(
                            label: "Waktu Keberangkatan",
                            value: _departureTime,
                            onTap: () async {
                              final picked = await _pickDateTime(
                                context,
                                initial: _departureTime,
                              );
                              if (picked != null) {
                                setState(() => _departureTime = picked);
                              }
                            },
                          ),

                          // Waktu Kedatangan
                          _buildDateTimeField(
                            label: "Waktu Kedatangan",
                            value: _arrivalTime,
                            onTap: () async {
                              final picked = await _pickDateTime(
                                context,
                                initial:
                                    _arrivalTime ??
                                    _departureTime?.add(
                                      const Duration(hours: 1),
                                    ),
                              );
                              if (picked != null) {
                                setState(() => _arrivalTime = picked);
                              }
                            },
                          ),

                          // Kursi Ekonomi
                          _buildTextField(
                            controller: _economyClassCtrl,
                            label: "Kursi Kelas Ekonomi",
                            hint: "Contoh: 120",
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return "Jumlah kursi ekonomi tidak boleh kosong";
                              }
                              if (int.tryParse(v.trim()) == null ||
                                  int.parse(v.trim()) <= 0) {
                                return "Masukkan jumlah kursi yang valid";
                              }
                              return null;
                            },
                          ),

                          // Kursi Bisnis
                          _buildTextField(
                            controller: _businessClassCtrl,
                            label: "Kursi Kelas Bisnis",
                            hint: "Contoh: 12",
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return "Jumlah kursi bisnis tidak boleh kosong";
                              }
                              if (int.tryParse(v.trim()) == null ||
                                  int.parse(v.trim()) <= 0) {
                                return "Masukkan jumlah kursi yang valid";
                              }
                              return null;
                            },
                          ),

                          // Harga Tiket
                          _buildTextField(
                            controller: _priceCtrl,
                            label: "Harga Tiket (Rp)",
                            hint: "Contoh: 1.500.000",
                            keyboardType: TextInputType.number,
                            prefixText: "Rp ",
                            onChanged: _onPriceChanged,
                            validator: (_) {
                              if (_rawPrice.isEmpty) {
                                return "Harga tiket tidak boleh kosong";
                              }
                              final val = double.tryParse(_rawPrice);
                              if (val == null || val <= 0) {
                                return "Masukkan harga yang valid";
                              }
                              return null;
                            },
                          ),

                          // Jenis Penerbangan (isOutbound)
                          _buildOutboundToggle(),
                        ] else ...[
                          _buildDocumentUpload(),
                        ],

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Bar
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
                                      "Periksa kembali data yang telah diisi sebelum menyimpan untuk menghindari kesalahan jadwal.",
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
                        onPressed: isLoading ? null : _simpanData,
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text(
                          "Simpan",
                          style: TextStyle(
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

          // Loading Overlay
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF0091FF)),
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildToggleSwitch() {
    return Container(
      height: 30,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFF004CB9),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => setState(() => isManual = true),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isManual ? const Color(0xFF0091FF) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isManual
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: const Text(
                "Manual",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => isManual = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: !isManual ? const Color(0xFF0091FF) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: !isManual
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: const Text(
                "Dokumen",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? prefixText,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixText: prefixText,
          labelStyle: const TextStyle(color: Color(0xFF004CB9), fontSize: 14),
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF0091FF), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    final hasValue = value != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: hasValue ? const Color(0xFF0091FF) : Colors.grey.shade300,
              width: hasValue ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Color(0xFF004CB9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasValue
                          ? _formatDateTime(value)
                          : "Pilih tanggal & waktu",
                      style: TextStyle(
                        fontSize: 14,
                        color: hasValue ? Colors.black87 : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.calendar_today_outlined,
                color: hasValue
                    ? const Color(0xFF0091FF)
                    : Colors.grey.shade400,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutboundToggle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Jenis Penerbangan",
            style: TextStyle(
              color: Color(0xFF004CB9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildSelectionChip(
                label: "Outbound (Berangkat)",
                icon: Icons.flight_takeoff_rounded,
                selected: _isOutbound,
                onTap: () => setState(() => _isOutbound = true),
              ),
              const SizedBox(width: 12),
              _buildSelectionChip(
                label: "Inbound (Pulang)",
                icon: Icons.flight_land_rounded,
                selected: !_isOutbound,
                onTap: () => setState(() => _isOutbound = false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionChip({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF0091FF).withOpacity(0.08)
                : Colors.transparent,
            border: Border.all(
              color: selected ? const Color(0xFF0091FF) : Colors.grey.shade300,
              width: selected ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected
                    ? const Color(0xFF0091FF)
                    : Colors.grey.shade500,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    color: selected
                        ? const Color(0xFF004CB9)
                        : Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentUpload() {
    final hasFile = _selectedFileName != null;
    return GestureDetector(
      onTap: _pickFile,
      child: CustomPaint(
        painter: DashedRectPainter(
          color: hasFile ? const Color(0xFF0091FF) : Colors.grey.shade400,
          strokeWidth: 1.5,
          dashWidth: 6.0,
          dashSpace: 4.0,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 80.0),
          color: hasFile
              ? const Color(0xFF0091FF).withOpacity(0.05)
              : Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                hasFile ? Icons.insert_drive_file : Icons.upload_outlined,
                size: 32,
                color: hasFile ? const Color(0xFF0091FF) : Colors.black,
              ),
              const SizedBox(height: 16),
              Text(
                hasFile
                    ? _selectedFileName!
                    : "Upload File Jadwal Penerbangan (.xlsx)",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: hasFile ? const Color(0xFF004CB9) : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (!hasFile)
                const Text(
                  "Maksimal ukuran file (5MB)",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                )
              else
                const Text(
                  "Ketuk untuk mengganti file",
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DashedRectPainter({
    this.color = Colors.grey,
    this.strokeWidth = 1.0,
    this.dashWidth = 5.0,
    this.dashSpace = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
    startX = size.width;
    while (startX > 0) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX - dashWidth, size.height),
        paint,
      );
      startX -= dashWidth + dashSpace;
    }
    startY = size.height;
    while (startY > 0) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY - dashWidth), paint);
      startY -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
