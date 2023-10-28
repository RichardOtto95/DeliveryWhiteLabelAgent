import 'package:flutter/material.dart';

import '../color_theme.dart';
import '../utilities.dart';

class Ball extends StatelessWidget {
  final double size;
  final Color? color;
  final IconData? icon;
  final BoxShape shape;
  final double bottom;
  const Ball({
    Key? key,
    this.size = 4,
    this.color,
    this.icon,
    this.shape = BoxShape.circle,
    this.bottom = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: wXD(bottom, context)),
      height: wXD(size, context),
      width: wXD(size, context),
      decoration: BoxDecoration(
        shape: shape,
        color: color ?? getColors(context).surface,
      ),
      child: icon == null
          ? Container()
          : Icon(
              icon,
              color: getColors(context).onSurface,
              size: wXD(12, context),
            ),
    );
  }
}
