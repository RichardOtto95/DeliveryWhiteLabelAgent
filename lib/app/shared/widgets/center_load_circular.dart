import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';

import '../color_theme.dart';

class CenterLoadCircular extends StatelessWidget {
  const CenterLoadCircular({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: maxHeight(context),
      width: maxWidth(context),
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(getColors(context).primary),
      ),
    );
  }
}
