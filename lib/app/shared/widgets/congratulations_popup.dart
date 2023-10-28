import 'dart:ui';

import 'package:delivery_agent_white_label/app/shared/utilities.dart';

import 'package:flutter/material.dart';

class CongratulationsPopup extends StatelessWidget {
  final String text;
  final String subText;
  final void Function() onNewAd, onBack;
  final double? height;
  const CongratulationsPopup({
    Key? key,
    required this.text,
    required this.subText,
    required this.onNewAd,
    required this.onBack,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: maxHeight(context),
      width: maxWidth(context),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: GestureDetector(
          onTap: onBack,
          child: Container(
            height: maxHeight(context),
            width: maxWidth(context),
            color: getColors(context).shadow,
            alignment: Alignment.center,
            child: Material(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(3),
                topRight: Radius.circular(3),
              ),
              child: Container(
                height: wXD(155, context),
                width: wXD(327, context),
                padding: EdgeInsets.only(
                    bottom: wXD(19, context), top: wXD(11, context)),
                decoration: BoxDecoration(
                  color: getColors(context).onSurface,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(3),
                    topRight: Radius.circular(3),
                  ),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 18, color: getColors(context).onBackground)
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: textFamily(
                        context,
                        fontSize: 17,
                        color: getColors(context).onBackground,
                      ),
                    ),
                    SizedBox(height: wXD(11, context)),
                    Text(
                      subText,
                      textAlign: TextAlign.center,
                      style: textFamily(
                        context,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: getColors(context).onBackground,
                      ),
                    ),
                    SizedBox(height: wXD(9, context)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BlackButton(text: 'Voltar', onTap: onBack),
                        SizedBox(width: wXD(16, context)),
                        BlackButton(text: 'Novo anúncio', onTap: onNewAd),
                        SizedBox(width: wXD(20, context)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BlackButton extends StatelessWidget {
  final String text;
  final void Function() onTap;
  const BlackButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: wXD(47, context),
          // width: wXD(82, context),
          padding: EdgeInsets.symmetric(horizontal: wXD(20, context)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            color: getColors(context).onBackground,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: textFamily(context,
                color: getColors(context).primary, fontSize: 17),
          )),
    );
  }
}
