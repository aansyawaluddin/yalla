import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/providers/auth_provider.dart';
import 'package:yalla/core/providers/package_provider.dart';
import 'package:yalla/core/widgets/eror/error_state_widget.dart';
import 'package:yalla/features/travel/profile/batch_detail_screen.dart';
import 'package:yalla/features/travel/profile/detail_paket_travel_screen.dart';
import 'package:yalla/features/travel/profile/tambah_paket_screen.dart';

class MyUmrahPackageScreen extends StatefulWidget {
  const MyUmrahPackageScreen({super.key});

  @override
  State<MyUmrahPackageScreen> createState() => _MyUmrahPackageScreenState();
}

class _MyUmrahPackageScreenState extends State<MyUmrahPackageScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = context.read<AuthProvider>().userData?.userID;
      if (userId != null && userId.isNotEmpty) {
        await context.read<PackageProvider>().getPackages(userId);

        if (!mounted) return;
        final packages = context.read<PackageProvider>().packages;
        final ids = packages
            .where((p) => p.id != null)
            .map((p) => p.id!)
            .toList();
        if (ids.isNotEmpty) {
          context.read<PackageProvider>().fetchAllJamaahCounts(ids);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 72,
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
          "Paket Umrah Saya",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final authProvider = context.read<AuthProvider>();
          final packageProvider = context.read<PackageProvider>();
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahPaketScreen()),
          );
          if (!mounted) return;
          final userId = authProvider.userData?.userID;
          if (userId != null) {
            packageProvider.getPackages(userId);
          }
        },
        backgroundColor: const Color(0xFF0066CC),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),

      body: Consumer<PackageProvider>(
        builder: (context, packageProvider, child) {
          if (packageProvider.isFetching && packageProvider.packages.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF0066CC)),
            );
          }

          if (packageProvider.errorMessage.isNotEmpty &&
              packageProvider.packages.isEmpty) {
            return ErrorStateWidget(
              errorMessage: packageProvider.errorMessage,
              onRetry: () {
                final userId = context.read<AuthProvider>().userData?.userID;
                if (userId != null) packageProvider.getPackages(userId);
              },
            );
          }

          if (packageProvider.packages.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24.0),
            itemCount: packageProvider.packages.length,
            separatorBuilder: (context, index) => const SizedBox(height: 24),
            itemBuilder: (context, index) {
              final data = packageProvider.packages[index];
              final count = packageProvider.jamaahCounts[data.id ?? ''] ?? 0;
              return _buildPackageCard(
                context: context,
                packageId: data.id ?? '',
                batch: data.batchName,
                date: data.batchDate,
                jamaahCount: count,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            "Belum Ada Paket",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Ketuk tombol + untuk membuat paket baru.",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard({
    required BuildContext context,
    required String packageId,
    required String batch,
    required String date,
    required int jamaahCount,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPaketTravelScreen(packageId: packageId),
          ),
        );
      },
      child: Container(
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
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Container(
                height: 120,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/kaabah.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            batch,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            date,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: Row(
                        children: const [
                          Icon(
                            Icons.flight_takeoff,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Flyadeal",
                            style: TextStyle(
                              color: Color(0xFF0099FF),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$jamaahCount Jamaah",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BatchDetailScreen(
                              packageId: packageId,
                              batchName: batch,
                            ),
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
                        "Lihat Jamaah",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
}
