import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../advertisement_store.dart';

class IncludePhotos extends StatelessWidget {
  final void Function() onTap;
  final int imagesLength;
  IncludePhotos({Key? key, required this.onTap, required this.imagesLength})
      : super(key: key);

  final AdvertisementStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: wXD(196, context),
          width: wXD(imagesLength > 0 ? 159 : 342, context),
          margin: EdgeInsets.only(
              bottom: wXD(20, context),
              right: wXD(6, context),
              left: wXD(6, context)),
          decoration: BoxDecoration(
            color: getColors(context).onSurface,
            borderRadius: BorderRadius.all(Radius.circular(3)),
            border: Border.all(color: Color(0xfff1f1f1)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 4, offset: Offset(0, 4), color: Color(0x30000000))
            ],
          ),
          child: Observer(builder: (context) {
            return Column(
              children: [
                // SizedBox(height: wXD(40, context)),
                Spacer(flex: 2),
                Icon(
                  Icons.camera_alt_outlined,
                  size: wXD(50, context),
                  color: getColors(context).primary,
                ),
                // SizedBox(height: wXD(20, context)),
                Spacer(),
                Text(
                  'Incluir fotos',
                  style: textFamily(
                    context,
                    fontSize: imagesLength > 0 ? 12 : 15,
                    color: getColors(context).primary,
                  ),
                ),
                // SizedBox(height: wXD(19, context)),
                Spacer(),
                Text(
                  '${imagesLength + store.adEdit.images.length} de 6 adicionadas',
                  style: textFamily(
                    context,
                    fontSize: imagesLength > 0 ? 12 : 15,
                    color: getColors(context).onBackground.withOpacity(.9),
                  ),
                ),
                Visibility(
                  visible: store.imagesEmpty,
                  child: Text(
                    'Adicione imagens do produto',
                    style: textFamily(
                      context,
                      fontSize: 11,
                      color: Colors.red.shade400,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Spacer(flex: 2),
              ],
            );
          }),
        ),
      ),
    );
  }
}
