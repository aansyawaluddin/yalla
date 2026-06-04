import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/models/flight_model.dart';
import 'package:yalla/core/models/package_model.dart';
import 'package:yalla/core/providers/flight_provider.dart';
import 'package:yalla/core/providers/package_provider.dart';
import 'package:yalla/core/widgets/snackbar/custom_snackbar.dart';

class EditPaketScreen extends StatefulWidget {
  final PackageModel package;

  const EditPaketScreen({super.key, required this.package});

  @override
  State<EditPaketScreen> createState() => _EditPaketScreenState();
}

class _EditPaketScreenState extends State<EditPaketScreen> {
  late TextEditingController batchC;
  late TextEditingController batchDateC;
  late TextEditingController namaPaketC;

  final List<String> _selectedFacilities = [];

  String? _selectedDepartureFlightId;
  String? _selectedReturnFlightId;

  @override
  void initState() {
    super.initState();

    // Pre-fill dari data paket yang ada
    batchC = TextEditingController(text: widget.package.batchName);
    batchDateC = TextEditingController(text: widget.package.batchDate);
    namaPaketC = TextEditingController(text: widget.package.packageName);

    _selectedDepartureFlightId = widget.package.departureFlight?.id;
    _selectedReturnFlightId = widget.package.returnFlight?.id;

    // Pre-fill fasilitas yang sudah dipilih
    if (widget.package.facilities != null) {
      for (final f in widget.package.facilities!) {
        _selectedFacilities.add(f.id);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PackageProvider>().getFacilities();
      context.read<FlightProvider>().fetchFlights();
    });
  }

  @override
  void dispose() {
    batchC.dispose();
    batchDateC.dispose();
    namaPaketC.dispose();
    super.dispose();
  }

