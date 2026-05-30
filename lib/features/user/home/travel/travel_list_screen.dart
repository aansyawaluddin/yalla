import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/models/travel_model.dart';
import 'package:yalla/core/providers/travel_provider.dart';
import 'package:yalla/core/widgets/eror/error_state_widget.dart';
import 'package:yalla/core/widgets/travel/large_card_travel.dart';
import 'package:yalla/core/widgets/travel/rating_banner.dart';
import 'package:yalla/core/widgets/travel/small_card_travel.dart';

class TravelListScreen extends StatefulWidget {
  const TravelListScreen({super.key});

  @override
  State<TravelListScreen> createState() => _TravelListScreenState();
}

class _TravelListScreenState extends State<TravelListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TravelProvider>().fetchTravels();
    });
  }

  List<Widget> _buildDynamicTravelGrid(List<TravelModel> travels) {
    List<Widget> widgets = [];

    for (int i = 0; i < travels.length; i += 2) {
      final travel1 = travels[i];
      final travel2 = (i + 1 < travels.length) ? travels[i + 1] : null;

      widgets.add(
        Row(
          children: [
            Expanded(
              child: SmallTravelCard(
                title: travel1.fullName,
                rating: travel1.averageScore,
                reviews: "${travel1.totalRatings}",
                avatarUrl: travel1.avatarUrl,
              ),
            ),
            const SizedBox(width: 16),
            if (travel2 != null)
              Expanded(
                child: SmallTravelCard(
                  title: travel2.fullName,
                  rating: travel2.averageScore,
                  reviews: "${travel2.totalRatings}",
                  avatarUrl: travel1.avatarUrl,
                ),
              )
            else
              const Expanded(child: SizedBox()),
          ],
        ),
      );

      widgets.add(const SizedBox(height: 16));

      if (i == 0) {
        widgets.add(const RatingBanner());
        widgets.add(const SizedBox(height: 16));
      }
    }

    return widgets;
  }

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
      body: Consumer<TravelProvider>(
        builder: (context, travelProvider, child) {
          if (travelProvider.isLoading && travelProvider.travels.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF005C99)),
            );
          }

          if (travelProvider.errorMessage.isNotEmpty &&
              travelProvider.travels.isEmpty) {
            return ErrorStateWidget(
              errorMessage: travelProvider.errorMessage,
              onRetry: () => travelProvider.fetchTravels(),
            );
          }

          if (travelProvider.travels.isEmpty) {
            return const Center(
              child: Text(
                "Daftar travel belum tersedia saat ini.",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LargeTravelCard(),
                const SizedBox(height: 16),

                ..._buildDynamicTravelGrid(travelProvider.travels),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
