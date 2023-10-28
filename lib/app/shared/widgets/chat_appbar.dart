import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../color_theme.dart';
import '../utilities.dart';

class ChatAppbar extends StatelessWidget {
  const ChatAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(73, context),
      width: maxWidth(context),
      padding: EdgeInsets.only(top: wXD(40, context)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(3),
        ),
        color: getColors(context).surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            color: Color(0x30000000),
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: wXD(30, context)),
              alignment: Alignment.centerLeft,
              child: Transform.rotate(
                angle: math.pi * -.5,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: wXD(25, context),
                  color: getColors(context).primary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                'Carrinho',
                style: TextStyle(
                  color: getColors(context).onBackground,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: wXD(16, context)),
              child: Text(
                'Limpar',
                style: TextStyle(
                  color: getColors(context).primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
