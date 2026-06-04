import 'package:flutter/material.dart';
import 'package:yalla/core/models/package_passenger_model.dart';

class JamaahDetailScreen extends StatelessWidget {
  final PackagePassengerModel passenger;

  const JamaahDetailScreen({super.key, required this.passenger});

  String _formatDate(String isoDate) {
    if (isoDate.isEmpty) return '-';
    try {
      final date = DateTime.parse(isoDate);
      const months = [
        '',
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];
      return "${date.day} ${months[date.month]} ${date.year}";
    } catch (_) {
      return isoDate;
    }
  }

  String _getCountryName(int countryId) {
    const countries = {
      100: 'Indonesia',
      1: 'Afghanistan',
      2: 'Albania',
      3: 'Algeria',
      4: 'Andorra',
      5: 'Angola',
      6: 'Argentina',
      7: 'Armenia',
      8: 'Australia',
      9: 'Austria',
      10: 'Azerbaijan',
      11: 'Bahrain',
      12: 'Bangladesh',
      13: 'Belarus',
      14: 'Belgium',
      15: 'Bolivia',
      16: 'Bosnia',
      17: 'Brazil',
      18: 'Brunei',
      19: 'Bulgaria',
      20: 'Cambodia',
      21: 'Canada',
      22: 'Chile',
      23: 'China',
      24: 'Colombia',
      25: 'Croatia',
      26: 'Cuba',
      27: 'Cyprus',
      28: 'Czech Republic',
      29: 'Denmark',
      30: 'Egypt',
      31: 'Estonia',
      32: 'Ethiopia',
      33: 'Finland',
      34: 'France',
      35: 'Georgia',
      36: 'Germany',
      37: 'Ghana',
      38: 'Greece',
      39: 'Hungary',
      40: 'India',
      41: 'Iran',
      42: 'Iraq',
      43: 'Ireland',
      44: 'Israel',
      45: 'Italy',
      46: 'Japan',
      47: 'Jordan',
      48: 'Kazakhstan',
      49: 'Kenya',
      50: 'Kuwait',
      51: 'Kyrgyzstan',
      52: 'Laos',
      53: 'Latvia',
      54: 'Lebanon',
      55: 'Libya',
      56: 'Lithuania',
      57: 'Luxembourg',
      58: 'Malaysia',
      59: 'Maldives',
      60: 'Malta',
      61: 'Mexico',
      62: 'Moldova',
      63: 'Mongolia',
      64: 'Morocco',
      65: 'Myanmar',
      66: 'Nepal',
      67: 'Netherlands',
      68: 'New Zealand',
      69: 'Nigeria',
      70: 'North Korea',
      71: 'Norway',
      72: 'Oman',
      73: 'Pakistan',
      74: 'Palestine',
      75: 'Panama',
      76: 'Peru',
      77: 'Philippines',
      78: 'Poland',
      79: 'Portugal',
      80: 'Qatar',
      81: 'Romania',
      82: 'Russia',
      83: 'Saudi Arabia',
      84: 'Serbia',
      85: 'Singapore',
      86: 'Slovakia',
      87: 'Slovenia',
      88: 'Somalia',
      89: 'South Africa',
      90: 'South Korea',
      91: 'Spain',
      92: 'Sri Lanka',
      93: 'Sudan',
      94: 'Sweden',
      95: 'Switzerland',
      96: 'Syria',
      97: 'Taiwan',
      98: 'Tajikistan',
      99: 'Thailand',
      101: 'Iraq',
      102: 'Tunisia',
      103: 'Turkey',
      104: 'Turkmenistan',
      105: 'Uganda',
      106: 'Ukraine',
      107: 'United Arab Emirates',
      108: 'United Kingdom',
      109: 'United States',
      110: 'Uzbekistan',
      111: 'Venezuela',
      112: 'Vietnam',
      113: 'Yemen',
      114: 'Zimbabwe',
    };
    return countries[countryId] ?? 'Tidak Diketahui';
  }

  @override
  Widget build(BuildContext context) {
    final nameParts = passenger.fullName.trim().split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '-';
    final lastName = nameParts.length > 1 ? nameParts.last : '-';
    final middleName = nameParts.length > 2
        ? nameParts.sublist(1, nameParts.length - 1).join(' ')
        : '-';

    final shortId = passenger.id.length >= 4
        ? '#J-${passenger.id.substring(0, 4).toUpperCase()}'
        : '#J-${passenger.id.toUpperCase()}';

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
          "Detail Jamaah",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE8F0FF),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Center(
                    child: Text(
                      passenger.fullName.isNotEmpty
                          ? passenger.fullName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004CB9),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        passenger.fullName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        shortId,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (passenger.email.isNotEmpty)
                        Text(
                          passenger.email,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // --- DATA DIRI ---
            _buildSectionTitle("Data Diri"),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildInfoItem("Nama Awal", firstName)),
                Expanded(child: _buildInfoItem("Nama Tengah", middleName)),
                Expanded(child: _buildInfoItem("Nama Akhir", lastName)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildInfoItem(
                    "Tanggal Lahir",
                    _formatDate(passenger.dateOfBirth),
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    "No. Telepon",
                    passenger.phoneNumber.isNotEmpty
                        ? passenger.phoneNumber
                        : '-',
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    "Asal Negara",
                    _getCountryName(passenger.passportCountryId),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // --- INFORMASI PASPOR ---
            _buildSectionTitle("Informasi Paspor"),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildInfoItem(
                    "Nomor Paspor",
                    passenger.passportNumber.isNotEmpty
                        ? passenger.passportNumber
                        : '-',
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    "Tanggal Terbit",
                    _formatDate(passenger.passportIssueDate),
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    "Tanggal Berakhir",
                    _formatDate(passenger.passportExpiryDate),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // --- STATUS DOKUMEN ---
            _buildSectionTitle("Status Dokumen"),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildDocumentBadge("Paspor"),
                _buildDocumentBadge("Visa"),
                _buildDocumentBadge("Tiket"),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF005C99),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8FAED),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, color: Color(0xFF10B981), size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }
}
