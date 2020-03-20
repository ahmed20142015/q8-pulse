import 'package:flutter/material.dart';

class ChatClipper extends CustomClipper<Path> {
  
 @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(25, size.height-20);
    path.lineTo(25, size.height-20);
    path.lineTo(size.width, size.height-20);

  
    path.lineTo(size.width, 0);
    return path;
  }
  
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}