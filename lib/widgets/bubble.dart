import 'package:flutter/material.dart';

class Bubble extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final Color? color;
  final bool? isFlat;
  const Bubble(
      {Key? key,
      required this.width,
      required this.height,
      required this.child,
      this.isFlat,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool itsFlat = isFlat ?? true;
    Color col = color ?? Theme.of(context).primaryColor;
    double radius = width / 10;
    //rounded card with text
    if (itsFlat) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: col, borderRadius: BorderRadius.circular(radius)),
        child: Center(
          child: child,
        ),
      );
    } else {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: col,
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
}
