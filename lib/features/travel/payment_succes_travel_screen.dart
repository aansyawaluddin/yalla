import 'package:flutter/material.dart';
import 'package:yalla/features/travel/ticket_detail_travel_page.dart';

class PaymentSuccesTravelScreen extends StatefulWidget {
  const PaymentSuccesTravelScreen({super.key});

  @override
  State<PaymentSuccesTravelScreen> createState() =>
      _PaymentSuccesTravelScreenState();
}

class _PaymentSuccesTravelScreenState extends State<PaymentSuccesTravelScreen>
    with TickerProviderStateMixin {
  // Controller utama untuk mengatur fase 1 dan 2 (Pesawat & Background)
  late AnimationController _phaseController;

  // Animasi Background Glow
  late Animation<double> _bgGlowScale;

  // Animasi Pesawat
  late Animation<double> _imageScale;

  late AnimationController _textController;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

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

    // Durasi total dari kemunculan awal hingga membesar adalah 2000ms
    _phaseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // 1. Animasi Background (Sesi 1 kecil -> Sesi 2 besar)
    _bgGlowScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.2, // Mulai dari sangat kecil
          end: 0.5, // Membesar sedikit di Sesi 1 (hanya terlihat di sudut)
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(0.5), // Tahan ukuran
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.5,
          end: 1.5, // Menyebar luas di Sesi 2
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 30,
      ),
    ]).animate(_phaseController);

    // 2. Animasi Pesawat (Sesi 1 kecil -> Sesi 2 besar)
    _imageScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 0.25,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30, // Fase awal pesawat kecil
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(0.25),
        weight: 40, // Diam sejenak
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.25,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30, // Fase pesawat membesar ke arah user
      ),
    ]).animate(_phaseController);

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textOpacity = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
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

    // Jalankan animasi pesawat dan background glow bersamaan
    _phaseController.forward();

    // Tunggu persis 1400ms (Durasi dari pesawat & glow muncul kecil + diam)
    await Future.delayed(const Duration(milliseconds: 1400));

    // Langsung jalankan animasi teks BERSAMAAN dengan pesawat dan glow masuk ke Sesi 2 (membesar)
    _textController.forward();

    // Beri waktu membaca sebelum pindah ke tiket
    await Future.delayed(const Duration(milliseconds: 2200));

    _pulseController.stop();
    setState(() => _showTicket = true);
    _transitionController.forward();
    await Future.delayed(const Duration(milliseconds: 500));

    _barcodeController.forward();
  }

  @override
  void dispose() {
    _phaseController.dispose();
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
          AnimatedBuilder(
            animation: _bgGlowScale,
            builder: (context, child) {
              final glowSize = MediaQuery.of(context).size.width * 0.6;
              return Stack(
                children: [
                  // Glow Kanan Atas
                  Positioned(
                    top: -glowSize * 0.45,
                    right: -glowSize * 0.45,
                    child: Transform.scale(
                      scale: _bgGlowScale.value,
                      child: Container(
                        width: glowSize,
                        height: glowSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF20AD00),
                              const Color(0xFF20AD00).withOpacity(0.0),
                            ],
                            stops: const [0.0, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Glow Kiri Bawah
                  Positioned(
                    bottom: -glowSize * 0.45,
                    left: -glowSize * 0.45,
                    child: Transform.scale(
                      scale: _bgGlowScale.value,
                      child: Container(
                        width: glowSize,
                        height: glowSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF20AD00),
                              const Color(0xFF20AD00).withOpacity(0.0),
                            ],
                            stops: const [0.0, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Area Tengah (Pesawat dan Teks)
          AnimatedBuilder(
            animation: Listenable.merge([_heroFade, _transitionController]),
            builder: (context, _) {
              return Opacity(
                opacity: _heroFade.value,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Animasi Pesawat
                      AnimatedBuilder(
                        animation: Listenable.merge([_imageScale, _pulseScale]),
                        builder: (context, _) {
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

                      // Animasi Teks (Muncul FadeIn & SlideUp)
                      SlideTransition(
                        position: _textSlide,
                        child: FadeTransition(
                          opacity: _textOpacity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 24),
                              const Text(
                                'Pembayaran Berhasil!',
                                textAlign: TextAlign.center,
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

          // Halaman Tiket
          if (_showTicket)
            AnimatedBuilder(
              animation: _transitionController,
              builder: (context, _) {
                final slide = _ticketSlide.value;
                final screenH = MediaQuery.of(context).size.height;
                return Transform.translate(
                  offset: Offset(0, slide * screenH * 0.6),
                  child: TicketDetailTravelPage(
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
