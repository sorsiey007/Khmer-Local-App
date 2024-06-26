import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _bgGradientAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Increase duration to 4 seconds
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutBack,
      ),
    );

    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _bgGradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
      ),
    );

    // Start the animation
    _controller.forward();

    // Navigate to the next page after a delay
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const NextPage()),
          );
        });
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
      backgroundColor:
          const Color(0xFFFFF0FB), // Light greenish background color
      body: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Background gradient with animated opacity
              AnimatedOpacity(
                opacity: _bgGradientAnimation.value,
                duration: const Duration(seconds: 1),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFF0FB), // Light green gradient start color
                        Color(0xFFFFF0FB), // Light green gradient end color
                      ],
                    ),
                  ),
                ),
              ),
              // Animated content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main logo with scale effect
                  ScaleTransition(
                    scale: _logoScaleAnimation,
                    child: SvgPicture.asset(
                      'assets/main_logo.svg',
                      width: 130.0, // Adjusted width to make the logo smaller
                      // height: 150.0, // Adjusted height to maintain aspect ratio
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // Text logo with fade-in and slide-up effect
                  SlideTransition(
                    position: _textSlideAnimation,
                    child: FadeTransition(
                      opacity: _textOpacityAnimation,
                      child: SvgPicture.asset(
                        'assets/text_logo.svg',
                        width: 150.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  const NextPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0FB), // Matched background color
      appBar: AppBar(
        title: const Text("Next Page"),
        backgroundColor: const Color(0xFFFFF0FB), // Matched app bar color
      ),
      body: const Center(
        child: Text(
          "Welcome to the Next Page!",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 24.0,
          ),
        ),
      ),
    );
  }
}
