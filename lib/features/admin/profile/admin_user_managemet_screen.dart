import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/models/user_profile_model.dart';
import 'package:yalla/core/providers/admin_user_provider.dart';
import 'package:yalla/core/widgets/card/profile_card.dart';

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  State<AdminUserManagementScreen> createState() =>
      _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminUserProvider>().fetchAllUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onFilterTap(int index) {
    setState(() => _selectedFilterIndex = index);
    final provider = context.read<AdminUserProvider>();
    switch (index) {
      case 0:
        provider.setRoleFilter(null);
        break;
      case 1:
        provider.setRoleFilter('jamaah');
        break;
      case 2:
        provider.setRoleFilter('travel');
        break;
    }
  }

  void _onExportCsv() {
    final csv = context.read<AdminUserProvider>().exportToCsv();
    Clipboard.setData(ClipboardData(text: csv));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data CSV telah disalin ke clipboard.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 70,
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
          "Manajemen Pengguna",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<AdminUserProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const ProfileCard(),
                      const SizedBox(height: 24),
                      _buildSearchBar(provider),
                      const SizedBox(height: 20),
                      _buildFilters(provider),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                Container(
                  width: double.infinity,
                  color: const Color(0xFFFAFAFA),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        provider.isLoading
                            ? "Memuat..."
                            : "${provider.displayedUsers.length} pengguna",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      GestureDetector(
                        onTap: provider.isLoading ? null : _onExportCsv,
                        child: Text(
                          "Export CSV",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: provider.isLoading
                                ? Colors.grey.shade300
                                : const Color(0xFF0084FF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(child: _buildBody(provider)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(AdminUserProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF0084FF)),
      );
    }

    if (provider.errorMessage.isNotEmpty) {
      return _buildErrorState(provider);
    }

    final users = provider.displayedUsers;

    if (users.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: users.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
      itemBuilder: (_, index) => _buildUserItem(users[index]),
    );
  }

  Widget _buildErrorState(AdminUserProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: provider.fetchAllUsers,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text("Coba Lagi"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0084FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            "Tidak ada pengguna ditemukan.",
            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AdminUserProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: provider.setSearchQuery,
        decoration: InputDecoration(
          hintText: "Cari berdasarkan nama atau email...",
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey.shade400,
                    size: 18,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    provider.setSearchQuery('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFilters(AdminUserProvider provider) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _onFilterTap(0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _selectedFilterIndex == 0
                  ? const Color(0xFF004CB9)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _selectedFilterIndex == 0
                    ? const Color(0xFF004CB9)
                    : Colors.grey.shade300,
              ),
            ),
            child: Text(
              "Semua Pengguna",
              style: TextStyle(
                color: _selectedFilterIndex == 0
                    ? Colors.white
                    : Colors.black87,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        GestureDetector(
          onTap: () => _onFilterTap(1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _selectedFilterIndex == 1
                    ? const Color(0xFF4CAF50)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  "Reguler",
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${provider.totalJamaah}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        GestureDetector(
          onTap: () => _onFilterTap(2),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F8FF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _selectedFilterIndex == 2
                    ? const Color(0xFF0084FF)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0084FF),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  "Travel",
                  style: TextStyle(
                    color: Color(0xFF0084FF),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${provider.totalTravel}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserItem(UserProfileModel user) {
    final isJamaah = user.role == 'jamaah';
    final badgeBgColor = isJamaah
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFF0F8FF);
    final badgeTextColor = isJamaah
        ? const Color(0xFF4CAF50)
        : const Color(0xFF0084FF);
    final badgeLabel = isJamaah ? 'Reguler' : 'Travel';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                ),
                clipBehavior: Clip.antiAlias,
                child: user.avatarUrl.isNotEmpty
                    ? Image.network(
                        user.avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _buildAvatarFallback(user),
                      )
                    : _buildAvatarFallback(user),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.firstName} ${user.lastName}'.trim().isEmpty
                      ? user.email
                      : '${user.firstName} ${user.lastName}'.trim(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 12,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        user.email,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
                if (user.nationality.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.flag_outlined,
                        size: 12,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user.nationality,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: badgeBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badgeLabel,
              style: TextStyle(
                color: badgeTextColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarFallback(UserProfileModel user) {
    final initials = [
      user.firstName,
      user.lastName,
    ].where((s) => s.isNotEmpty).map((s) => s[0].toUpperCase()).join();

    return Container(
      color: const Color(0xFFE3F2FD),
      child: Center(
        child: Text(
          initials.isEmpty ? '?' : initials,
          style: const TextStyle(
            color: Color(0xFF0084FF),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
