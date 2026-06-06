import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla/core/models/rating_model.dart';
import 'package:yalla/core/providers/package_provider.dart';
import 'package:yalla/core/providers/rating_provider.dart';
import 'package:yalla/core/providers/travel_provider.dart';
import 'package:yalla/core/widgets/eror/error_state_widget.dart';
import 'package:yalla/core/widgets/snackbar/custom_snackbar.dart';
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
  String _myUserId = '';
  final List<String> _tabs = ["Tentang", "Paket", "Ulasan"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;

      setState(() {
        _myUserId = prefs.getString('user_id') ?? '';
      });

      if (widget.travelId.isNotEmpty) {
        context.read<TravelProvider>().getTravelProfileById(widget.travelId);
        context.read<PackageProvider>().getPackages(widget.travelId);
        context.read<RatingProvider>().fetchStats(widget.travelId);
        context.read<RatingProvider>().fetchRatings(widget.travelId);
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

  String _formatTimeAgo(String isoDate) {
    if (isoDate.isEmpty) return '-';
    try {
      final date = DateTime.parse(isoDate).toLocal();
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays >= 365) {
        final years = (diff.inDays / 365).floor();
        return "$years Tahun Lalu";
      } else if (diff.inDays >= 30) {
        final months = (diff.inDays / 30).floor();
        return "$months Bulan Lalu";
      } else if (diff.inDays >= 7) {
        final weeks = (diff.inDays / 7).floor();
        return "$weeks Minggu Lalu";
      } else if (diff.inDays >= 1) {
        return "${diff.inDays} Hari Lalu";
      } else if (diff.inHours >= 1) {
        return "${diff.inHours} Jam Lalu";
      } else {
        return "Baru saja";
      }
    } catch (_) {
      return '-';
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
                        // if (_selectedTabIndex == 2) _buildGaleriTab(),
                        if (_selectedTabIndex == 2) _buildUlasanTab(),

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

  // Widget _buildGaleriTab() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
  //     child: Column(
  //       children: [
  //         _buildGalleryImage(
  //           'assets/images/kaabah.jpeg',
  //           height: 140,
  //           width: double.infinity,
  //         ),

  //         const SizedBox(height: 12),

  //         Row(
  //           children: [
  //             Expanded(
  //               child: _buildGalleryImage(
  //                 'assets/images/kaabah.jpeg',
  //                 height: 120,
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Expanded(
  //               child: _buildGalleryImage(
  //                 'assets/images/kaabah.jpeg',
  //                 height: 120,
  //               ),
  //             ),
  //           ],
  //         ),

  //         const SizedBox(height: 12),

  //         GestureDetector(
  //           onTap: () {},
  //           child: Stack(
  //             alignment: Alignment.center,
  //             children: [
  //               _buildGalleryImage(
  //                 'assets/images/kaabah.jpeg',
  //                 height: 140,
  //                 width: double.infinity,
  //               ),

  //               ClipRRect(
  //                 borderRadius: BorderRadius.circular(16),
  //                 child: Container(
  //                   height: 140,
  //                   width: double.infinity,
  //                   decoration: BoxDecoration(
  //                     color: Colors.black.withOpacity(0.3), // Lapisan gelap
  //                   ),
  //                   child: BackdropFilter(
  //                     filter: ImageFilter.blur(
  //                       sigmaX: 4.0,
  //                       sigmaY: 4.0,
  //                     ), // Efek blur
  //                     child: Container(color: Colors.transparent),
  //                   ),
  //                 ),
  //               ),

  //               // Teks Angka
  //               const Text(
  //                 "+24",
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildGalleryImage(
  //   String imagePath, {
  //   required double height,
  //   double? width,
  // }) {
  //   return ClipRRect(
  //     borderRadius: BorderRadius.circular(16),
  //     child: Image.asset(
  //       imagePath,
  //       height: height,
  //       width: width,
  //       fit: BoxFit.cover,
  //     ),
  //   );
  // }

  void _showReviewPopup(BuildContext context) {
    int rating = 0;
    final TextEditingController reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: const Color(0xFFFAFAFA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Bagaimana Perjalanan Anda?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Masukan Anda sangat berarti bagi kami untuk memastikan kenyamanan ibadah Anda dan jamaah lainnya di masa depan.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() => rating = index + 1);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            child: Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              color: const Color(0xFFFFB800),
                              size: 40,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: reviewController,
                            maxLines: 4,
                            minLines: 3,
                            style: const TextStyle(fontSize: 13),
                            decoration: const InputDecoration(
                              hintText: "Tulis ulasan Anda di sini...",
                              hintStyle: TextStyle(
                                color: Colors.black38,
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 8,
                              bottom: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.emoji_emotions_outlined,
                                      color: Colors.grey.shade600,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(
                                      Icons.font_download_outlined,
                                      color: Colors.grey.shade600,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(
                                      Icons.copy_outlined,
                                      color: Colors.grey.shade600,
                                      size: 20,
                                    ),
                                  ],
                                ),

                                Consumer<RatingProvider>(
                                  builder: (context, ratingProvider, _) {
                                    return IconButton(
                                      icon: const Icon(
                                        Icons.send,
                                        color: Color(0xFF005C99),
                                      ),
                                      onPressed: () async {
                                        if (rating == 0) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Pilih bintang terlebih dahulu.',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        if (reviewController.text
                                            .trim()
                                            .isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Tulis ulasan terlebih dahulu.',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        Navigator.pop(context);

                                        showDialog(
                                          context: this.context,
                                          barrierDismissible: false,
                                          builder: (_) => const Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xFF005C99),
                                            ),
                                          ),
                                        );

                                        final success = await this.context
                                            .read<RatingProvider>()
                                            .submitRating(
                                              rateeId: widget.travelId,
                                              score: rating,
                                              comment: reviewController.text
                                                  .trim(),
                                            );

                                        if (!mounted) return;

                                        Navigator.pop(this.context);

                                        if (success) {
                                          this.context
                                              .read<RatingProvider>()
                                              .fetchStats(widget.travelId);
                                          this.context
                                              .read<RatingProvider>()
                                              .fetchRatings(widget.travelId);

                                          CustomSnackBar.showSuccess(
                                            this.context,
                                            title: "Ulasan Terkirim",
                                            message:
                                                "Terima kasih atas ulasan Anda!",
                                          );
                                        } else {
                                          CustomSnackBar.showError(
                                            this.context,
                                            title: "Gagal",
                                            message: this.context
                                                .read<RatingProvider>()
                                                .errorMessage,
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
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
      },
    );
  }

  void _showEditReviewPopup(BuildContext context, RatingModel existing) {
    int rating = existing.score;
    final TextEditingController reviewController = TextEditingController(
      text: existing.comment,
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: const Color(0xFFFAFAFA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Edit Ulasan Anda",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Perbarui pengalaman Anda untuk membantu jamaah lainnya.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() => rating = index + 1);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            child: Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              color: const Color(0xFFFFB800),
                              size: 40,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: reviewController,
                            maxLines: 4,
                            minLines: 3,
                            style: const TextStyle(fontSize: 13),
                            decoration: const InputDecoration(
                              hintText: "Tulis ulasan Anda di sini...",
                              hintStyle: TextStyle(
                                color: Colors.black38,
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 8,
                              bottom: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.emoji_emotions_outlined,
                                      color: Colors.grey.shade600,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(
                                      Icons.font_download_outlined,
                                      color: Colors.grey.shade600,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(
                                      Icons.copy_outlined,
                                      color: Colors.grey.shade600,
                                      size: 20,
                                    ),
                                  ],
                                ),

                                Consumer<RatingProvider>(
                                  builder: (context, ratingProvider, _) {
                                    return IconButton(
                                      icon: const Icon(
                                        Icons.send,
                                        color: Color(0xFF005C99),
                                      ),
                                      onPressed: () async {
                                        if (rating == 0) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Pilih bintang terlebih dahulu.',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        if (reviewController.text
                                            .trim()
                                            .isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Tulis ulasan terlebih dahulu.',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        Navigator.pop(context);

                                        showDialog(
                                          context: this.context,
                                          barrierDismissible: false,
                                          builder: (_) => const Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xFF005C99),
                                            ),
                                          ),
                                        );

                                        final success = await this.context
                                            .read<RatingProvider>()
                                            .updateRating(
                                              ratingId: existing.id,
                                              score: rating,
                                              comment: reviewController.text
                                                  .trim(),
                                            );

                                        if (!mounted) return;

                                        Navigator.pop(this.context);

                                        if (success) {
                                          this.context
                                              .read<RatingProvider>()
                                              .fetchStats(widget.travelId);
                                          this.context
                                              .read<RatingProvider>()
                                              .fetchRatings(widget.travelId);

                                          CustomSnackBar.showSuccess(
                                            this.context,
                                            title: "Ulasan Diperbarui",
                                            message:
                                                "Ulasan Anda berhasil diperbarui!",
                                          );
                                        } else {
                                          CustomSnackBar.showError(
                                            this.context,
                                            title: "Gagal",
                                            message: this.context
                                                .read<RatingProvider>()
                                                .errorMessage,
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
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
      },
    );
  }

  Widget _buildUlasanTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<RatingProvider>(
            builder: (context, ratingProvider, _) {
              final stats = ratingProvider.stats;
              final isLoading = ratingProvider.isStatsLoading;

              String formatTotal(int total) {
                if (total >= 1000) {
                  final val = total / 1000;
                  final str = val == val.truncateToDouble()
                      ? val.toInt().toString()
                      : val.toStringAsFixed(1);
                  return "${str}k Ulasan";
                }
                return "$total Ulasan";
              }

              final String avgDisplay = isLoading
                  ? "-"
                  : stats.averageScore == stats.averageScore.truncateToDouble()
                  ? stats.averageScore.toInt().toString()
                  : stats.averageScore.toStringAsFixed(1);

              final int filledStars = isLoading
                  ? 0
                  : stats.averageScore.round().clamp(0, 5);

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        avgDisplay,
                        style: const TextStyle(
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
                        children: List.generate(5, (index) {
                          return Icon(
                            index < filledStars
                                ? Icons.star
                                : Icons.star_border,
                            color: const Color(0xFFFFB800),
                            size: 16,
                          );
                        }),
                      ),
                      const SizedBox(height: 4),
                      isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: Color(0xFF005C99),
                              ),
                            )
                          : Text(
                              formatTotal(stats.totalRatings),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                    ],
                  ),

                  const SizedBox(width: 24),

                  Expanded(
                    child: Builder(
                      builder: (_) {
                        final ratings = ratingProvider.ratings;
                        final total = ratings.length;

                        Map<int, int> countPerStar = {
                          5: 0,
                          4: 0,
                          3: 0,
                          2: 0,
                          1: 0,
                        };
                        for (final r in ratings) {
                          final s = r.score.clamp(1, 5);
                          countPerStar[s] = (countPerStar[s] ?? 0) + 1;
                        }

                        return Column(
                          children: [5, 4, 3, 2, 1].map((star) {
                            final count = countPerStar[star] ?? 0;
                            final percent = total > 0 ? count / total : 0.0;
                            final percentLabel = total > 0
                                ? "${(percent * 100).toStringAsFixed(0)}%"
                                : "0%";

                            return _buildRatingBar(star, percent, percentLabel);
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          Consumer<RatingProvider>(
            builder: (context, ratingProvider, _) {
              final myExistingRating = _myUserId.isNotEmpty
                  ? ratingProvider.findMyRating(_myUserId)
                  : null;
              final bool hasReviewed = myExistingRating != null;

              return SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (hasReviewed) {
                      _showEditReviewPopup(context, myExistingRating);
                    } else {
                      _showReviewPopup(context);
                    }
                  },
                  icon: Icon(
                    hasReviewed
                        ? Icons.edit_outlined
                        : Icons.rate_review_outlined,
                    size: 18,
                  ),
                  label: Text(
                    hasReviewed ? "Edit Ulasan Anda" : "Tulis Ulasan Anda",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasReviewed
                        ? const Color(0xFF005C99)
                        : const Color(0xFF0099FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // List komentar
          Consumer<RatingProvider>(
            builder: (context, ratingProvider, _) {
              if (ratingProvider.isRatingsLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF005C99),
                      strokeWidth: 2,
                    ),
                  ),
                );
              }

              if (ratingProvider.ratings.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      "Belum ada ulasan untuk travel ini.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: ratingProvider.ratings.map((rating) {
                  return _buildReviewItem(
                    rating: rating,
                    timeAgo: _formatTimeAgo(rating.createdAt),
                  );
                }).toList(),
              );
            },
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
          Icon(Icons.star, color: const Color(0xFFFFB800), size: 10),
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
          const SizedBox(width: 6),
          SizedBox(
            width: 36,
            child: Text(
              percentage,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required RatingModel rating,
    required String timeAgo,
  }) {
    final String fullName = rating.raterFullName.isNotEmpty
        ? rating.raterFullName
        : "Jamaah ${rating.raterId.length >= 6 ? rating.raterId.substring(0, 6).toUpperCase() : rating.raterId.toUpperCase()}";

    final String initial = fullName.isNotEmpty
        ? fullName[0].toUpperCase()
        : '?';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8F0FF),
                border: Border.all(color: Colors.grey.shade200),
              ),
              clipBehavior: Clip.antiAlias,
              child: rating.raterAvatarUrl.isNotEmpty
                  ? Image.network(
                      rating.raterAvatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Text(
                          initial,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF004CB9),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        initial,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004CB9),
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeAgo,
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating.score ? Icons.star : Icons.star_border,
                        color: const Color(0xFFFFB800),
                        size: 12,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '"${rating.comment}"',
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
