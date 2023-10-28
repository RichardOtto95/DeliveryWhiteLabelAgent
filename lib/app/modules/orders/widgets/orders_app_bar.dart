import 'package:delivery_agent_white_label/app/modules/orders/orders_store.dart';

import 'package:delivery_agent_white_label/app/shared/utilities.dart';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

class OrdersAppBar extends StatelessWidget {
  final OrdersStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).viewPadding.top + wXD(70, context),
      width: maxWidth(context),
      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(3)),
        color: getColors(context).surface,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(0, 3),
            color: Color(0x30000000),
          ),
        ],
      ),
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(3)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Missões',
              style: textFamily(
                context,
                fontSize: 20,
                color: getColors(context).primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: wXD(8, context)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: maxWidth(context),
                padding: EdgeInsets.symmetric(horizontal: wXD(40, context)),
                child: DefaultTabController(
                  length: 2,
                  child: TabBar(
                    indicatorColor: getColors(context).primary,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelPadding: EdgeInsets.symmetric(vertical: 8),
                    labelColor: getColors(context).primary,
                    labelStyle:
                        textFamily(context, fontWeight: FontWeight.w400),
                    unselectedLabelColor:
                        getColors(context).onBackground.withOpacity(.9),
                    indicatorWeight: 3,
                    onTap: (value) {
                      if (value == 0) {
                        store.setOrderStatusView([
                          "DELIVERY_ACCEPTED",
                          "SENDED",
                        ].asObservable());
                      } else if (value == 1) {
                        store.setOrderStatusView([
                          "DELIVERY_REFUSED",
                          "TIMEOUT",
                          "SEND_CANCELED",
                          "CONCLUDED",
                        ].asObservable());
                      }
                    },
                    tabs: const [
                      Text('Em andamento'),
                      Text('Anteriores'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
