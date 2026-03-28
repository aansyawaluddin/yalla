import 'package:flutter/material.dart';
import 'package:yalla/core/widgets/button/custom_bottom_nav_bar.dart';
import 'package:yalla/core/widgets/card/profile_card.dart';
import 'package:yalla/features/user/profile/help_center_screen.dart';
import 'package:yalla/features/user/profile/payment_method_screen.dart';
import 'package:yalla/features/user/profile/saved_document_screen.dart';
import 'package:yalla/features/user/profile/settings_screen.dart';

void _navigateTo(BuildContext context, Widget targetPage) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => targetPage,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );

        return FadeTransition(opacity: curvedAnimation, child: child);
      },
    ),
  );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -35.0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_home.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    "Profil",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003875),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ProfileCard(),
                ),

                const SizedBox(height: 32),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 8.0,
                          ),
                          child: Text(
                            "Pengaturan Akun",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD1D5DB),
                            ),
                          ),
                        ),
                        _buildMenuListItem(
                          icon: Icons.payments_outlined,
                          iconColor: const Color(0xFF10B981),
                          iconBgColor: const Color(0xFFD1FAE5),
                          title: "Metode Pembayaran",
                          onTap: () {
                            _navigateTo(context, const PaymentMethodScreen());
                          },
                        ),
                        const Divider(
                          height: 1,
                          color: Color(0xFFF3F4F6),
                          indent: 24,
                          endIndent: 24,
                        ),
                        _buildMenuListItem(
                          icon: Icons.description_outlined,
                          iconColor: const Color(0xFF3B82F6),
                          iconBgColor: const Color(0xFFDBEAFE),
                          title: "Dokumen Tersimpan",
                          onTap: () {
                            _navigateTo(context, const SavedDocumentScreen());
                          },
                        ),

                        const SizedBox(height: 24),

                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 8.0,
                          ),
                          child: Text(
                            "Dukungan dan Lainnya",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD1D5DB),
                            ),
                          ),
                        ),
                        _buildMenuListItem(
                          icon: Icons.headset_mic_outlined,
                          iconColor: const Color(0xFF6B7280),
                          iconBgColor: const Color(0xFFF3F4F6),
                          title: "Pusat Bantuan",
                          onTap: () {
                            _navigateTo(context, const HelpCenterScreen());
                          },
                        ),
                        const Divider(
                          height: 1,
                          color: Color(0xFFF3F4F6),
                          indent: 24,
                          endIndent: 24,
                        ),
                        _buildMenuListItem(
                          icon: Icons.settings_outlined,
                          iconColor: const Color(0xFF6B7280),
                          iconBgColor: const Color(0xFFF3F4F6),
                          title: "Pengaturan",
                          onTap: () {
                            _navigateTo(context, const SettingsScreen());
                          },
                        ),
                        const Divider(
                          height: 1,
                          color: Color(0xFFF3F4F6),
                          indent: 24,
                          endIndent: 24,
                        ),
                        _buildMenuListItem(
                          icon: Icons.logout,
                          iconColor: const Color(0xFFEF4444),
                          iconBgColor: const Color(0xFFFEE2E2),
                          title: "Keluar",
                          titleColor: const Color(0xFFEF4444),
                          showTrailing: false,
                          onTap: () {
                            // Aksi logout
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildMenuListItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    Color titleColor = const Color(0xFF111827),
    bool showTrailing = true,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: titleColor,
                ),
              ),
            ),

            if (showTrailing)
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF111827),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
