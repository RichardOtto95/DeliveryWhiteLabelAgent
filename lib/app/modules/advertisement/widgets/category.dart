import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../advertisement_store.dart';

class Category extends StatelessWidget {
  final AdvertisementStore store = Modular.get();
  @override
  Widget build(BuildContext context) {
    List options = [
      'Opção 1',
      'Opção 2',
      'Opção 3',
      'Opção 4',
      'Opção 5',
      'Opção 6',
      'Opção 7',
      'Opção 8',
      'Opção 9',
    ];
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: wXD(77, context)),
                ...options.map((e) => GestureDetector(
                      onTap: () {
                        store.editingAd
                            ? store.adEdit.option = e
                            : store.setAnnouncementOption(e);
                        store.categoryValidateVisible = false;
                        Modular.to.pushNamedAndRemoveUntil(
                            '/advertisement/create-announcement',
                            ModalRoute.withName(
                                '/advertisement/create-announcement'));
                      },
                      child: Container(
                        width: maxWidth(context),
                        height: wXD(52, context),
                        margin:
                            EdgeInsets.symmetric(horizontal: wXD(23, context)),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: getColors(context)
                                        .onBackground
                                        .withOpacity(.9)
                                        .withOpacity(.2)))),
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e,
                              style: textFamily(
                                context,
                                color: getColors(context).primary,
                                fontSize: 17,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              size: wXD(23, context),
                              color: getColors(context).primary,
                            )
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ),
          DefaultAppBar('Categoria 1')
        ],
      ),
    );
  }
}
