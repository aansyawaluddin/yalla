import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/providers/flight_provider.dart';
import 'package:yalla/core/providers/travel_provider.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';
import 'package:yalla/core/widgets/button/primary_gradient_button.dart';
import 'package:yalla/core/widgets/button/travel_custom_bottom_nav_bar.dart';
import 'package:yalla/core/widgets/card/travel_card.dart';
import 'package:yalla/core/widgets/modals/calendar_bottom_sheet.dart';
import 'package:yalla/core/widgets/modals/passenger_class_bottom_sheet.dart';
import 'package:yalla/core/widgets/eror/error_state_widget.dart';
import 'package:yalla/features/travel/home/list_flight_travel_screen.dart';
import 'package:yalla/features/user/home/travel/travel_list_screen.dart';

class HomePlaneTravelScreen extends StatefulWidget {
  const HomePlaneTravelScreen({super.key});

  @override
  State<HomePlaneTravelScreen> createState() => _HomePlaneTravelScreenState();
}

class _HomePlaneTravelScreenState extends State<HomePlaneTravelScreen> {
  bool isOneWay = true;
  DateTime _selectedDate = DateTime.now();
  bool _isOutboundRoute = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TravelProvider>().fetchTravels();
      context.read<FlightProvider>().fetchFlights();
    });
  }

  String _formatDate(DateTime date) {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
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
    String dayName = days[date.weekday - 1];
    String day = date.day.toString().padLeft(2, '0');
    String monthName = months[date.month - 1];
    return "$dayName, $day $monthName ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final flightProvider = context.watch<FlightProvider>();
    final flightList = flightProvider.flights;
    final travelProvider = context.watch<TravelProvider>();
    final isLoadingTravels = travelProvider.isLoading;
    final travels = travelProvider.travels;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: Stack(
        children: [
          Positioned(
            top: -90.0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55 + 70,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_home.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.8),
                      Colors.white,
                    ],
                    stops: const [0.3, 0.6, 0.85, 1.0],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                image: const DecorationImage(
                                  image: AssetImage(
                                    'assets/images/profile.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Selamat Datang,",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF005C99),
                                  ),
                                ),
                                Text(
                                  "Syahdam 👋",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF005C99),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0099FF),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.notifications_none_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 65),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFFD4EEFF),
                          Colors.white.withOpacity(0.0),
                        ],
                        stops: const [0.0, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF005C99).withOpacity(0.06),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildTripTypeToggle(),
                        const SizedBox(height: 20),

                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Column(
                              children: [
                                _buildLocationInput(
                                  label: "Dari",
                                  code: _isOutboundRoute ? "UPG" : "JED",
                                  city: _isOutboundRoute
                                      ? "Makassar"
                                      : "Jeddah",
                                  icon: Icons.flight_takeoff,
                                ),
                                const SizedBox(height: 12),
                                _buildLocationInput(
                                  label: "Ke",
                                  code: _isOutboundRoute ? "JED" : "UPG",
                                  city: _isOutboundRoute
                                      ? "Jeddah"
                                      : "Makassar",
                                  icon: Icons.flight_land,
                                ),
                              ],
                            ),
                            Positioned(
                              right: 24,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFF005C99),
                                      Color(0xFF0099FF),
                                    ],
                                    stops: [0.0, 1.0],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isOutboundRoute = !_isOutboundRoute;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.swap_vert,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  // ✅ Ganti type ke Map<String, dynamic>
                                  final result =
                                      await showModalBottomSheet<
                                        Map<String, dynamic>
                                      >(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) {
                                          return CalendarBottomSheet(
                                            flights: flightList,
                                            isOutbound: _isOutboundRoute,
                                          );
                                        },
                                      );

                                  // ✅ Ambil date dan isOutbound dari result
                                  if (result != null) {
                                    setState(() {
                                      _selectedDate =
                                          result['date'] as DateTime;
                                      _isOutboundRoute =
                                          result['isOutbound'] as bool;
                                    });
                                  }
                                },
                                child: _buildSmallInputCard(
                                  label: "Tanggal Keberangkatan",
                                  value: _formatDate(_selectedDate),
                                  icon: Icons.calendar_today_outlined,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return const PassengerClassBottomSheet();
                                    },
                                  );
                                },
                                child: _buildSmallInputCard(
                                  label: "Penumpang, Kelas",
                                  value: "4 Dewasa, Ekonomi",
                                  icon: Icons.person_outline,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                        PrimaryGradientButton(
                          text: "Cari Penerbangan",
                          icon: Icons.search,
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(
                                  milliseconds: 300,
                                ),
                                reverseTransitionDuration: const Duration(
                                  milliseconds: 300,
                                ),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        ListFlightTravelScreen(
                                          selectedDate: _selectedDate,
                                          isOutbound: _isOutboundRoute,
                                        ),
                                transitionsBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      var curvedAnimation = CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOut,
                                      );
                                      return FadeTransition(
                                        opacity: curvedAnimation,
                                        child: child,
                                      );
                                    },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  _buildSectionHeader(
                    title: "Travel Populer",
                    subtitle: "Penyelenggara umroh terpercaya",
                    onActionTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          reverseTransitionDuration: const Duration(
                            milliseconds: 300,
                          ),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const TravelListScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                var curvedAnimation = CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOut,
                                );
                                return FadeTransition(
                                  opacity: curvedAnimation,
                                  child: child,
                                );
                              },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  if (isLoadingTravels)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: CircularProgressIndicator(
                          color: Color(0xFF005C99),
                        ),
                      ),
                    )
                  else if (travelProvider.errorMessage.isNotEmpty &&
                      travels.isEmpty)
                    ErrorStateWidget(
                      errorMessage: travelProvider.errorMessage,
                      onRetry: () =>
                          context.read<TravelProvider>().fetchTravels(),
                    )
                  else if (travels.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Text(
                        "Belum ada data travel yang tersedia.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      clipBehavior: Clip.none,
                      child: Row(
                        children: travels.map((travel) {
                          final travelName = travel.fullName.isNotEmpty
                              ? travel.fullName
                              : "Agen Travel";
                          final score = (travel.averageScore).toDouble();
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: TravelCard(
                              travelId: travel.userID,
                              title: travelName,
                              rating: score > 0 ? score : 0.0,
                              reviews: "${travel.totalRatings}",
                              badgeText: "Terverifikasi",
                              badgeColor: const Color(0xFF0099FF),
                              badgeIcon: Icons.verified,
                              imagePath: 'assets/images/kaabah.jpeg',
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const TravelCustomBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildTripTypeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isOneWay = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: isOneWay
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFD4EEFF), Colors.white],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isOneWay
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    "Sekali Jalan",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isOneWay ? FontWeight.bold : FontWeight.w500,
                      color: isOneWay ? Colors.black87 : Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isOneWay = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: !isOneWay
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFD4EEFF), Colors.white],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: !isOneWay
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    "Pulang - Pergi",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: !isOneWay ? FontWeight.bold : FontWeight.w500,
                      color: !isOneWay ? Colors.black87 : Colors.black54,
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

  Widget _buildLocationInput({
    required String label,
    required String code,
    required String city,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF005C99), size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      code,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      city,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
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

  Widget _buildSmallInputCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 8, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(icon, color: const Color(0xFF005C99), size: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    String? subtitle,
    bool showAction = true,
    VoidCallback? onActionTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bold18.copyWith(color: AppColors.textDark),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTypography.regular12.copyWith(
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ],
          ),
          if (showAction)
            GestureDetector(
              onTap: onActionTap,
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  "Lihat Semua",
                  style: AppTypography.regular12.copyWith(
                    color: AppColors.lightBlue,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
