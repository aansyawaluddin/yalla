import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/models/flight_model.dart';
import 'package:yalla/core/models/travel_model.dart';
import 'package:yalla/core/providers/flight_provider.dart';
import 'package:yalla/core/providers/travel_provider.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';
import 'package:yalla/features/user/plane/flight/detail_flight_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final List<Map<String, dynamic>> _defaultResults = [
    {
      "prefix": "Penerbangan ke",
      "city": "Jeddah",
      "code": "(JED)",
      "subtitle": "Makkah, Arab Saudi",
      "icon": "assets/icons/plane_3d.png",
      "type": "suggestion",
    },
    {
      "prefix": "Penerbangan ke",
      "city": "Makassar",
      "code": "(UPG)",
      "subtitle": "Makassar, Indonesia",
      "icon": "assets/icons/plane_3d.png",
      "type": "suggestion",
    },
    {
      "prefix": "Hotel di",
      "city": "Jeddah",
      "code": "(JED)",
      "subtitle": "Makkah, Arab Saudi",
      "icon": "assets/icons/hotel.png",
      "type": "suggestion",
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredResults(
    List<FlightModel> flights,
    List<TravelModel> travels,
  ) {
    if (_searchQuery.trim().isEmpty) {
      return _defaultResults;
    }

    final String query = _searchQuery.trim().toLowerCase();
    List<Map<String, dynamic>> results = [];

    for (var flight in flights) {
      final bool isOutbound = flight.isOutbound ?? true;
      final String destCity = isOutbound ? "Jeddah" : "Makassar";
      final String destCode = isOutbound ? "JED" : "UPG";
      final String flightNo = flight.flightNo ?? "";

      if (flightNo.toLowerCase().contains(query) ||
          destCity.toLowerCase().contains(query) ||
          destCode.toLowerCase().contains(query)) {
        results.add({
          "prefix": "Pesawat",
          "city": destCity,
          "code": "($destCode)",
          "subtitle": "No. Penerbangan: $flightNo",
          "icon": "assets/icons/plane_3d.png",
          "type": "flight",
          "data": flight, 
        });
      }
    }

    for (var travel in travels) {
      final String travelName = travel.fullName;

      if (travelName.toLowerCase().contains(query)) {
        results.add({
          "prefix": "Travel",
          "city": travelName,
          "code": "",
          "subtitle":
              "Rating: ${travel.averageScore} (${travel.totalRatings} ulasan)",
          "icon": "assets/icons/kaabah.jpeg", 
          "type": "travel",
          "data": travel,
        });
      }
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    final flightProvider = context.watch<FlightProvider>();
    final travelProvider = context.watch<TravelProvider>();

    final searchResults = _getFilteredResults(
      flightProvider.flights,
      travelProvider.travels,
    );

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildHeader(context),
            const SizedBox(height: 16),
            Expanded(child: _buildSearchResults(searchResults)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.line, width: 1.0),
                color: Colors.transparent,
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.lightBlue,
                  size: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Hero(
              tag: 'search_bar_hero',
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: AppColors.line, width: 1.5),
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: AppTypography.bold14.copyWith(
                      color: AppColors.textDark,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari penerbangan atau travel...',
                      hintStyle: AppTypography.bold14.copyWith(
                        color: AppColors.textGrey,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textDark,
                        size: 20,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 18,
                                color: AppColors.textGrey,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = "";
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<Map<String, dynamic>> results) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: AppColors.line),
            const SizedBox(height: 16),
            Text(
              "Tidak ditemukan hasil untuk '$_searchQuery'",
              style: AppTypography.regular14.copyWith(
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];

        return InkWell(
          onTap: () {
            if (item['type'] == 'flight') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailFlightScreen(flight: item['data']),
                ),
              );
            } else if (item['type'] == 'travel') {
              debugPrint("Arahkan ke Detail Travel: ${item['city']}");
            } else {
              _searchController.text = item['city'];
              setState(() {
                _searchQuery = item['city'];
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Row(
              children: [
                // Ikon Pencarian
                Image.asset(
                  item['icon']!,
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.flight, color: AppColors.lightBlue),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: AppTypography.regular14.copyWith(
                            color: AppColors.textDark,
                          ),
                          children: [
                            TextSpan(text: '${item["prefix"]} '),
                            TextSpan(
                              text: item["city"],
                              style: AppTypography.bold14.copyWith(
                                color: AppColors.textDark,
                              ),
                            ),
                            if (item["code"].toString().isNotEmpty)
                              TextSpan(text: ' ${item["code"]}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['subtitle']!,
                        style: AppTypography.regular12.copyWith(
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  item['type'] == 'suggestion'
                      ? Icons.north_west
                      : Icons.chevron_right,
                  size: 16,
                  color: AppColors.line,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
