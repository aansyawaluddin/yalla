import 'package:flutter/material.dart';
import 'package:yalla/core/widgets/card/profile_card.dart';

class SettingsScreenTravel extends StatefulWidget {
  const SettingsScreenTravel({super.key});

  @override
  State<SettingsScreenTravel> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreenTravel> {
  bool _isNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 8, bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF0084FF),
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          "Pengaturan",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileCard(),

            const SizedBox(height: 32),

            const Text(
              "Notifikasi",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              icon: Icons.notifications_none_outlined,
              title: "Notifikasi",
              trailing: Switch(
                value: _isNotificationEnabled,
                onChanged: (value) {
                  setState(() {
                    _isNotificationEnabled = value;
                  });
                },
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF005C99),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade300,
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              "Keamanan",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              icon: Icons.share_outlined,
              title: "Akun yang terhubung",
              trailing: Image.asset(
                'assets/icons/google.png',
                width: 20,
                height: 20,
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              icon: Icons.history,
              title: "Aktivitas Login Terakhir",
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8FAED),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  "Aktif",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF10B981),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFF4F9FF),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF0066CC), size: 20),
        ),
        const SizedBox(width: 16),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        trailing,
      ],
    );
  }
}
