import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/models/travel_model.dart';
import 'package:yalla/core/providers/travel_provider.dart';
import 'package:yalla/core/widgets/eror/error_state_widget.dart';
import 'package:yalla/core/widgets/travel/rating_banner.dart';
import 'package:yalla/features/user/home/travel/travel_profile_screen.dart';

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
              child: _buildSmallTravelCard(
                title: travel1.fullName,
                rating: travel1.averageScore,
                reviews: "${travel1.totalRatings}",
                avatarUrl: travel1.avatarUrl,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UserTravelProfileScreen(travelId: travel1.id),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            if (travel2 != null)
              Expanded(
                child: _buildSmallTravelCard(
                  title: travel2.fullName,
                  rating: travel2.averageScore,
                  reviews: "${travel2.totalRatings}",
                  avatarUrl: travel2.avatarUrl,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserTravelProfileScreen(travelId: travel2.id),
                      ),
                    );
                  },
                ),
              )
            else
              const Expanded(child: SizedBox()),
          ],
        ),
      );

      widgets.add(const SizedBox(height: 16));

      // Menambahkan banner setelah baris pertama grid (opsional)
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
              color: Colors.white,
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

          // 1. Salin data agar tidak merubah state provider secara langsung
          List<TravelModel> sortedTravels = List.from(travelProvider.travels);

          // 2. Urutkan berdasarkan rating tertinggi ke terendah
          sortedTravels.sort(
            (a, b) => b.averageScore.compareTo(a.averageScore),
          );

          // 3. Ambil travel terbaik untuk Large Card
          final bestTravel = sortedTravels.first;

          // 4. Sisa travel dimasukkan ke Small Cards
          final remainingTravels = sortedTravels.length > 1
              ? sortedTravels.sublist(1)
              : <TravelModel>[];

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Besar untuk Travel Terbaik
                _buildLargeTravelCard(bestTravel),
                const SizedBox(height: 16),

                // Grid Card Kecil untuk sisa Travel
                ..._buildDynamicTravelGrid(remainingTravels),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  // =========================================================================
  // WIDGET INTERNAL
  // =========================================================================

  Widget _buildLargeTravelCard(TravelModel travel) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserTravelProfileScreen(travelId: travel.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar / Logo
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: (travel.avatarUrl.isNotEmpty)
                        ? Image.network(
                            travel.avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.store,
                              size: 30,
                              color: Colors.grey,
                            ),
                          )
                        : const Icon(Icons.store, size: 30, color: Colors.grey),
                  ),
                ),

                // Badge Terverifikasi
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0099FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.verified, color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text(
                        "Terbaik",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
                const SizedBox(width: 4),
                Text(
                  "${travel.averageScore}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  "(${travel.totalRatings} Ulasan)",
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Judul
            Text(
              travel.fullName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Deskripsi (Statik untuk contoh, bisa diganti dengan data asli jika ada)
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text:
                        "Penyelenggara perjalanan ibadah umrah yang berkomitmen memberikan pelayanan terbaik dengan prinsip amanah dan profesional. ",
                  ),
                  TextSpan(
                    text: "Lihat Profil...",
                    style: TextStyle(
                      color: Color(0xFF0099FF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallTravelCard({
    required String title,
    required double rating,
    required String reviews,
    required String avatarUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: (avatarUrl.isNotEmpty)
                        ? Image.network(
                            avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.store,
                              size: 20,
                              color: Colors.grey,
                            ),
                          )
                        : const Icon(Icons.store, size: 20, color: Colors.grey),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0099FF),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0099FF).withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 10),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFFFC107), size: 14),
                const SizedBox(width: 4),
                Text(
                  "$rating",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  "($reviews)",
                  style: const TextStyle(color: Colors.black54, fontSize: 9),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
