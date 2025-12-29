import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';


class WelcomeMessage extends StatefulWidget {
  final String name;
  final RxBool showWelcome;

  const WelcomeMessage({
    Key? key,
    required this.name,
    required this.showWelcome,
  }) : super(key: key);

  @override
  State<WelcomeMessage> createState() => _WelcomeMessageState();
}

class _WelcomeMessageState extends State<WelcomeMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Smooth 1.2s transition
    );

    // Fade: 0 -> 1
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Slide: From slightly bottom to center
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    // Size (Height factor): 0 -> 1
    // We use SizeTransition on axis vertical
    _sizeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Listen to controller state
    ever(widget.showWelcome, (bool show) {
      if (show) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });

    // Initial check
    if (widget.showWelcome.value) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _sizeAnimation,
      axisAlignment: -1.0, // Expand from top
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Staggered-like Text Structure
              Container(
                padding: const EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: AppColors.primaryBlue.withOpacity(0.5),
                      width: 4,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.textSlate,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Gradient or specialized text style
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [AppColors.primaryBlue, Color(0xFF60A5FA)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          widget.name,
                          style: AppTextStyles.h1.copyWith(
                            fontSize: 42,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                            color: Colors.white, // Required for ShaderMask
                            letterSpacing: -1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
