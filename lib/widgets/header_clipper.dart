import 'package:flutter/material.dart';

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final firstStart = Offset(size.width / 7, size.height);
    final firstEnd = Offset(size.width / 2.25, size.height - 25);
    final secondStart = Offset(size.width - 50, size.height - 50);
    final secondEnd = Offset(size.width, size.height);
    final path = Path()
      ..lineTo(0, 0)
      ..quadraticBezierTo(
        firstStart.dx,
        firstStart.dy,
        firstEnd.dx,
        firstEnd.dy,
      )
      ..quadraticBezierTo(
        secondStart.dx,
        secondStart.dy,
        secondEnd.dx,
        secondEnd.dy,
      )
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
