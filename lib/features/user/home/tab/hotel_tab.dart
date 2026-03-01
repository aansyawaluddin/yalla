import 'package:flutter/material.dart';
import 'package:yalla/core/widgets/button/primary_gradient_button.dart';
import 'package:yalla/core/widgets/inputan/standard_icon_input.dart';

class HotelTab extends StatelessWidget {
  const HotelTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF00A2FF),
              width: 1.5,
            ),
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
                      text: 'Makassar',
                      style: TextStyle(
                        color: Color(0xFF00A2FF),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: ' - UPGC',
                      style: TextStyle(
                        color: Colors.black, 
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
        const SizedBox(height: 12),
        const StandardIconInput(icon: Icons.calendar_today_outlined, hint: ""),
        const SizedBox(height: 12),

        const StandardIconInput(icon: Icons.person_outline, hint: ""),
        const SizedBox(height: 20),

        PrimaryGradientButton(text: "Cari Penginapan", onPressed: () {}),
      ],
    );
  }
}
