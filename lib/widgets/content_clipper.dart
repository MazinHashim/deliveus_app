import 'package:flutter/material.dart';

class ContentClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final firstStart = Offset(0, 0);
    final firstEnd = Offset(size.width / 2.25, 25);
    final secondStart = Offset(size.width - 50, 50);
    final secondEnd = Offset(size.width, 0);
    final path = Path()
      ..moveTo(0, size.height / 4)
      ..lineTo(0, size.height / 4)
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
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
