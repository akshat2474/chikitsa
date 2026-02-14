import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chikitsa/screens/home_screen.dart';

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
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // Navigate after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (widget.onAnimationComplete != null) {
        widget.onAnimationComplete!();
      } else {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            'Chikitsa',
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
