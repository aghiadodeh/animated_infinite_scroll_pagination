import 'package:flutter/material.dart';

class CustomAnimatedOpacityWidget extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const CustomAnimatedOpacityWidget({
    required this.child,
    this.duration = const Duration(milliseconds: 700),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeInOut,
      duration: duration,
      child: child,
      builder: (context, value, child) => Opacity(
        child: child,
        opacity: value,
      ),
    );
  }
}
