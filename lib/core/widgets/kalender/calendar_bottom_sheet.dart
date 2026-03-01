import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';

class CalendarBottomSheet extends StatefulWidget {
  const CalendarBottomSheet({super.key});

  @override
  State<CalendarBottomSheet> createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  DateTime? _selectedDate;

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
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime currentMonth = DateTime(now.year, now.month, 1);
    DateTime nextMonth = DateTime(now.year, now.month + 1, 1);

    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
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
                    const SizedBox(
                      width: 48,
                    ), 
                  ],
                ),
              ),
              const SizedBox(height: 16),

             // Area Scroll Kalender
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(5, (index) {
                      DateTime monthToShow = DateTime(now.year, now.month + index, 1);
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
                top: 20,
                left: 24,
                right: 24,
                bottom: 32,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: const [0.6, 0.8, 1.0],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, _selectedDate);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Terapkan",
                        style: AppTypography.bold14.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
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
                  style: const TextStyle(
                    color: AppColors.secondary,
                  ), 
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

      bool isPastDate = cellDate.isBefore(today);

      bool isSelected =
          _selectedDate != null &&
          _selectedDate!.year == cellDate.year &&
          _selectedDate!.month == cellDate.month &&
          _selectedDate!.day == cellDate.day;

      currentCells.add(
        GestureDetector(
          onTap: isPastDate
              ? null 
              : () {
                  setState(() {
                    _selectedDate = cellDate;
                  });
                },
          child: Container(
            height: 48,
            color: isSelected ? const Color(0xFFEAF4FF) : Colors.transparent,
            alignment: Alignment.center,
            child: Text(
              i.toString(),
              style: AppTypography.bold14.copyWith(
                color: isPastDate
                    ? AppColors.textGrey.withOpacity(0.5)
                    : (isSelected ? AppColors.lightBlue : AppColors.textDark),
              ),
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
      border: TableBorder.all(
        color: const Color(0xFFE5E5E5),
        width: 1.0,
      ),
      children: rows,
    );
  }
}
