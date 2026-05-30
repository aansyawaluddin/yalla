import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/providers/package_provider.dart';
import 'package:yalla/core/providers/travel_provider.dart';
import 'package:yalla/core/widgets/eror/error_state_widget.dart';
import 'package:yalla/features/user/home/paket/detail_paket_screen.dart';

class UserTravelProfileScreen extends StatefulWidget {
  final String travelId;

  const UserTravelProfileScreen({super.key, required this.travelId});

  @override
  State<UserTravelProfileScreen> createState() =>
      _UserTravelProfileScreenState();
}

class _UserTravelProfileScreenState extends State<UserTravelProfileScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ["Tentang", "Paket", "Galeri", "Ulasan"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.travelId.isNotEmpty) {
        context.read<TravelProvider>().getTravelProfileById(widget.travelId);
        context.read<PackageProvider>().getPackages(widget.travelId);
      }
    });
  }

  String _formatPrice(int price) {
    String priceStr = price.toString();
    String result = '';
    int count = 0;
    for (int i = priceStr.length - 1; i >= 0; i--) {
      result = priceStr[i] + result;
      count++;
      if (count % 3 == 0 && i != 0) {
        result = '.$result';
      }
    }
    return result;
  }

  String _formatDate(String isoDate) {
    if (isoDate.isEmpty) return "-";
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      String monthName = months[dt.month - 1];
      return "${dt.day} $monthName ${dt.year}";
    } catch (e) {
      return isoDate.split('T').first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final travelProvider = context.watch<TravelProvider>();
    final profileData = travelProvider.selectedTravelProfile;
    final bool isLoading = travelProvider.isProfileLoading;
    final String companyName = profileData?.companyName ?? "Memuat...";
    final String avatarUrl = profileData?.avatarUrl ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 62,
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
          "Profil Travel",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF0084FF)),
            )
          : travelProvider.errorMessage.isNotEmpty && profileData == null
          ? ErrorStateWidget(
              errorMessage: travelProvider.errorMessage,
              onRetry: () => context
                  .read<TravelProvider>()
                  .getTravelProfileById(widget.travelId),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/kaabah.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.white],
                        stops: [0.6, 1.0],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          image: DecorationImage(
                            image: avatarUrl.isNotEmpty
                                ? NetworkImage(avatarUrl) as ImageProvider
                                : const AssetImage(
                                    'assets/images/logo_flydeal.png',
                                  ),
                            fit: BoxFit.cover,
                            onError: (_, __) {},
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    companyName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.verified,
                                  color: Color(0xFF0084FF),
                                  size: 18,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Izin: ${profileData?.licenseNumber ?? '-'}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Beroperasi sejak ${profileData?.operatingYear ?? '-'}",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        _buildCustomTabBar(),

                        if (_selectedTabIndex == 0)
                          _buildTentangTab(profileData?.aboutText, companyName),

                        if (_selectedTabIndex == 1) _buildPaketTab(),
                        if (_selectedTabIndex == 2) _buildGaleriTab(),
                        if (_selectedTabIndex == 3) _buildUlasanTab(),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCustomTabBar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_tabs.length, (index) {
              bool isActive = _selectedTabIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Text(
                        _tabs[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isActive
                              ? const Color(0xFF005C99)
                              : Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 2,
                        width: 50,
                        color: isActive
                            ? const Color(0xFF005C99)
                            : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }

  Widget _buildTentangTab(String? aboutText, String companyName) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tentang $companyName",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            aboutText ?? "Belum ada deskripsi profil untuk travel ini.",
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          _buildInfoCard(
            icon: Icons.security_outlined,
            title: "Penyedia Terpercaya",
            desc:
                "Berlisensi penuh dan terverifikasi oleh Kementerian\nAgama Republik Indonesia",
          ),
          _buildInfoCard(
            icon: Icons.diamond_outlined,
            title: "Kenyamanan Premium",
            desc: "Bermitra dengan Hotel bintang-5 terdekat",
          ),
          _buildInfoCard(
            icon: Icons.headset_mic_outlined,
            title: "Layanan 24/7",
            desc:
                "Mutawwif dan staf lapangan yang berdedikasi siap\nmembantu Anda sepanjang waktu.",
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFF0F8FF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF0084FF), size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaketTab() {
    return Consumer<PackageProvider>(
      builder: (context, packageProvider, child) {
        if (packageProvider.isFetching) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF0084FF)),
            ),
          );
        }

        if (packageProvider.errorMessage.isNotEmpty &&
            packageProvider.packages.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: ErrorStateWidget(
              errorMessage: packageProvider.errorMessage,
              onRetry: () => packageProvider.getPackages(widget.travelId),
            ),
          );
        }

        if (packageProvider.packages.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: Text(
                "Travel ini belum memiliki penawaran paket.",
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: packageProvider.packages.map((paket) {
              final originalPrice = (paket.price * 1.1).toInt();

              List<String> facilityNames = [];
              if (paket.facilities != null && paket.facilities!.isNotEmpty) {
                facilityNames = paket.facilities!
                    .take(3)
                    .map((e) => e.name)
                    .toList();
              } else {
                facilityNames = ["Fasilitas Standar"];
              }

              String displayDate = _formatDate(
                paket.departureFlight?.departureTime ?? '',
              );

              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _buildPaketCard(
                  packageId: paket.id ?? '',
                  imageUrl: 'assets/images/kaabah.jpeg',
                  title: paket.packageName,
                  subtitle:
                      "${paket.durationDays} Hari - Keberangkatan: $displayDate",
                  isBestSeller: true,
                  features: facilityNames,
                  originalPrice: "IDR ${_formatPrice(originalPrice)}",
                  discountPrice: "IDR ${_formatPrice(paket.price)}",
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildPaketCard({
    required String packageId,
    required String imageUrl,
    required String title,
    required String subtitle,
    required bool isBestSeller,
    required List<String> features,
    required String originalPrice,
    required String discountPrice,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (isBestSeller)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0099FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.verified, color: Colors.white, size: 10),
                            SizedBox(width: 4),
                            Text(
                              "Best Seller",
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
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: features.map((feature) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F8FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0099FF),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          originalPrice,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red.shade400,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              discountPrice,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.black87,
                              ),
                            ),
                            const Text(
                              "/pax",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailPaketScreen(packageId: packageId),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0099FF),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text(
                          "Lihat Tawaran",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGaleriTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        children: [
          _buildGalleryImage(
            'assets/images/kaabah.jpeg',
            height: 140,
            width: double.infinity,
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildGalleryImage(
                  'assets/images/kaabah.jpeg',
                  height: 120,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGalleryImage(
                  'assets/images/kaabah.jpeg',
                  height: 120,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          GestureDetector(
            onTap: () {},
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildGalleryImage(
                  'assets/images/kaabah.jpeg',
                  height: 140,
                  width: double.infinity,
                ),

                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3), // Lapisan gelap
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 4.0,
                        sigmaY: 4.0,
                      ), // Efek blur
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ),

                // Teks Angka
                const Text(
                  "+24",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryImage(
    String imagePath, {
    required double height,
    double? width,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        imagePath,
        height: height,
        width: width,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildUlasanTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    "4.9",
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.0,
                      shadows: [
                        Shadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(
                      5,
                      (index) => const Icon(
                        Icons.star,
                        color: Color(0xFFFFB800),
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "2.4k Ulasan",
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),

              const SizedBox(width: 24),

              Expanded(
                child: Column(
                  children: [
                    _buildRatingBar(5, 0.90, "90%"),
                    _buildRatingBar(4, 0.35, "35%"),
                    _buildRatingBar(3, 0.29, "29%"),
                    _buildRatingBar(2, 0.21, "21%"),
                    _buildRatingBar(1, 0.08, "8%"),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          _buildReviewItem(
            name: "Zain Al Husein",
            timeAndPackage: "2 Minggu Lalu - Ramadhan Special Umrah",
            rating: 5,
            reviewText:
                "Pelayanan dari travel ini sangat memuaskan. Timnya responsif dan membantu selama proses pendaftaran hingga keberangkatan. Fasilitas hotel dan penerbangan juga sesuai dengan yang dijanjikan.",
            avatarPath: 'assets/images/profile.png',
          ),

          _buildReviewItem(
            name: "Zain Al Husein",
            timeAndPackage: "2 Minggu Lalu - Ramadhan Special Umrah",
            rating: 5,
            reviewText:
                "Pelayanan dari travel ini sangat memuaskan. Timnya responsif dan membantu selama proses pendaftaran hingga keberangkatan. Fasilitas hotel dan penerbangan juga sesuai dengan yang dijanjikan.",
            avatarPath: 'assets/images/profile.png',
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int star, double value, String percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.star, color: Color(0xFFFFB800), size: 10),
          const SizedBox(width: 4),
          Text(
            star.toString(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: const Color(0xFFE5F0FF),
              color: const Color(0xFF005C99),
              minHeight: 4,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 28,
            child: Text(
              percentage,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String name,
    required String timeAndPackage,
    required int rating,
    required String reviewText,
    required String avatarPath,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Foto Profil Reviewer
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(avatarPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeAndPackage,
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: const Color(0xFFFFB800),
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Teks Ulasan dengan tanda kutip
        Text(
          "\"$reviewText\"",
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black54,
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
