import 'package:flutter/material.dart';

class Bubble extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  const Bubble(
      {Key? key,
      required this.width,
      required this.height,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double radius = width / 10;
    //rounded card with text
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: radius,
            offset: Offset(0, radius),
          ),
        ],
      ),
      child: Center(
        child: child,
      ),
    );
  }
}
