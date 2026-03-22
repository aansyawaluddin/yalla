import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final Duration initialDuration;

  const CountdownTimer({
    super.key,
    this.initialDuration = const Duration(hours: 1, minutes: 59, seconds: 59),
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.initialDuration;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        setState(() {
          _timeLeft -= const Duration(seconds: 1);
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String hours = _timeLeft.inHours.toString().padLeft(2, '0');
    String minutes = (_timeLeft.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (_timeLeft.inSeconds % 60).toString().padLeft(2, '0');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTimeCircle(hours, "JAM"),
        const SizedBox(width: 8),
        _buildTimeCircle(minutes, "MENIT"),
        const SizedBox(width: 8),
        _buildTimeCircle(seconds, "DETIK"),
      ],
    );
  }

  Widget _buildTimeCircle(String number, String label) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF00A2FF), Color(0xFF005C99)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ClipRect(
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.5),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                );
              },
              child: Text(
                number,
                key: ValueKey<String>(number),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black38,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
