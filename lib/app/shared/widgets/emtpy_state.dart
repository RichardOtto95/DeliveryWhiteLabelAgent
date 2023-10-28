import 'package:flutter/material.dart';
import '../utilities.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final double? top;
  final String? asset;
  const EmptyState({Key? key, required this.title, this.asset, this.top})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: top ?? 0),
      height: maxHeight(context),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment:
            top != null ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          Image.asset(
            asset ?? './assets/images/emptyState.png',
            width: wXD(200, context),
            height: wXD(160, context),
            alignment: Alignment.center,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: wXD(30, context)),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: textFamily(
                context,
                fontSize: 20,
                color: getColors(context).primary,
              ),
            ),
          )
        ],
      ),
    );
  }
}
