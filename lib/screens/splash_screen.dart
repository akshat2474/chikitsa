import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChikitsaSplashScreen extends StatefulWidget {
  final VoidCallback? onAnimationComplete;
  
  const ChikitsaSplashScreen({
    super.key,
    this.onAnimationComplete,
  });

  @override
  State<ChikitsaSplashScreen> createState() => _ChikitsaSplashScreenState();
}

class _ChikitsaSplashScreenState extends State<ChikitsaSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _navigateAfterDelay();
  }

  void _setupAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  void _navigateAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      widget.onAnimationComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Chikitsa',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF6B6B), 
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 56,
                        height: 1.2,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: 'Rural healthcare, ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'simplified',
                          style: TextStyle(
                            color: Color(0xFFE8997F),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        TextSpan(
                          text: '.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Text(
                    'AI diagnostics. Medicine safety. Disease surveillance.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withValues(alpha: .5),
                      fontWeight: FontWeight.w300,
                      height: 1.5,
                    ),
                  ),
                  
                  const Spacer(flex: 2),
                  
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        widget.onAnimationComplete?.call();
                      },
                      child: Center(
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: .2),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
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
