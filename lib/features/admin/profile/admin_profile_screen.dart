import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/widgets/button/admin_custom_bottom_nav_bar.dart';
import 'package:yalla/core/widgets/card/profile_card.dart';
import 'package:yalla/features/auth/providers/auth_provider.dart';
import 'package:yalla/features/admin/profile/admin_order_management_screen.dart';
import 'package:yalla/features/admin/profile/admin_user_managemet_screen.dart';
import 'package:yalla/features/admin/profile/admin_visa_config_screen.dart';
import 'package:yalla/features/user/profile/help_center_screen.dart';
import 'package:yalla/features/user/profile/settings_screen.dart';
import 'package:yalla/splash_screen.dart';

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

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Yakin ingin keluar?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context, false),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.black54,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      // Icon Logout sebagai pengganti logo G
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFFFEE2E2),
                        child: Icon(
                          Icons.logout_rounded,
                          color: Color(0xFFEF4444),
                          size: 18,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Sesi Anda akan diakhiri",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  "Dengan keluar dari akun, sesi login Anda akan terhapus dari perangkat ini. Anda harus memasukkan ulang email dan kata sandi untuk masuk kembali.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFFF3F4F6,
                          ), // Abu-abu muda
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Batal",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFFEF4444,
                          ), // Merah Destruktif
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Keluar",
                          style: TextStyle(
                            color: Colors.white,
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
        );
      },
    );

    if (confirm == true) {
      if (!context.mounted) return;

      await context.read<AuthProvider>().logout();

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

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

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
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
                            "Manajemen Sistem",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ),
                        _buildMenuListItem(
                          icon: Icons.person,
                          iconColor: const Color(0xFF0066FF), // Biru
                          iconBgColor: const Color(0xFFE5F0FF),
                          title: "Manajemen Pengguna",
                          onTap: () {
                            _navigateTo(
                              context,
                              const AdminUserManagementScreen(),
                            );
                          },
                        ),
                        const Divider(
                          height: 1,
                          color: Color(0xFFF3F4F6),
                          indent: 76,
                          endIndent: 24,
                        ),
                        _buildMenuListItem(
                          icon: Icons.receipt_long_rounded,
                          iconColor: const Color(0xFF10B981),
                          iconBgColor: const Color(0xFFD1FAE5),
                          title: "Manajemen Pesanan",
                          onTap: () {
                            _navigateTo(
                              context,
                              const AdminOrderManagementScreen(),
                            );
                          },
                        ),
                        const Divider(
                          height: 1,
                          color: Color(0xFFF3F4F6),
                          indent: 76,
                          endIndent: 24,
                        ),
                        _buildMenuListItem(
                          icon: Icons.credit_card,
                          iconColor: const Color(0xFFF59E0B),
                          iconBgColor: const Color(0xFFFEF3C7),
                          title: "Konfigurasi Visa",
                          onTap: () {
                            _navigateTo(context, const AdminVisaConfigScreen());
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
                          onTap: () => _handleLogout(context),
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
      bottomNavigationBar: const CustomAdminBottomNavBar(currentIndex: 4),
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
