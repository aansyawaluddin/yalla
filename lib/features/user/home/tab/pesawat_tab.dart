import 'package:flutter/material.dart';
import 'package:yalla/core/widgets/inputan/location_swap_input.dart';
import 'package:yalla/core/widgets/inputan/trip_type_selector.dart';
import 'package:yalla/core/widgets/inputan/standard_icon_input.dart';
import 'package:yalla/core/widgets/button/primary_gradient_button.dart';
import 'package:yalla/core/widgets/kalender/calendar_bottom_sheet.dart';

class PesawatTab extends StatelessWidget {
  const PesawatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LocationSwapInput(),
        const SizedBox(height: 20),
        const TripTypeSelector(),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            showGeneralDialog(
              context: context,
              barrierDismissible: false,
              barrierColor: Colors.transparent,
              barrierLabel: "KalenderOverlay",
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, animation, secondaryAnimation) {
                return const Align(
                  alignment: Alignment.bottomCenter,
                  child: Material(
                    color: Colors.transparent,
                    child: CalendarBottomSheet(),
                  ),
                );
              },
              transitionBuilder: (context, animation, secondaryAnimation, child) {
                var curvedAnimation = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeIn,
                );
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(curvedAnimation),
                  child: child,
                );
              },
            );
          },
          child: const AbsorbPointer(
            child: StandardIconInput(
              icon: Icons.calendar_today_outlined,
              hint: "Pilih Tanggal",
            ),
          ),
        ),

        const SizedBox(height: 16),
        const StandardIconInput(
          icon: Icons.person_outline,
          hint: "Pilih Penumpang",
        ),
        const SizedBox(height: 24),
        PrimaryGradientButton(text: "Cari Penerbangan", onPressed: () {}),
      ],
    );
  }
}
