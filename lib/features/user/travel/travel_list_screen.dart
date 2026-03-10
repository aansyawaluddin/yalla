import 'package:flutter/material.dart';
import 'package:yalla/core/widgets/travel/large_card_travel.dart';
import 'package:yalla/core/widgets/travel/rating_banner.dart';
import 'package:yalla/core/widgets/travel/small_card_travel.dart';

class TravelListScreen extends StatelessWidget {
  const TravelListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
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
          "Daftar Travel",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LargeTravelCard(),

            const SizedBox(height: 16),

            Row(
              children: const [
                Expanded(
                  child: SmallTravelCard(
                    title: "Rabbani Tour",
                    rating: 4.2,
                    reviews: "2.3k",
                    logoPath: 'assets/images/logo_rabbani.png',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SmallTravelCard(
                    title: "Khazzanah Tour",
                    rating: 4.3,
                    reviews: "1.7k",
                    logoPath: 'assets/images/logo_khazzanah.png',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const RatingBanner(),

            const SizedBox(height: 16),

            Row(
              children: const [
                Expanded(
                  child: SmallTravelCard(
                    title: "Rabbani Tour",
                    rating: 4.2,
                    reviews: "2.3k",
                    logoPath: 'assets/images/logo_rabbani.png',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SmallTravelCard(
                    title: "Khazzanah Tour",
                    rating: 4.3,
                    reviews: "1.7k",
                    logoPath: 'assets/images/logo_khazzanah.png',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Expanded(
                  child: SmallTravelCard(
                    title: "Rabbani Tour",
                    rating: 4.2,
                    reviews: "2.3k",
                    logoPath: 'assets/images/logo_rabbani.png',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SmallTravelCard(
                    title: "Khazzanah Tour",
                    rating: 4.3,
                    reviews: "1.7k",
                    logoPath: 'assets/images/logo_khazzanah.png',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32), // Spacer bawah
          ],
        ),
      ),
    );
  }
}
