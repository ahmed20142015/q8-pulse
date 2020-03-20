import 'package:flutter/material.dart';

class ChatClipper2 extends CustomClipper<Path> {
  
 @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height-20);
    path.lineTo(size.width-25, size.height-20);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }
  
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}