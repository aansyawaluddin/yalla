import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/providers/package_provider.dart';
import 'package:yalla/core/widgets/button/primary_gradient_button.dart';
import 'package:yalla/core/widgets/eror/error_state_widget.dart';
import 'package:yalla/core/widgets/paket/facility_item.dart';

class DetailPaketScreen extends StatefulWidget {
  final String packageId;

  const DetailPaketScreen({super.key, required this.packageId});

  @override
  State<DetailPaketScreen> createState() => _DetailPaketScreenState();
}

class _DetailPaketScreenState extends State<DetailPaketScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.packageId.isNotEmpty) {
        context.read<PackageProvider>().getPackageById(widget.packageId);
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

  IconData _getFacilityIcon(String slug) {
    switch (slug.toLowerCase()) {
      case 'visa':
        return Icons.article_outlined;
      case 'asuransi':
        return Icons.health_and_safety_outlined;
      case 'mutawwif':
        return Icons.headset_mic_outlined;
      case 'transportasi':
        return Icons.directions_bus_outlined;
      case 'konsumsi':
        return Icons.restaurant;
      case 'air-zamzam':
      case 'air_zamzam':
        return Icons.water_drop_outlined;
      case 'hotel':
        return Icons.business;
      case 'penerbangan':
      case 'tiket':
        return Icons.flight_takeoff;
      default:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PackageProvider>();
    final isLoading = provider.isDetailFetching;
    final packageData = provider.selectedPackage;

    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF005C99)),
        ),
      );
    }

    if (provider.errorMessage.isNotEmpty && packageData == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF005C99)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ErrorStateWidget(
          errorMessage: provider.errorMessage,
          onRetry: () => provider.getPackageById(widget.packageId),
        ),
      );
    }

    final String packageName = packageData?.packageName ?? "Nama Paket";
    final String batchName = packageData?.batchName ?? "Gelombang";
    final int price = packageData?.price ?? 0;
    final int duration = packageData?.durationDays ?? 0;

    final List<dynamic> facilities = packageData?.facilities ?? [];

    final int originalPrice = (price * 1.1).toInt();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
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
          "Detail Paket",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 280.0,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/kaabah.jpeg', fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                      stops: const [0.4, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0099FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Terbatas",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                          children: [
                            TextSpan(
                              text: "$packageName\n- ",
                              style: const TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: batchName,
                              style: const TextStyle(color: Color(0xFFFF9800)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "$duration Hari Keberangkatan",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
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
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Harga Mulai dari",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "IDR ${_formatPrice(originalPrice)}",
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.redAccent,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(height: 2),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "IDR ${_formatPrice(price)}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: " /pax",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 6,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F8FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  right: -15,
                                  bottom: -15,
                                  child: Icon(
                                    Icons.info_outline,
                                    size: 60,
                                    color: const Color(
                                      0xFF0099FF,
                                    ).withOpacity(0.1),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Opsi Cicilan Ringan",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                "Mulai IDR ${_formatPrice((price / 12).toInt())}",
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: "/bulan",
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      "Fasilitas Termasuk",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (facilities.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Belum ada fasilitas khusus untuk paket ini.",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      )
                    else
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2.8,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                            ),
                        itemCount: facilities.length,
                        itemBuilder: (context, index) {
                          final facilityData = facilities[index];
                          final String name = facilityData.name;
                          final String slug = facilityData.slug;

                          return FacilityItem(
                            icon: _getFacilityIcon(slug),
                            title: name,
                          );
                        },
                      ),
                    const SizedBox(height: 32),
                    const Text(
                      "Rencana Perjalanan Utama",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTimelineItem(
                            title: "Kedatangan & Persiapan",
                            desc:
                                "Keberangkatan menuju bandara, check-in, dan persiapan ibadah umrah.",
                            isLast: false,
                          ),
                          _buildTimelineItem(
                            title: "Fokus Ibadah & Ziarah",
                            desc:
                                "Rangkaian ibadah inti di Makkah dan ziarah di kota Madinah.",
                            isLast: false,
                          ),
                          _buildTimelineItem(
                            title: "Kepulangan",
                            desc:
                                "Meninggalkan tanah suci dan kembali menuju ke Tanah Air.",
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: PrimaryGradientButton(
            text: "Lanjutkan Pemesanan",
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String desc,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Color(0xFF0099FF),
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey.shade300,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
