import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/models/package_passenger_model.dart';
import 'package:yalla/core/providers/package_provider.dart';
import 'package:yalla/features/travel/profile/jamaah_detail_screen.dart';

class BatchDetailScreen extends StatefulWidget {
  final String packageId;
  final String batchName;

  const BatchDetailScreen({
    super.key,
    required this.packageId,
    required this.batchName,
  });

  @override
  State<BatchDetailScreen> createState() => _BatchDetailScreenState();
}

class _BatchDetailScreenState extends State<BatchDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PackageProvider>().fetchPackagePassengers(widget.packageId);
    });

    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        title: Text(
          widget.batchName.replaceAll("BATCH", "Batch"),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<PackageProvider>(
        builder: (context, provider, _) {
          final isLoading = provider.isFetchingPassengers;
          final error = provider.passengersError;
          final allPassengers = provider.passengers;
          final passengers = _searchQuery.isEmpty
              ? allPassengers
              : allPassengers.where((p) {
                  return p.fullName.toLowerCase().contains(_searchQuery) ||
                      p.email.toLowerCase().contains(_searchQuery) ||
                      p.passportNumber.toLowerCase().contains(_searchQuery);
                }).toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            isDense: true,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.black87,
                              size: 20,
                            ),
                            hintText: "Cari Jamaah",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.tune, color: Colors.black87),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),

              if (!isLoading && error.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Text(
                        "${passengers.length} Jamaah",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 8),

              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF0066CC),
                        ),
                      )
                    : error.isNotEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                error,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => context
                                    .read<PackageProvider>()
                                    .fetchPackagePassengers(widget.packageId),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0066CC),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Coba Lagi",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : passengers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _searchQuery.isEmpty
                                  ? "Belum ada jamaah untuk paket ini."
                                  : "Jamaah tidak ditemukan.",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                        itemCount: passengers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final p = passengers[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      JamaahDetailScreen(passenger: p),
                                ),
                              );
                            },
                            child: _buildJamaahCard(passenger: p),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildJamaahCard({required PackagePassengerModel passenger}) {
    final bool isPassportExpired = () {
      try {
        final expiry = DateTime.parse(passenger.passportExpiryDate);
        return expiry.isBefore(DateTime.now());
      } catch (_) {
        return false;
      }
    }();

    final Color badgeBgColor = isPassportExpired
        ? const Color(0xFFFFE4E4)
        : const Color(0xFFE8FAED);
    final Color badgeTextColor = isPassportExpired
        ? Colors.red
        : const Color(0xFF10B981);
    final String badgeLabel = isPassportExpired ? "Paspor Exp" : "Aktif";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE8F0FF),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Center(
              child: Text(
                passenger.fullName.isNotEmpty
                    ? passenger.fullName[0].toUpperCase()
                    : "?",
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
                  passenger.fullName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Paspor: ${passenger.passportNumber}",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                if (passenger.email.isNotEmpty)
                  Text(
                    passenger.email,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: badgeBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              badgeLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: badgeTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
