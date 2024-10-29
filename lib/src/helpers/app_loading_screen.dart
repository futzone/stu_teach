import 'package:flutter/material.dart';

class AppLoadingScreen extends StatelessWidget {
  final EdgeInsets? padding;
  final double size;

  const AppLoadingScreen({this.padding = EdgeInsets.zero, super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: SizedBox(
          height: size,
          width: size,
          child: const CircularProgressIndicator(strokeWidth: 8),
        ),
      ),
    );
  }
}
