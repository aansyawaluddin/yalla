import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';

class HotelInfoCard extends StatelessWidget {
  const HotelInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.defaultShadow,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.white,
            AppColors.lightBlue.withOpacity(0.2),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                image: const DecorationImage(
                  image: AssetImage('assets/images/hotel_room.png'),
                  fit: BoxFit.cover,
                ),
                color: Colors.grey.shade300,
              ),
            ),
          ),
          const SizedBox(height: 45),
        ],
      ),
    );
  }
}
