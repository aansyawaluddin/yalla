import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';
import 'package:yalla/features/user/search/search_screen.dart'; 

class AnimatedSearchBar extends StatefulWidget {
  const AnimatedSearchBar({super.key});

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  final List<String> _searchHints = ["Cari Penerbangan", "Cari Hotel"];

  String _displayedText = "";
  int _hintIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    final int durationMs = _isDeleting ? 50 : 100;

    _timer = Timer.periodic(Duration(milliseconds: durationMs), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final String currentHint = _searchHints[_hintIndex];

      setState(() {
        if (!_isDeleting) {
          if (_charIndex < currentHint.length) {
            _charIndex++;
            _displayedText = currentHint.substring(0, _charIndex);
          } else {
            _timer?.cancel();
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() => _isDeleting = true);
                _startTyping();
              }
            });
          }
        } else {
          if (_charIndex > 0) {
            _charIndex--;
            _displayedText = currentHint.substring(0, _charIndex);
          } else {
            _isDeleting = false;
            _hintIndex = (_hintIndex + 1) % _searchHints.length;

            _timer?.cancel();
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) _startTyping();
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              reverseTransitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const SearchScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    var curvedAnimation = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    );
                    return FadeTransition(
                      opacity: curvedAnimation,
                      child: child,
                    );
                  },
            ),
          );
        },
        child: Hero(
          tag: 'search_bar_hero',
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: AppColors.line, width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.black, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "$_displayedText|",
                      style: AppTypography.regular14.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
