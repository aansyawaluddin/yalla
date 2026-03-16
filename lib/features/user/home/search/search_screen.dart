import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<Map<String, String>> _searchResults = [
    {
      "prefix": "Penerbangan ke",
      "city": "Jeddah",
      "code": "(JED)",
      "subtitle": "Makkah, Arab Saudi",
      "icon": "assets/icons/plane_3d.png",
    },
    {
      "prefix": "Penerbangan ke",
      "city": "Makassar",
      "code": "(UPG)",
      "subtitle": "Makassar, Indonesia",
      "icon": "assets/icons/plane_3d.png",
    },
    {
      "prefix": "Hotel di",
      "city": "Jeddah",
      "code": "(JED)",
      "subtitle": "Makkah, Arab Saudi",
      "icon": "assets/icons/hotel.png",
    },
    {
      "prefix": "Hotel di",
      "city": "Makassar",
      "code": "(UPG)",
      "subtitle": "Makassar, Indonesia",
      "icon": "assets/icons/hotel.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildHeader(context),
            const SizedBox(height: 16),
            Expanded(child: _buildSearchResults()),
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
              width:
                  30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.line,
                  width: 1.0,
                ), 
                color: Colors
                    .transparent, 
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.lightBlue,
                  size:
                      16, 
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
                    autofocus: true,
                    style: AppTypography.bold14.copyWith(
                      color: AppColors.textDark,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Cari',
                      hintStyle: AppTypography.bold14.copyWith(
                        color: AppColors.textDark,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textDark,
                        size: 20,
                      ),
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

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        return InkWell(
          onTap: () {
            // TODO: Aksi saat item pencarian diklik
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
              ],
            ),
          ),
        );
      },
    );
  }
}
