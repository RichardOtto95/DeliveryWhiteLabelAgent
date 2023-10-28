import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/side_button.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_agent_white_label/app/modules/payment/payment_store.dart';
import 'package:flutter/material.dart';

import 'widgets/credit_card.dart';

class PaymentPage extends StatefulWidget {
  final String title;
  const PaymentPage({Key? key, this.title = 'PaymentPage'}) : super(key: key);
  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  final PaymentStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Observer(builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: wXD(97, context)),
                  Padding(
                    padding: EdgeInsets.only(
                      left: wXD(29, context),
                      bottom: wXD(17, context),
                    ),
                    child: Text(
                      'Meus cartões',
                      style: textFamily(
                        context,
                        fontSize: 17,
                        color: getColors(context).onBackground.withOpacity(.9),
                      ),
                    ),
                  ),
                  Container(
                    width: maxWidth(context),
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: wXD(6, context),
                        right: wXD(6, context),
                        bottom: wXD(22, context),
                      ),
                      scrollDirection: Axis.horizontal,
                      child: Observer(builder: (context) {
                        return Row(
                          children: [...store.cards.map((e) => CreditCard())],
                        );
                      }),
                    ),
                  ),
                  SideButton(
                    width: wXD(81, context),
                    onTap: () => Modular.to.pushNamed('/payment/add-card'),
                    child: Icon(
                      Icons.add_rounded,
                      size: wXD(30, context),
                      color: getColors(context).primary,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: wXD(22, context),
                      top: wXD(16, context),
                      bottom: wXD(8, context),
                    ),
                    child: Text(
                      'Histórico',
                      style: textFamily(
                        context,
                        fontSize: 17,
                        color: getColors(context).onBackground.withOpacity(.9),
                      ),
                    ),
                  ),
                  ...store.cards.map((e) => Transaction())
                ],
              );
            }),
          ),
          DefaultAppBar('Pagamento'),
        ],
      ),
    );
  }
}

class Transaction extends StatelessWidget {
  const Transaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(56, context),
      width: maxWidth(context),
      margin: EdgeInsets.symmetric(horizontal: wXD(22, context)),
      padding: EdgeInsets.only(top: wXD(13, context), bottom: wXD(8, context)),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: getColors(context)
                      .onBackground
                      .withOpacity(.9)
                      .withOpacity(.2)))),
      alignment: Alignment.topLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Transação realizada...',
            style: textFamily(
              context,
              fontSize: 15,
              color: getColors(context).onBackground.withOpacity(.7),
            ),
          ),
          Column(
            children: [
              Text(
                '- R\$ 120,00',
                style: textFamily(
                  context,
                  fontSize: 14,
                  color: getColors(context).onBackground.withOpacity(.7),
                ),
              ),
              Text(
                '15 de Março',
                style: textFamily(
                  context,
                  fontSize: 12,
                  color: getColors(context)
                      .onBackground
                      .withOpacity(.9)
                      .withOpacity(.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
