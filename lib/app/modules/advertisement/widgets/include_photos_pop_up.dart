import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../advertisement_store.dart';

class IncludePhotosPopUp extends StatelessWidget {
  IncludePhotosPopUp({Key? key}) : super(key: key);
  final AdvertisementStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(161, context),
      width: maxWidth(context),
      decoration: BoxDecoration(
        color: getColors(context).onSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: Offset(0, -5),
            color: Color(0x90000000),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: wXD(38, context),
        top: wXD(36, context),
        bottom: wXD(22, context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => store.pickImage(),
            child: Row(
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: wXD(25, context),
                  color: getColors(context).onBackground.withOpacity(.9),
                ),
                SizedBox(width: wXD(5, context)),
                Text(
                  'Tirar foto',
                  style: textFamily(
                    context,
                    fontSize: 15,
                    color: getColors(context).onBackground.withOpacity(.9),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => store.uploadImage(),
            child: Row(
              children: [
                Icon(
                  Icons.picture_in_picture_rounded,
                  size: wXD(25, context),
                  color: getColors(context).onBackground.withOpacity(.9),
                ),
                SizedBox(width: wXD(5, context)),
                Text(
                  'Escolher existente...',
                  style: textFamily(
                    context,
                    fontSize: 15,
                    color: getColors(context).onBackground.withOpacity(.9),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              store.settakePicture(false);
            },
            child: Row(
              children: [
                Icon(
                  Icons.close,
                  size: wXD(25, context),
                  color: getColors(context).onBackground.withOpacity(.9),
                ),
                SizedBox(width: wXD(5, context)),
                Text(
                  'Cancelar',
                  style: textFamily(
                    context,
                    fontSize: 15,
                    color: getColors(context).onBackground.withOpacity(.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
