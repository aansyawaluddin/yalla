import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';

class TripTypeSelector extends StatefulWidget {
  const TripTypeSelector({super.key});

  @override
  State<TripTypeSelector> createState() => _TripTypeSelectorState();
}

class _TripTypeSelectorState extends State<TripTypeSelector> {
  bool _isOneWay = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _buildTripTypeButton("Sekali Jalan", true),
          _buildTripTypeButton("Pulang - Pergi", false),
        ],
      ),
    );
  }

  Widget _buildTripTypeButton(String title, bool isOneWayButton) {
    bool isSelected = _isOneWay == isOneWayButton;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isOneWay = isOneWayButton),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? null : Colors.transparent,
            gradient: isSelected
                ? const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF005C99), Color(0xFF0099FF)],
                  )
                : null,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: AppTypography.bold12.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}
