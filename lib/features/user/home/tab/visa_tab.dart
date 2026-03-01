import 'package:flutter/material.dart';
import 'package:yalla/core/widgets/inputan/standard_icon_input.dart';
import 'package:yalla/core/widgets/button/primary_gradient_button.dart';

class VisaTab extends StatelessWidget {
  const VisaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF00A2FF), width: 1.5),
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/icons/location.png',
                width: 28,
                height: 28,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.location_on,
                  color: Colors.redAccent,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),

              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Jeddah',
                      style: TextStyle(
                        color: Color(0xFF00A2FF),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const StandardIconInput(
          icon: Icons.calendar_today_outlined,
          hint: "Rencana Bulan Keberangkatan",
        ),
        const SizedBox(height: 24),
        PrimaryGradientButton(text: "Cek Syarat Visa", onPressed: () {}),
      ],
    );
  }
}
