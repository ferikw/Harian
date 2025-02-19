import 'package:flutter/material.dart';
import 'package:harian/presentasion/controllers/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  final SplashController _controller = SplashController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _controller.navigateToNextPage(context);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: const [
                        Colors.transparent,
                        Colors.white,
                        Colors.transparent,
                      ],
                      stops: [
                        (_animationController.value - 0.2).clamp(0.0, 1.0),
                        _animationController.value.clamp(0.0, 1.0),
                        (_animationController.value + 0.2).clamp(0.0, 1.0),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.srcATop,
                  child: child,
                );
              },
              child: Image.asset(
                "assets/images/harian.png",
                width: 300,
                height: 300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
