import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';
import 'package:yalla/features/user/home/search/search_screen.dart';

class AnimatedSearchBar extends StatefulWidget {
  final int selectedServiceIndex;

  const AnimatedSearchBar({super.key, this.selectedServiceIndex = 0});

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  final List<String> _searchHints = [
    "Cari Penerbangan",
    "Cari Hotel",
  ];

  String _displayedText = "";
  late int _hintIndex;
  int _charIndex = 0;
  bool _isDeleting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _hintIndex = widget.selectedServiceIndex;
    _startTyping();
  }

  @override
  void didUpdateWidget(AnimatedSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedServiceIndex != oldWidget.selectedServiceIndex) {
      setState(() {
        _hintIndex = widget.selectedServiceIndex;
        _charIndex = 0;
        _displayedText = "";
        _isDeleting = false;
      });
    }
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
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 5),
                    child: Icon(
                      Icons.search,
                      color: Color(0xFF005C99),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),

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
