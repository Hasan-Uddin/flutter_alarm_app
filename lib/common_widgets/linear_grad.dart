import 'package:flutter/material.dart';

class LinearGrad extends StatelessWidget {
  final Widget? child;
  const LinearGrad({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, // Gradient starts at top center
          end: Alignment.bottomCenter,
          // Gradient ends at bottom center
          colors: [
            Color.fromARGB(248, 11, 0, 36),
            Color.fromARGB(0, 8, 34, 87), // End color (transparent)
          ],
        ),
      ),
      child: child,
    );
  }
}
