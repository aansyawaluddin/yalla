import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:yalla/core/widgets/button/primary_gradient_button.dart';
import 'package:yalla/features/travel/home/payment_succes_travel_screen.dart';

class AnimatedPaymentBottombarTravel extends StatefulWidget {
  const AnimatedPaymentBottombarTravel({super.key});

  @override
  State<AnimatedPaymentBottombarTravel> createState() =>
      _AnimatedPaymentBottombarTravelState();
}

class _AnimatedPaymentBottombarTravelState
    extends State<AnimatedPaymentBottombarTravel>
    with TickerProviderStateMixin {
  late final AnimationController _loadingController;
  late final AnimationController _successController;

  bool _isLoading = false;
  bool _isSuccess = false;

  static const double _planeSize = 30;

  @override
  void initState() {
    super.initState();

    _loadingController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 4200),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed && mounted) {
            setState(() {
              _isLoading = false;
              _isSuccess = true;
            });
            _successController.forward(from: 0);
          }
        });

    _successController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 650),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const PaymentSuccesTravelScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                  ),
                );
              }
            });
          }
        });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _startPaymentAnimation();
      }
    });
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _startPaymentAnimation() {
    setState(() {
      _isLoading = true;
      _isSuccess = false;
    });

    _successController.reset();
    _loadingController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _buildCurrentState(),
        ),
      ),
    );
  }

  Widget _buildCurrentState() {
    if (_isSuccess) {
      return FadeTransition(
        key: const ValueKey('success'),
        opacity: CurvedAnimation(
          parent: _successController,
          curve: Curves.easeOut,
        ),
        child: SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: _successController,
                  curve: Curves.easeOutCubic,
                ),
              ),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1.0).animate(
              CurvedAnimation(
                parent: _successController,
                curve: Curves.easeOutBack,
              ),
            ),
            child: _buildSuccessContent(),
          ),
        ),
      );
    }

    if (_isLoading) {
      return AnimatedBuilder(
        key: const ValueKey('loading'),
        animation: _loadingController,
        builder: (context, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final double maxWidth = constraints.maxWidth;
              final double progress = Curves.easeInOutCubic.transform(
                _loadingController.value,
              );

              final double trackWidth = math.max(0, maxWidth - _planeSize);
              final double planeLeft = progress * trackWidth;

              final double bobbing =
                  math.sin(progress * math.pi * 8) * 4.0 * (1.0 - progress);
              final double rotation = math.sin(progress * math.pi * 2) * 0.025;
              final double scale = 1.0 - (progress * 0.08);
              final double opacity = progress > 0.9
                  ? ((1.0 - progress) / 0.1).clamp(0.0, 1.0)
                  : 1.0;

              final double textOpacity = (1.0 - (progress * 1.8)).clamp(
                0.0,
                1.0,
              );

              final double delayedProgress = ((progress - 0.08) / 0.92).clamp(
                0.0,
                1.0,
              );

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 34,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Opacity(
                          opacity: textOpacity,
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Menunggu....",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: planeLeft,
                          top: 2 + bobbing,
                          child: Transform.rotate(
                            angle: rotation,
                            child: Transform.scale(
                              scale: scale,
                              child: Opacity(
                                opacity: opacity,
                                child: Image.asset(
                                  'assets/icons/planeee.png',
                                  width: _planeSize,
                                  height: _planeSize,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: Stack(
                      children: [
                        Container(
                          height: 6,
                          width: maxWidth,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 70),
                          curve: Curves.linear,
                          height: 6,
                          width: delayedProgress * maxWidth,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0084FF),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    return Column(
      key: const ValueKey('idle'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Text(
              "Menunggu....",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/icons/planeee.png',
              width: _planeSize,
              height: _planeSize,
              fit: BoxFit.contain,
            ),
          ],
        ),
        const SizedBox(height: 16),
        PrimaryGradientButton(
          text: "Menunggu Pembayaran",
          onPressed: _startPaymentAnimation,
        ),
      ],
    );
  }

  Widget _buildSuccessContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double successProgress = Curves.easeOutCubic.transform(
          _successController.value,
        );

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 22,
                  height: 45,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 14, color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "Transaksi Berhasil! 🥳",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Stack(
                children: [
                  Container(
                    height: 6,
                    width: maxWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 60),
                    curve: Curves.linear,
                    height: 6,
                    width: successProgress * maxWidth,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
