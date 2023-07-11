import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SimpleAnimation playController = SimpleAnimation('Timeline 1');

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 200,
        width: 200,
        child: RiveAnimation.asset(
          'assets/logo.riv',
        ),
      ),
    );
  }
}
