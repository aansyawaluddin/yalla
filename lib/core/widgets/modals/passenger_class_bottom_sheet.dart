import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';
import 'package:yalla/core/widgets/button/primary_gradient_button.dart';

class PassengerClassBottomSheet extends StatefulWidget {
  const PassengerClassBottomSheet({super.key});

  @override
  State<PassengerClassBottomSheet> createState() =>
      _PassengerClassBottomSheetState();
}

class _PassengerClassBottomSheetState extends State<PassengerClassBottomSheet> {
  int _dewasa = 1;
  int _anak = 1;
  int _bayi = 1;
  String _selectedKelas = 'Ekonomi';

  @override
  Widget build(BuildContext context) {
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
                        child: Text(
                          "Penumpang & Kelas",
                          style: AppTypography.bold18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Penumpang",
                        style: AppTypography.bold14.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 24),

                      _buildCounterRow("Dewasa", "Usia +12 thn", _dewasa, (
                        val,
                      ) {
                        if (val >= 1) setState(() => _dewasa = val);
                      }),
                      const SizedBox(height: 24),

                      _buildCounterRow("Anak", "Usia 2 - 11 thn", _anak, (val) {
                        if (val >= 0) setState(() => _anak = val);
                      }),
                      const SizedBox(height: 24),

                      _buildCounterRow("Bayi", "Dibawah 2 thn", _bayi, (val) {
                        if (val >= 0) setState(() => _bayi = val);
                      }),

                      const SizedBox(height: 32),
                      Text(
                        "Kelas",
                        style: AppTypography.bold14.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 16),

                      // Toggle Kelas
                      Row(
                        children: [
                          Expanded(child: _buildClassOption("Ekonomi")),
                          const SizedBox(width: 12),
                          Expanded(child: _buildClassOption("Bisnis")),
                        ],
                      ),
                    ],
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
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryGradientButton(
                    text: "Terapkan",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Menampilkan 12 dari 48 hasil penerbangan",
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

  Widget _buildCounterRow(
    String title,
    String subtitle,
    int count,
    Function(int) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.bold14),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTypography.regular12.copyWith(
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF4FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => onChanged(count - 1),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.remove,
                    size: 18,
                    color: count > 0 || (title == "Dewasa" && count > 1)
                        ? AppColors.textDark
                        : AppColors.textGrey.withOpacity(0.5),
                  ),
                ),
              ),
              Container(
                width: 36,
                alignment: Alignment.center,
                child: Text(count.toString(), style: AppTypography.bold14),
              ),

              GestureDetector(
                onTap: () => onChanged(count + 1),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 18,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClassOption(String className) {
    bool isSelected = _selectedKelas == className;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedKelas = className;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.lightBlue : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          className,
          style: AppTypography.bold14.copyWith(
            color: isSelected ? AppColors.textDark : AppColors.textGrey,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
