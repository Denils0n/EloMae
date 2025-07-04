import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    this.isActive = false,
    super.key,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    Color color;
    double width;
    double height;

    if(isActive){
      color = const Color(0xFF8566E0);
      width = 14;
      height = 14;
    } else {
      color = const Color(0xFFE0E0E0);
      width = 10;
      height = 10;
    }
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}