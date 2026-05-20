import 'package:flutter/material.dart';
import 'package:yalla/core/models/flight_model.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';
import 'package:yalla/core/widgets/button/primary_gradient_button.dart';

class CalendarBottomSheet extends StatefulWidget {
  final List<FlightModel> flights;
  final bool isOutbound;

  const CalendarBottomSheet({
    super.key,
    required this.flights,
    required this.isOutbound,
  });

  @override
  State<CalendarBottomSheet> createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  DateTime? _selectedDate;
  late bool _detectedIsOutbound;
  final Map<String, bool> _outboundDates = {};
  final Map<String, bool> _inboundDates = {};

  final List<String> _bulanIndo = [
    "",
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember",
  ];

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _detectedIsOutbound = widget.isOutbound;

    for (var flight in widget.flights) {
      if (flight.departureTime != null) {
        final dateKey = flight.departureTime!.substring(0, 10);
        if (flight.isOutbound == true) _outboundDates[dateKey] = true;
        if (flight.isOutbound == false) _inboundDates[dateKey] = true;
      }
    }
  }

  String _formatDateOnly(DateTime dt) {
    String pad(int n) => n.toString().padLeft(2, '0');
    return "${dt.year}-${pad(dt.month)}-${pad(dt.day)}";
  }

  /// Auto-detect isOutbound dari tanggal yang dipilih:
  /// - Hanya ada outbound → true
  /// - Hanya ada inbound  → false
  /// - Keduanya ada / tidak ada → ikuti widget.isOutbound
  bool _detectIsOutbound(String dateKey) {
    final hasOutbound = _outboundDates.containsKey(dateKey);
    final hasInbound = _inboundDates.containsKey(dateKey);

    if (hasInbound && !hasOutbound) return false;
    if (hasOutbound && !hasInbound) return true;
    return widget.isOutbound;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          // Decorative glow top-right
          Positioned(
            top: -50,
            right: -50,
            child: IgnorePointer(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightBlue.withOpacity(0.15),
                      blurRadius: 80,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Decorative glow mid-left
          Positioned(
            top: 250,
            left: -80,
            child: IgnorePointer(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightBlue.withOpacity(0.15),
                      blurRadius: 80,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textDark),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text("Kalender", style: AppTypography.bold18),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Legend
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem(AppColors.lightBlue, "UPG → JED"),
                    const SizedBox(width: 16),
                    _buildLegendItem(Colors.orange, "JED → UPG"),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Scrollable months
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(5, (index) {
                      DateTime monthToShow = DateTime(
                        now.year,
                        now.month + index,
                        1,
                      );
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: _buildMonthCalendar(monthToShow),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: 32,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: _detectedIsOutbound
                          ? AppColors.lightBlue.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _detectedIsOutbound
                                ? AppColors.lightBlue
                                : Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _detectedIsOutbound ? "UPG → JED" : "JED → UPG",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _detectedIsOutbound
                                ? AppColors.lightBlue
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),

                  PrimaryGradientButton(
                    text: "Terapkan",
                    onPressed: () {
                      Navigator.pop(context, {
                        'date': _selectedDate,
                        'isOutbound': _detectedIsOutbound,
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _selectedDate != null
                        ? "Tanggal dipilih: ${_selectedDate!.day} ${_bulanIndo[_selectedDate!.month]} ${_selectedDate!.year}"
                        : "Silakan pilih tanggal",
                    style: AppTypography.regular12.copyWith(
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthCalendar(DateTime monthDate) {
    String monthName = _bulanIndo[monthDate.month];
    String year = monthDate.year.toString();

    int totalDays = DateTime(monthDate.year, monthDate.month + 1, 0).day;
    int emptyDaysAtStart =
        DateTime(monthDate.year, monthDate.month, 1).weekday - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: AppTypography.bold18,
              children: [
                TextSpan(
                  text: "$monthName ",
                  style: const TextStyle(color: AppColors.secondary),
                ),
                TextSpan(
                  text: year,
                  style: const TextStyle(color: AppColors.textDark),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: ["S", "S", "R", "K", "J", "S", "M"]
                  .map(
                    (day) => Expanded(
                      child: Center(
                        child: Text(day, style: AppTypography.bold12),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          _buildDatesGrid(monthDate, emptyDaysAtStart, totalDays),
        ],
      ),
    );
  }

  Widget _buildDatesGrid(
    DateTime monthDate,
    int emptyDaysAtStart,
    int totalDays,
  ) {
    List<TableRow> rows = [];
    List<Widget> currentCells = [];

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    for (int i = 0; i < emptyDaysAtStart; i++) {
      currentCells.add(Container(height: 48));
    }

    for (int i = 1; i <= totalDays; i++) {
      DateTime cellDate = DateTime(monthDate.year, monthDate.month, i);
      String formattedCellDate = _formatDateOnly(cellDate);

      bool isPastDate = cellDate.isBefore(today);
      bool isSelected =
          _selectedDate != null &&
          _selectedDate!.year == cellDate.year &&
          _selectedDate!.month == cellDate.month &&
          _selectedDate!.day == cellDate.day;

      bool hasOutbound = _outboundDates.containsKey(formattedCellDate);
      bool hasInbound = _inboundDates.containsKey(formattedCellDate);

      Color selectedBgColor = const Color(0xFFEAF4FF);
      Color selectedTextColor = AppColors.lightBlue;

      if (isSelected) {
        if (_detectedIsOutbound) {
          selectedBgColor = AppColors.lightBlue.withOpacity(0.12);
          selectedTextColor = AppColors.lightBlue;
        } else {
          selectedBgColor = Colors.orange.withOpacity(0.12);
          selectedTextColor = Colors.orange;
        }
      }

      currentCells.add(
        GestureDetector(
          onTap: isPastDate
              ? null
              : () {
                  setState(() {
                    _selectedDate = cellDate;
                    _detectedIsOutbound = _detectIsOutbound(formattedCellDate);
                  });
                },
          child: Container(
            height: 48,
            color: isSelected ? selectedBgColor : Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  i.toString(),
                  style: AppTypography.bold14.copyWith(
                    color: isPastDate
                        ? AppColors.textGrey.withOpacity(0.5)
                        : (isSelected ? selectedTextColor : AppColors.textDark),
                  ),
                ),
                if (hasOutbound || hasInbound) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (hasOutbound)
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: AppColors.lightBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      if (hasOutbound && hasInbound) const SizedBox(width: 3),
                      if (hasInbound)
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ] else ...[
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),
        ),
      );

      if (currentCells.length == 7) {
        rows.add(TableRow(children: currentCells));
        currentCells = [];
      }
    }

    if (currentCells.isNotEmpty) {
      while (currentCells.length < 7) {
        currentCells.add(Container(height: 48));
      }
      rows.add(TableRow(children: currentCells));
    }

    return Table(
      border: TableBorder.all(color: const Color(0xFFE5E5E5), width: 1.0),
      children: rows,
    );
  }
}
