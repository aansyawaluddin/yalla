import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final double screenHeight;

  const LoginScreen({super.key, required this.screenHeight});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  final Color _primaryBlue = const Color(0xFF004CB9);
  final Color _darkBlue = const Color(0xFF003075);
  final Color _brightBlue = const Color(0xFF0082FA);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.screenHeight - 200,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            // 1. Hapus padding kiri & kanan dari ScrollView ini
            padding: const EdgeInsets.only(top: 41, bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header: Belum punya akun? ──
                // Bungkus dengan Padding horizontal 30
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Belum punya akun?",
                        style: TextStyle(color: _primaryBlue, fontSize: 13),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 12,
                              spreadRadius: -2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              _primaryBlue.withOpacity(0.3),
                              _primaryBlue,
                            ],
                            stops: const [0.1, 0.5, 1.0],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1.5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 28,
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    "Daftar",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: _primaryBlue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 47),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selamat Datang",
                        style: TextStyle(
                          fontSize: 22,
                          color: _primaryBlue,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Siap Untuk Perjalanan\nBerikutnya?",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: _darkBlue,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Masukkan email dan kata sandi Anda untuk\nmulai perjalanan",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Padding(
                  padding: const EdgeInsets.only(
                    right: 30,
                  ), // Hanya padding dikanan, kiri 0
                  child: _buildTextField(
                    icon: Icons.alternate_email,
                    hint: "Masukkan Email Anda",
                  ),
                ),

                const SizedBox(height: 16),

                // ── Input Password & Tombol Mata (Menempel Kiri) ──
                Padding(
                  padding: const EdgeInsets.only(
                    right: 30,
                  ), // Hanya padding dikanan, kiri 0
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          icon: Icons.key_outlined,
                          hint: "Masukkan kata sandi Anda",
                          isPassword: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 54,
                        width: 65,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: _primaryBlue,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Button Masuk + Lupa Password ──
                // ── Button Masuk + Lupa Password (Menempel ke Ujung Layar) ──
                // HAPUS Padding pembungkus di sini agar tombol bisa menempel ke layar
                Row(
                  children: [
                    // Tombol Masuk (Menempel Kiri penuh)
                    Expanded(
                      flex: 5,
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _brightBlue.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _brightBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(50),
                                bottomRight: Radius.circular(50),
                              ),
                            ),
                          ),
                          child: const Text(
                            "Masuk",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 24), // Jarak di antara kedua tombol
                    // Tombol Lupa Password (Menempel Kanan penuh)
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                bottomLeft: Radius.circular(50),
                              ),
                            ),
                          ),
                          child: Text(
                            "Lupa Password?",
                            style: TextStyle(
                              fontSize: 13,
                              color: _primaryBlue,
                              decoration: TextDecoration.underline,
                              decorationColor: _primaryBlue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 36),

                // ── Divider: Atau masuk menggunakan ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Atau masuk menggunakan",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Tombol Social Media ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      _buildSocialButton(
                        label: "Google",
                        iconWidget: _GoogleIcon(),
                      ),
                      const SizedBox(width: 16),
                      _buildSocialButton(
                        label: "Facebook",
                        iconWidget: _FacebookIcon(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hint,
    bool isPassword = false,
  }) {
    return SizedBox(
      height: 54,
      child: TextField(
        obscureText: isPassword ? _obscurePassword : false,
        keyboardType: isPassword
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          // 2. Beri jarak pada ikon agar lurus (sejajar) dengan teks judul di atasnya
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 30, right: 12),
            child: Icon(icon, color: Colors.grey.shade400, size: 20),
          ),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade300, fontSize: 13),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 20,
          ),
          // 3. Ubah bentuk border: Rata di sebelah kiri, membulat di sebelah kanan
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            borderSide: BorderSide(color: _primaryBlue, width: 1.2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            borderSide: BorderSide(color: _primaryBlue, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            borderSide: BorderSide(color: _primaryBlue, width: 1.8),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String label,
    required Widget iconWidget,
  }) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: Colors.grey.shade300, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Google Icon ───
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GoogleIconPainter()),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = size.width / 2;

    final bgPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx, cy), r, bgPaint);

    final arcRect = Rect.fromCircle(center: Offset(cx, cy), radius: r);

    // Blue (right arc)
    canvas.drawPath(
      Path()
        ..moveTo(cx, cy)
        ..arcTo(arcRect, -0.35, 1.6, false)
        ..close(),
      Paint()
        ..color = const Color(0xFF4285F4)
        ..style = PaintingStyle.fill,
    );

    // Red (top-left arc)
    canvas.drawPath(
      Path()
        ..moveTo(cx, cy)
        ..arcTo(arcRect, 1.25, 1.7, false)
        ..close(),
      Paint()
        ..color = const Color(0xFFEA4335)
        ..style = PaintingStyle.fill,
    );

    // Yellow (bottom-left arc)
    canvas.drawPath(
      Path()
        ..moveTo(cx, cy)
        ..arcTo(arcRect, 2.95, 0.75, false)
        ..close(),
      Paint()
        ..color = const Color(0xFFFBBC05)
        ..style = PaintingStyle.fill,
    );

    // Green (bottom-right arc)
    canvas.drawPath(
      Path()
        ..moveTo(cx, cy)
        ..arcTo(arcRect, 3.70, 0.86, false)
        ..close(),
      Paint()
        ..color = const Color(0xFF34A853)
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(Offset(cx, cy), r * 0.58, Paint()..color = Colors.white);

    canvas.drawRect(
      Rect.fromLTWH(cx - 0.05, cy - r * 0.15, r * 0.98, r * 0.30),
      Paint()..color = const Color(0xFF4285F4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Facebook Icon ───
class _FacebookIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: Color(0xFF1877F2),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          "f",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            height: 1.1,
          ),
        ),
      ),
    );
  }
}
