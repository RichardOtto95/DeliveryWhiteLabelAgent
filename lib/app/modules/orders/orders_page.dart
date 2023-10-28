import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_agent_white_label/app/modules/main/main_store.dart';
import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobx/mobx.dart';

import 'orders_store.dart';
import 'widgets/order.dart';
import 'widgets/orders_app_bar.dart';

class OrdersPage extends StatefulWidget {
  @override
  OrdersPageState createState() => OrdersPageState();
}

class OrdersPageState extends State<OrdersPage> {
  final OrdersStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  ScrollController scrollController = ScrollController();
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    store.setOrderStatusView([
      "DELIVERY_ACCEPTED",
      "SENDED",
    ].asObservable());
    scrollController = ScrollController();
    addListener();
    super.initState();
  }

  @override
  void dispose() {
    store.cleanMissionInProgressVars();
    scrollController.dispose();
    super.dispose();
  }

  addListener() {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        mainStore.setVisibleNav(false);
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        mainStore.setVisibleNav(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Observer(
          builder: (context) {
            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("agents")
                  .doc(_user!.uid)
                  .collection("orders")
                  .where("status", whereIn: store.viewableOrderStatus)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CenterLoadCircular();
                }

                List<QueryDocumentSnapshot<Map<String, dynamic>>> orders =
                    snapshot.data!.docs;

                return SingleChildScrollView(
                  controller: scrollController,
                  child: orders.isEmpty
                      ? Container(
                          width: maxWidth(context),
                          height: maxHeight(context),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.file_copy_outlined,
                              //   size: wXD(90, context),
                              // ),
                              SvgPicture.asset(
                                "./assets/svg/target.svg",
                                height: wXD(90, context),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                store.viewableOrderStatus
                                        .contains("DELIVERY_ACCEPTED")
                                    ? "Sem missões em andamento"
                                    : "Sem missões anteriores",
                                style: textFamily(context),
                              ),
                              // Text(
                              //     store.viewableOrderStatus
                              //             .contains("REQUESTED")
                              //         ? "Sem pedidos pendentes ainda!"
                              //         : store.viewableOrderStatus
                              //                 .contains("PROCESSING")
                              //             ? "Sem pedidos em andamento"
                              //             : "Sem pedidos anteriores",
                              //     style: textFamily()),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                                height: MediaQuery.of(context).viewPadding.top +
                                    wXD(70, context)),
                            ...orders.map(
                              (order) => OrderWidget(
                                orderDoc: order,
                                status: order["status"],
                              ),
                            ),
                            SizedBox(height: wXD(120, context)),
                          ],
                        ),
                );
              },
            );
          },
        ),
        OrdersAppBar(),
      ],
    );
  }
}
