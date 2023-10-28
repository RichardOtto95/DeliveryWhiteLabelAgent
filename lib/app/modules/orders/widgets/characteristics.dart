import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/see_all_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'characteristic.dart';

class Characteristics extends StatelessWidget {
  const Characteristics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: wXD(24, context)),
          width: maxWidth(context),
          margin: EdgeInsets.only(top: wXD(37, context)),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: wXD(20, context)),
                child: Text(
                  'Caracteristicas do produto',
                  style: textFamily(
                    context,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: getColors(context).onBackground.withOpacity(.9),
                  ),
                ),
              ),
              Characteristic(title: 'Tamanho da tela', data: '6.5'),
              Characteristic(title: 'Memória interna', data: '64 GB'),
              Characteristic(
                  title: 'Câmera frontal ou principal', data: '8 Mpx'),
              Characteristic(
                  title: 'Câmera traseira principal', data: '48 Mpx'),
              Characteristic(title: 'Desbloqueio', data: 'Impressão digital'),
            ],
          ),
        ),
        SeeAllButton(
          title: 'Ver todas as caracteristicas',
          onTap: () => Modular.to.pushNamed('/orders/characteristics'),
        ),
        SizedBox(height: wXD(30, context)),
      ],
    );
  }
}
