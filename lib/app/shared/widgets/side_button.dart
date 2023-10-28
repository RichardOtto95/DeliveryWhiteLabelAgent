import 'package:delivery_agent_white_label/app/shared/utilities.dart';

import 'package:flutter/material.dart';

class SideButton extends StatelessWidget {
  final double? width;
  final double? height;
  final double? fontSize;
  final Widget? child;
  final bool isWhite;
  final void Function() onTap;
  final String title;

  const SideButton({
    Key? key,
    this.width,
    required this.onTap,
    this.title = '',
    this.height,
    this.child,
    this.isWhite = false,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width ?? wXD(81, context),
          height: height ?? wXD(44, context),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.horizontal(
            //   left: Radius.circular(isWhite ? 0 : 50),
            //   right: Radius.circular(isWhite ? 50 : 0),
            // ),
            border: Border.all(
              color: isWhite
                  ? getColors(context)
                      .onBackground
                      .withOpacity(.9)
                      .withOpacity(.25)
                  : getColors(context).primary,
            ),
            color: isWhite
                ? getColors(context).onSurface
                : getColors(context).primary,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                offset: Offset(0, 3),
                color: isWhite ? Color(0x80000000) : Color(0x30000000),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: child ??
              Text(
                title,
                style: textFamily(
                  context,
                  color: isWhite
                      ? getColors(context).primary
                      : getColors(context).onPrimary,
                  fontSize: fontSize ?? 18,
                ),
              ),
        ),
      ),
    );
  }
}
