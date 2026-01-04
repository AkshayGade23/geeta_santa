import 'package:flutter/material.dart';

double scaleWidth(BuildContext context, double px) {
  final screenWidth = MediaQuery.of(context).size.width;
  return px / 432 * screenWidth; // 1080 = base design width
}

double scaleHeight(BuildContext context, double px) {
  final screenHeight = MediaQuery.of(context).size.height;
  return px / 960 * screenHeight; // 2460 = base design height
}

double scaleFont(BuildContext context, double fontSize) {
  final screenWidth = MediaQuery.of(context).size.width;
  return fontSize * screenWidth / 432; // 1080 = your base design width
}