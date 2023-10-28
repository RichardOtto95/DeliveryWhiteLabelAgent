import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../advertisement_store.dart';

class DeletePhotoPupUp extends StatelessWidget {
  DeletePhotoPupUp({Key? key}) : super(key: key);
  final AdvertisementStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(120, context),
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
        top: wXD(24, context),
        bottom: wXD(24, context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              store.removeImage();
              store.setDeleteImage(false);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete_outline,
                  size: wXD(25, context),
                  color: getColors(context).onBackground.withOpacity(.9),
                ),
                SizedBox(width: wXD(5, context)),
                Text(
                  'Excluir',
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
            onTap: () => store.setDeleteImage(false),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