  Future<void> _selectBatchDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (batchDateC.text.isNotEmpty) {
      try {
        initialDate = DateTime.parse(batchDateC.text);
      } catch (_) {}
    }

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF004CB9),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF004CB9),
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
        batchDateC.text = "${picked.year}-$month-$day";
      });
    }
  }

  String _formatSimpleDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return "-";
    try {
      final dt = DateTime.parse(isoDate).toLocal();
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
      return "${dt.day} ${months[dt.month - 1]} ${dt.year}";
    } catch (e) {
      return isoDate.split('T').first;
    }
  }

  Future<void> _handleSimpanPaket() async {
    if (batchC.text.isEmpty ||
        batchDateC.text.isEmpty ||
        namaPaketC.text.isEmpty ||
        _selectedDepartureFlightId == null ||
        _selectedReturnFlightId == null ||
        _selectedFacilities.isEmpty) {
      CustomSnackBar.showError(
        context,
        title: "Data Belum Lengkap",
        message:
            "Mohon lengkapi seluruh detail form, pilih rute penerbangan, dan minimal satu fasilitas.",
      );
      return;
    }

    final payload = {
      "batch_date": batchDateC.text.trim(),
      "package_name": namaPaketC.text.trim(),
      "batch_name": batchC.text.trim(),
      "departure_flight_id": _selectedDepartureFlightId,
      "return_flight_id": _selectedReturnFlightId,
      "facility_ids": _selectedFacilities,
    };

    FocusScope.of(context).unfocus();

    final packageProvider = context.read<PackageProvider>();
    final success = await packageProvider.updatePackage(
      widget.package.id ?? '',
      payload,
    );

    if (!mounted) return;

    if (success) {
      CustomSnackBar.showSuccess(
        context,
        title: "Paket Diperbarui",
        message: "Perubahan paket umrah berhasil disimpan.",
      );
      Navigator.pop(context, true); // return true agar parent bisa refresh
    } else {
      CustomSnackBar.showError(
        context,
        title: "Gagal Menyimpan",
        message: packageProvider.errorMessage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final packageProvider = context.watch<PackageProvider>();
    final isLoading = packageProvider.isLoading;

    final flightProvider = context.watch<FlightProvider>();
    final List<FlightModel> outboundFlights = flightProvider.flights
        .where((f) => f.isOutbound == true)
        .toList();
    final List<FlightModel> inboundFlights = flightProvider.flights
        .where((f) => f.isOutbound == false)
        .toList();

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            scrolledUnderElevation: 0,
            elevation: 0,
            centerTitle: true,
            leadingWidth: 62,
            leading: Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
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
            ),
            title: const Text(
              "Edit Paket",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Detail Paket"),
                const SizedBox(height: 16),

                _buildInputField(
                  label: "Nama Batch",
                  controller: batchC,
                  hint: "e.g Gelombang 1 - Agustus",
                ),
                const SizedBox(height: 16),

                _buildInputField(
                  label: "Nama Paket",
                  controller: namaPaketC,
                  hint: "e.g Umrah Hemat Bintang 3",
                ),
                const SizedBox(height: 16),

                _buildInputField(
                  label: "Tanggal Batch",
                  controller: batchDateC,
                  hint: "Pilih tanggal keberangkatan",
                  onTap: () => _selectBatchDate(context),
                ),
                const SizedBox(height: 24),

                _buildSectionTitle("Jadwal Penerbangan"),
                const SizedBox(height: 16),

                _buildFlightDropdown(
                  label: "Penerbangan Keberangkatan",
                  items: outboundFlights,
                  value: _selectedDepartureFlightId,
                  hint: "Pilih tiket keberangkatan",
                  icon: Icons.flight_takeoff,
                  onChanged: (val) {
                    setState(() => _selectedDepartureFlightId = val);
                  },
                ),
                const SizedBox(height: 16),

                _buildFlightDropdown(
                  label: "Penerbangan Kepulangan",
                  items: inboundFlights,
                  value: _selectedReturnFlightId,
                  hint: "Pilih tiket kepulangan",
                  icon: Icons.flight_land,
                  onChanged: (val) {
                    setState(() => _selectedReturnFlightId = val);
                  },
                ),

                const SizedBox(height: 32),

                _buildSectionTitle("Fasilitas"),
                const SizedBox(height: 16),
                _buildFacilitiesSection(packageProvider),

                const SizedBox(height: 100),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomBar(isLoading),
        ),

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

  Widget _buildFlightDropdown({
    required String label,
    required List<FlightModel> items,
    required String? value,
    required String hint,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(16),
          elevation: 4,
          decoration: InputDecoration(
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
              borderSide: const BorderSide(
                color: Color(0xFF0084FF),
                width: 1.5,
              ),
            ),
          ),
          hint: Text(
            hint,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((FlightModel flight) {
              String flightNo = flight.flightNo ?? 'Unknown';
              String dateText = _formatSimpleDate(flight.departureTime);
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 14, color: const Color(0xFF0084FF)),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "$dateText ($flightNo)",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              );
            }).toList();
          },
          items: items.map((flight) {
            String flightNo = flight.flightNo ?? 'Unknown';
            String dateText = _formatSimpleDate(flight.departureTime);
            return DropdownMenuItem<String>(
              value: flight.id,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade100),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(icon, size: 14, color: Colors.black87),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "$dateText ($flightNo)",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildFacilitiesSection(PackageProvider provider) {
    if (provider.isFacilitiesLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(color: Color(0xFF004CB9)),
        ),
      );
    }

    if (provider.facilities.isEmpty) {
      return const Text(
        "Gagal memuat fasilitas. Pastikan koneksi stabil.",
        style: TextStyle(color: Colors.grey, fontSize: 12),
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: provider.facilities.length,
      itemBuilder: (context, index) {
        final facility = provider.facilities[index];
        final isSelected = _selectedFacilities.contains(facility.id);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedFacilities.remove(facility.id);
              } else {
                _selectedFacilities.add(facility.id);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFE6F0FF)
                  : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF004CB9)
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? const Color(0xFF004CB9) : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF004CB9)
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    facility.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF004CB9)
                          : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF004CB9),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hint,
    String? prefixText,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: onTap != null,
          onTap: onTap,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.normal,
            ),
            prefixText: prefixText,
            prefixStyle: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
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
              borderSide: const BorderSide(
                color: Color(0xFF0084FF),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF0099FF),
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(
                          text: "Penting: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              "Pastikan seluruh data yang diisi sudah benar sebelum perubahan disimpan.",
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
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleSimpanPaket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0084FF),
                  disabledBackgroundColor: Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Simpan Perubahan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
