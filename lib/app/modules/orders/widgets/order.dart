import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_agent_white_label/app/core/models/order_model.dart';
import 'package:delivery_agent_white_label/app/modules/main/main_store.dart';

import 'package:delivery_agent_white_label/app/shared/utilities.dart';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import '../orders_store.dart';

class OrderWidget extends StatefulWidget {
  final DocumentSnapshot orderDoc;
  final String status;

  OrderWidget({
    Key? key,
    required this.orderDoc,
    required this.status,
  }) : super(key: key);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  final MainStore mainStore = Modular.get();
  final OrdersStore store = Modular.get();

  late OverlayEntry overlayEntry;

  late Order orderModel;

  initState() {
    orderModel = Order.fromDoc(widget.orderDoc);
    super.initState();
  }

  String getText() {
    // print("orderModel.status: ${orderModel.status}");
    switch (widget.status) {
      case "DELIVERY_ACCEPTED":
        return "Ver rota em andamento";
      case "SENDED":
        return "Ver rota em andamento";
      case "DELIVERY_REFUSED":
        return "Recusado";
      case "DELIVERY_CANCELED":
        return "Cancelado";
      case "SEND_CANCELED":
        return "Cancelador";
      case "TIMEOUT":
        return "Tempo esgotado";
      default:
        return "Concluído";
    }
  }

  @override
  Widget build(BuildContext context) {
    // String canRefStatus = "";
    // String canRefText = "";
    // String accSenStatus = "";
    // String accSenText = "";

    // if (orderModel.status == "DELIVERY_ACCEPTED" ||
    //     orderModel.status == "SENDED")
    //     {
    //       canRefStatus = "REFUSED";
    //       canRefText = "Recusar";
    //       accSenStatus = "PROCESSING";
    //       accSenText = "Confirmar";
    //     }
    //   switch (orderModel.status) {
    //     case "DELIVERY":
    //       canRefStatus = "REFUSED";
    //       canRefText = "Recusar";
    //       accSenStatus = "PROCESSING";
    //       accSenText = "Confirmar";
    //       break;
    //     case "PROCESSING":
    //       canRefStatus = "CANCELED";
    //       canRefText = "Cancelar";
    //       accSenStatus = "DELIVERY_REQUESTED";
    //       accSenText = "Enviar";
    //       break;
    //     case "DELIVERY_REQUESTED":
    //       canRefStatus = "CANCELED";
    //       canRefText = "Cancelar";
    //       accSenStatus = "SENDED";
    //       accSenText = "Despachar";
    //       break;
    //     case "SENDED":
    //       canRefText = "Cancelar";
    //       accSenText = "Despachar";
    //       break;
    //     case "CONCLUDED":
    //       canRefText = "Reembolsar";
    //       accSenText = "Enviar mensagem";
    //       break;
    //     default:
    //   }
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: wXD(6, context),
              left: wXD(4, context),
              top: wXD(20, context),
            ),
            child: Text(
              getOrderDate(widget.orderDoc['created_at'].toDate()),
              style: textFamily(
                context,
                fontSize: 14,
                color: getColors(context).onBackground.withOpacity(.8),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            height: wXD(140, context),
            width: wXD(352, context),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffF1F1F1)),
              borderRadius: BorderRadius.all(Radius.circular(3)),
              color: getColors(context).surface,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  offset: Offset(0, 3),
                  color: getColors(context).shadow,
                )
              ],
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: getColors(context)
                                  .onBackground
                                  .withOpacity(.9)
                                  .withOpacity(.2)))),
                  padding: EdgeInsets.only(bottom: wXD(7, context)),
                  margin: EdgeInsets.fromLTRB(
                    wXD(19, context),
                    wXD(18, context),
                    wXD(15, context),
                    wXD(0, context),
                  ),
                  alignment: Alignment.center,
                  child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance
                          .collection("orders")
                          .doc(widget.orderDoc.id)
                          .collection("ads")
                          .get(),
                      builder: (context, orderAdsSnap) {
                        if (!orderAdsSnap.hasData) {
                          return Container();
                        }
                        return StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("ads")
                              .doc(orderAdsSnap.data!.docs.first.id)
                              .snapshots(),
                          builder: (context, adsSnap) {
                            if (!adsSnap.hasData) {
                              return Container(
                                height: wXD(65, context),
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                    getColors(context).primary,
                                  ),
                                ),
                              );
                            }
                            DocumentSnapshot pdt = adsSnap.data!;
                            // print("pdt: ${pdt.data()}");
                            return InkWell(
                              // onTap: () async {
                              //   print(
                              //       'store viewableOrderStatus: ${store.viewableOrderStatus}');
                              //   print(
                              //       "order status: ${widget.orderDoc['status']}");
                              //   if (widget.orderDoc['status'] == "PROCESSING" ||
                              //       widget.orderDoc['status'] == "REQUESTED") {
                              //     store.setOrderSelected(orderModel);
                              //     await Modular.to.pushNamed(
                              //         '/orders/order-details',
                              //         arguments: pdt);
                              //   } else {
                              //     await Modular.to.pushNamed(
                              //         '/orders/shipping-details',
                              //         arguments: orderModel.id);
                              //   }
                              // },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    child: CachedNetworkImage(
                                      imageUrl: pdt['images'].first,
                                      height: wXD(65, context),
                                      width: wXD(62, context),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: wXD(8, context)),
                                        width: wXD(220, context),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(height: wXD(3, context)),
                                            Text(
                                              pdt['title'],
                                              style: textFamily(context,
                                                  color: getColors(context)
                                                      .onBackground),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: wXD(3, context)),
                                            Text(
                                              pdt['description'],
                                              style: textFamily(context,
                                                  color: getColors(context)
                                                      .onBackground
                                                      .withOpacity(.5)),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: wXD(3, context)),
                                            Text(
                                              widget.orderDoc['total_amount'] >
                                                      1
                                                  ? '${widget.orderDoc['total_amount']} itens'
                                                  : '${widget.orderDoc['total_amount']} item',
                                              style: textFamily(context,
                                                  color: getColors(context)
                                                      .onBackground
                                                      .withOpacity(.7)
                                                      .withOpacity(.7)),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                ),
                Spacer(),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (widget.status == "DELIVERY_ACCEPTED" ||
                          widget.status == "SENDED") {
                        mainStore.missionInProgressOrderDoc = widget.orderDoc;
                        Modular.to.pushNamed(
                          "/orders/mission-in-progress",
                          arguments: mainStore.missionInProgressOrderDoc!.id,
                        );
                      }
                    },
                    child: Text(
                      getText(),
                      style: textFamily(
                        context,
                        color: getColors(context).primary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }

  String getOrderDate(DateTime date) {
    String strDate = '';

    String weekDay = DateFormat('EEEE').format(date);
    // print("weekDay: $weekDay");

    String month = DateFormat('MMMM').format(date);
    // print("month: $month");

    strDate =
        "${weekDay.substring(0, 1).toUpperCase()}${weekDay.substring(1, 3)} ${date.day} $month ${date.year}";

    // print("strDate: $strDate");

    return strDate;
  }
}
