import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/models/package_model.dart';
import 'package:yalla/core/providers/package_provider.dart';
import 'package:yalla/core/widgets/eror/error_state_widget.dart';
import 'package:yalla/core/widgets/paket/large_paket_umrah.dart';
import 'package:yalla/core/widgets/paket/small_paket_umrah.dart';

class PaketUmrahScreen extends StatefulWidget {
  const PaketUmrahScreen({super.key});

  @override
  State<PaketUmrahScreen> createState() => _PaketUmrahScreenState();
}

class _PaketUmrahScreenState extends State<PaketUmrahScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ["Semua", "VVIP", "Ekonomi", "Eksklusif"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PackageProvider>().getAllPackages();
    });
  }

  String _formatPrice(int price) {
    if (price >= 1000000) {
      double priceInJuta = price / 1000000;
      return "IDR ${priceInJuta.toStringAsFixed(priceInJuta.truncateToDouble() == priceInJuta ? 0 : 1)} Jt";
    }
    return "IDR $price";
  }

  // 👇 Helper untuk memformat teks info pesawat 👇
  String _formatFlightInfo(PackageModel package) {
    String depFlight = package.departureFlight?.flightNo ?? "TBA";
    String retFlight = package.returnFlight?.flightNo ?? "TBA";
    return "✈ $depFlight ⇌ $retFlight";
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
          "Paket Umrah",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomTabBar(),

          Expanded(
            child: Consumer<PackageProvider>(
              builder: (context, provider, child) {
                if (provider.isGlobalFetching) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF005C99)),
                  );
                }

                if (provider.errorMessage.isNotEmpty &&
                    provider.globalPackages.isEmpty) {
                  return ErrorStateWidget(
                    errorMessage: provider.errorMessage,
                    onRetry: () => provider.getAllPackages(),
                  );
                }

                if (provider.globalPackages.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada penawaran paket saat ini.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final packages = provider.globalPackages;
                List<Widget> packageWidgets = [];

                // 👇 Sisipkan _formatFlightInfo ke dalam properti duration 👇
                packageWidgets.add(
                  LargePaketCard(
                    packageId: packages[0].id ?? '',
                    titleNormal: "${packages[0].packageName}\n- ",
                    titleHighlight: packages[0].batchName,
                    duration:
                        "${packages[0].durationDays} Hari | ${_formatFlightInfo(packages[0])}",
                    price: _formatPrice(packages[0].price),
                    imagePath: 'assets/images/kaabah.jpeg',
                    isPopular: true,
                  ),
                );
                packageWidgets.add(const SizedBox(height: 16));

                for (int i = 1; i < packages.length; i += 2) {
                  Widget leftCard = Expanded(
                    child: SmallPaketCard(
                      packageId: packages[i].id ?? '',
                      title: packages[i].packageName,
                      // 👇 Sisipkan info flight di sini juga
                      duration:
                          "${packages[i].durationDays} Hari\n${_formatFlightInfo(packages[i])}",
                      price: _formatPrice(packages[i].price),
                      imagePath: 'assets/images/kaabah.jpeg',
                    ),
                  );

                  Widget rightCard = (i + 1 < packages.length)
                      ? Expanded(
                          child: SmallPaketCard(
                            packageId: packages[i + 1].id ?? '',
                            title: packages[i + 1].packageName,
                            duration:
                                "${packages[i + 1].durationDays} Hari\n${_formatFlightInfo(packages[i + 1])}",
                            price: _formatPrice(packages[i + 1].price),
                            imagePath: 'assets/images/kaabah.jpeg',
                          ),
                        )
                      : const Expanded(child: SizedBox());

                  packageWidgets.add(
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        leftCard,
                        const SizedBox(width: 16),
                        rightCard,
                      ],
                    ),
                  );
                  packageWidgets.add(const SizedBox(height: 16));
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Penawaran Eksklusif",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Pilih paket terbaik untuk perjalanan Anda",
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      const SizedBox(height: 20),

                      ...packageWidgets,

                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            child: Column(
              children: [
                Text(
                  _tabs[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive
                        ? const Color(0xFF007BFF)
                        : const Color(0xFF005C99),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 2,
                  width: isActive ? 40 : 0,
                  color: const Color(0xFF007BFF),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
