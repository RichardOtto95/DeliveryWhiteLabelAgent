import 'package:delivery_agent_white_label/app/modules/payment/payment_store.dart';

import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'add_card.dart';
import 'credit_card.dart';

class CardDetails extends StatelessWidget {
  final PaymentStore paymentStore = Modular.get();
  CardDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (paymentStore.confirmDeleteOverlay.mounted) {
          paymentStore.confirmDeleteOverlay.remove();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: maxHeight(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: maxWidth(context),
                    padding: EdgeInsets.only(
                      top: wXD(96, context),
                      bottom: wXD(30, context),
                    ),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(3)),
                        color: getColors(context).onBackground),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        CreditCard(width: wXD(257, context)),
                        SizedBox(height: wXD(33, context)),
                        Row(
                          children: [
                            SizedBox(width: wXD(41, context)),
                            Column(
                              children: [
                                CardField(
                                  title: 'Número do cartão',
                                  data: '• • • •  • • • •  • • • •  9999',
                                ),
                                SizedBox(height: wXD(23, context)),
                                CardField(
                                  title: 'Nome do titular do cartão',
                                  data: '• • • •  • • • •  ipsum',
                                ),
                              ],
                            ),
                            SizedBox(width: wXD(23, context)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CardField(
                                  width: wXD(81, context),
                                  title: 'Data de vencimento',
                                  data: '• • / • •',
                                ),
                                SizedBox(height: wXD(23, context)),
                                CardField(
                                  width: wXD(81, context),
                                  title: 'CVC',
                                  data: '• • •',
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  SideButton(
                    onTap: () => Overlay.of(context)
                        ?.insert(paymentStore.confirmDeleteOverlay),
                    title: 'Excluir cartão',
                    width: wXD(144, context),
                    height: wXD(52, context),
                  ),
                  SizedBox(height: wXD(28, context))
                ],
              ),
            ),
            DefaultAppBar('Detalhes do cartão'),
          ],
        ),
      ),
    );
  }
}
