import 'package:flutter/material.dart';
import 'package:yalla/core/widgets/card/profile_card.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

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
          "Pusat Bantuan",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: ProfileCard(),
            ),

            const SizedBox(height: 32),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "FAQ",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),

            _FAQItem(
              icon: Icons.confirmation_number_outlined,
              iconColor: const Color(0xFF0066CC),
              iconBgColor: const Color(0xFFF4F9FF),
              title: "Bagaimana cara memesan tiket?",
              answerWidget: const Text(
                "Untuk memesan tiket, silakan pilih menu Pesawat, tentukan kota keberangkatan dan tujuan, pilih tanggal perjalanan, lalu pilih jadwal yang tersedia. Setelah itu isi data penumpang dan lakukan pembayaran. E-ticket akan otomatis dikirim ke email dan tersedia di menu Pesanan.",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ),

            _FAQItem(
              icon: Icons.confirmation_number_outlined,
              iconColor: const Color(0xFF0066CC),
              iconBgColor: const Color(0xFFF4F9FF),
              title: "Bagaimana cara melihat e-tiket?",
              answerWidget: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: "Masuk ke menu "),
                    TextSpan(
                      text: "Pesanan",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ", pilih tiket "),
                    TextSpan(
                      text: "aktif",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          ", lalu tekan E-ticket yang ingin dilihat. Anda juga dapat mengunduh atau membagikan file tiket dalam format PDF.",
                    ),
                  ],
                ),
              ),
            ),

            _FAQItem(
              icon: Icons.credit_card_outlined,
              iconColor: const Color(0xFFF97316), // Oranye
              iconBgColor: const Color(0xFFFFF7ED), // Oranye muda
              title: "Metode pembayaran apa saja yang tersedia?",
              answerWidget: const Text(
                "Kami menerima pembayaran melalui Transfer Bank, Kartu Kredit/Debit, dan Dompet Digital seperti GoPay, OVO, dan DANA.",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ),

            _FAQItem(
              icon: Icons.credit_card_outlined,
              iconColor: const Color(0xFFF97316),
              iconBgColor: const Color(0xFFFFF7ED),
              title: "Apakah bisa refund?",
              answerWidget: const Text(
                "Proses refund dapat dilakukan sesuai dengan kebijakan maskapai atau pihak hotel. Silakan masuk ke detail pesanan Anda untuk mengajukan refund.",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final Widget answerWidget;
  final bool initiallyExpanded;

  const _FAQItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.answerWidget,
    this.initiallyExpanded = false,
  });

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: _toggleExpanded,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Ikon Lingkaran
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: widget.iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(widget.icon, color: widget.iconColor, size: 16),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),

                if (!_isExpanded)
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.black87,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isExpanded
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: 72.0,
                    right: 24.0,
                    bottom: 16.0,
                  ),
                  child: widget.answerWidget,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
