import 'package:flutter/material.dart';
import 'package:yalla/features/user/plane/flight/ticket_detail_page.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _blobController;
  late Animation<double> _blobScale;

  late AnimationController _imageScaleController;
  late Animation<double> _imageScale;

  late AnimationController _textController;
  late Animation<double> _textOpacity;

  late AnimationController _transitionController;
  late Animation<double> _heroFade;
  late Animation<double> _ticketSlide;

  late AnimationController _barcodeController;
  late Animation<double> _barcodeOpacity;
  late Animation<double> _barcodeSlide;

  late AnimationController _pulseController;
  late Animation<double> _pulseScale;

  bool _showTicket = false;

  @override
  void initState() {
    super.initState();

    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _blobScale = CurvedAnimation(
      parent: _blobController,
      curve: Curves.easeOutBack,
    );

    _imageScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // Durasi sesi 1 ke sesi 2
    );

    // SESUAI DESAIN: Sesi 1 pesawat sangat kecil (0.2), lalu membesar ke ukuran penuh (1.0)
    _imageScale = TweenSequence<double>([
      TweenSequenceItem(
        tween:
            Tween<double>(
                  begin: 0.0,
                  end: 0.25,
                ) // Muncul awal (Sangat kecil seperti gambar 1)
                .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(0.25), // Hold posisi kecil (Sesi 1)
        weight: 40,
      ),
      TweenSequenceItem(
        tween:
            Tween<double>(
                  begin: 0.25,
                  end: 1.0,
                ) // Membesar ke Sesi 2 (Gambar 2)
                .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(_imageScaleController);

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textOpacity = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseScale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _heroFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _ticketSlide = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _barcodeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _barcodeOpacity = CurvedAnimation(
      parent: _barcodeController,
      curve: Curves.easeIn,
    );
    _barcodeSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _barcodeController, curve: Curves.easeOutCubic),
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));

    _blobController.forward();
    _imageScaleController.forward();

    // Tunggu sampai animasi Sesi 1 (kecil) selesai dan mulai membesar ke Sesi 2
    await Future.delayed(const Duration(milliseconds: 2100));

    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 1600));

    _pulseController.stop();
    setState(() => _showTicket = true);
    _transitionController.forward();
    await Future.delayed(const Duration(milliseconds: 500));

    _barcodeController.forward();
  }

  @override
  void dispose() {
    _blobController.dispose();
    _imageScaleController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    _transitionController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Glow (Warna disesuaikan agar lebih lembut seperti desain)
          AnimatedBuilder(
            animation: _blobScale,
            builder: (context, _) {
              final s = _blobScale.value;
              return Stack(
                children: [
                  Positioned(
                    top: -120 * (1 - s) - 60,
                    right: -120 * (1 - s) - 60,
                    child: Transform.scale(
                      scale: s,
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4CAF50).withOpacity(0.3),
                              blurRadius: 120,
                              spreadRadius: 80,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -120 * (1 - s) - 60,
                    left: -120 * (1 - s) - 60,
                    child: Transform.scale(
                      scale: s,
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4CAF50).withOpacity(0.3),
                              blurRadius: 120,
                              spreadRadius: 80,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Main Hero Area
          AnimatedBuilder(
            animation: Listenable.merge([_heroFade, _transitionController]),
            builder: (context, _) {
              return Opacity(
                opacity: _heroFade.value,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Pesawat (Sesi 1: Kecil -> Sesi 2: Besar)
                      AnimatedBuilder(
                        animation: Listenable.merge([_imageScale, _pulseScale]),
                        builder: (context, _) {
                          // Skala dasar dikali dengan pulse lembut
                          final currentScale =
                              _imageScale.value * _pulseScale.value;
                          return Transform.scale(
                            scale: currentScale,
                            child: Image.asset(
                              'assets/images/succes.png',
                              width: MediaQuery.of(context).size.width * 0.7,
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                      ),

                      // Teks Muncul di Sesi 2
                      SizeTransition(
                        sizeFactor: _textController,
                        axisAlignment: -1.0,
                        child: FadeTransition(
                          opacity: _textOpacity,
                          child: Column(
                            children: [
                              const SizedBox(height: 24),
                              const Text(
                                'Pembayaran Berhasil!',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1A1A1A),
                                  letterSpacing: -0.8,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                ),
                                child: Text(
                                  'Transaksi sukses. Terima kasih atas\npembayaran Anda.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade500,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          if (_showTicket)
            AnimatedBuilder(
              animation: _transitionController,
              builder: (context, _) {
                final slide = _ticketSlide.value;
                final screenH = MediaQuery.of(context).size.height;
                return Transform.translate(
                  offset: Offset(0, slide * screenH * 0.6),
                  child: TicketDetailPage(
                    barcodeOpacity: _barcodeOpacity,
                    barcodeSlide: _barcodeSlide,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
