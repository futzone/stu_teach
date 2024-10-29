import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;

  const SimpleButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        onTap: onPressed,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: child,
      ),
    );
  }
}
