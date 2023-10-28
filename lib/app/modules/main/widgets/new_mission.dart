import 'package:delivery_agent_white_label/app/core/models/directions_model.dart';
import 'package:delivery_agent_white_label/app/core/models/order_model.dart';

import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/ball.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import '../../orders/widgets/network_helper.dart';
import '../main_store.dart';

class NewMission extends StatefulWidget {
  const NewMission({Key? key}) : super(key: key);

  @override
  _NewMissionState createState() => _NewMissionState();
}

class _NewMissionState extends State<NewMission> {
  final MainStore store = Modular.get();

  // Seller? seller;
  // Address sellerAddress = Address();
  // Address customerAddress = Address();
  // double distanceToSeller = 0;
  DirectionsOSMap? toSellerDirection;
  DirectionsOSMap? toCustomerDirection;
  String totalDistance = "Indefinida";

  @override
  void initState() {
    print("neMission neMission neMission");
    super.initState();
  }

  Future<Order> getNewMissionData() async {
    Order _order = Order.fromDoc(store.missionInProgressOrderDoc!);

    Position myPosition = await determinePosition();

    MapLatLng myLatLng = MapLatLng(myPosition.latitude, myPosition.longitude);

    MapLatLng sellerPosition = MapLatLng(
        _order.sellerAddress!['latitude'], _order.sellerAddress!['longitude']);

    MapLatLng customerPosition = MapLatLng(_order.customerAddress!['latitude'],
        _order.customerAddress!['longitude']);

    try {
      print("seller try");
      NetworkHelper _network = NetworkHelper(
        startLat: myLatLng.latitude,
        startLng: myLatLng.longitude,
        endLat: sellerPosition.latitude,
        endLng: sellerPosition.longitude,
      );

      Map response = await _network.getData();

      print("final response: $response");

      toSellerDirection = response['direction-OSM'];
    } catch (e) {
      print("error on seller try");
      print(e);
    }

    try {
      print("customer try");
      NetworkHelper _network = NetworkHelper(
        startLat: myLatLng.latitude,
        startLng: myLatLng.longitude,
        endLat: customerPosition.latitude,
        endLng: customerPosition.longitude,
      );

      Map _response = await _network.getData();

      toCustomerDirection = _response['direction-OSM'];
    } catch (e) {
      print("error on customer try");
      print(e);
    }

    String sellerTotalDistance =
        toSellerDirection!.totalDistance.toLowerCase().replaceAll("km", "");
    String customerTotalDistance =
        toCustomerDirection!.totalDistance.toLowerCase().replaceAll("km", "");

    sellerTotalDistance = sellerTotalDistance.toLowerCase().replaceAll("m", "");
    customerTotalDistance =
        customerTotalDistance.toLowerCase().replaceAll("m", "");
    num toSellerDistance = 0;
    num toCustomerDistance = 0;
    try {
      toSellerDistance =
          num.parse(num.parse(sellerTotalDistance).toStringAsFixed(2));
      toCustomerDistance = num.parse(customerTotalDistance);
    } catch (e) {
      print(e);
    }

    totalDistance = (toSellerDistance + toCustomerDistance).toStringAsFixed(2);
    return _order;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Order>(
        future: getNewMissionData(),
        builder: (context, orderSnap) {
          if (orderSnap.hasError) {
            print('orderSnap.error: ${orderSnap.error}');
          }
          if (!orderSnap.hasData) {
            return const CenterLoadCircular();
          }
          Order order = orderSnap.data!;
          return Stack(
            children: [
              SingleChildScrollView(
                // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: viewPaddingTop(context) + wXD(60, context)),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: wXD(22, context)),
                            width: wXD(236, context),
                            height: wXD(101, context),
                            child: SvgPicture.asset(
                              "./assets/svg/motocycle.svg",
                              height: wXD(193, context),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: SvgPicture.asset(
                              "./assets/svg/locale.svg",
                              height: wXD(59, context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: wXD(17, context)),
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Text(
                        "R\$ ${formatedCurrency(order.priceRateDelivery)}",
                        style: textFamily(
                          context,
                          fontSize: 25,
                          color: getColors(context).primary,
                        ),
                      ),
                    ),
                    SizedBox(height: wXD(31, context)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: wXD(30, context)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: wXD(5, context)),
                            Ball(size: 6, color: getColors(context).primary),
                            const Ball(),
                            Ball(
                              size: 13,
                              color: getColors(context).primary,
                              icon: Icons.arrow_upward_rounded,
                            ),
                            Ball(
                                size: 6,
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.5)
                                    .withOpacity(.5)),
                            const Ball(),
                            const Ball(),
                            const Ball(),
                            const Ball(),
                            Ball(
                              size: 13,
                              color: getColors(context).primary,
                              icon: Icons.arrow_downward_rounded,
                            ),
                            Ball(
                                size: 6,
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.5)
                                    .withOpacity(.5)),
                            const Ball(),
                            const Ball(),
                            const Ball(),
                            Ball(size: 6, color: getColors(context).primary),
                          ],
                        ),
                        SizedBox(width: wXD(36, context)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${toSellerDirection!.totalDistance} até a primeira coleta",
                              style: textFamily(
                                context,
                                fontSize: 12,
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.9),
                              ),
                            ),
                            SizedBox(height: wXD(13, context)),
                            Text(
                              "Coletas: 1",
                              style: textFamily(
                                context,
                                fontSize: 16,
                                color: getColors(context).onBackground,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: wXD(2, context)),
                            Text(
                              order.storeName!,
                              style: textFamily(
                                context,
                                fontSize: 12,
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.9),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: wXD(48, context)),
                            Text(
                              "Entregas: 1",
                              style: textFamily(
                                context,
                                fontSize: 16,
                                color: getColors(context).onBackground,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: wXD(2, context)),
                            SizedBox(
                              width: wXD(200, context),
                              child: Text(
                                order.customerFormatedAddress!,
                                style: textFamily(
                                  context,
                                  fontSize: 12,
                                  color: getColors(context)
                                      .onBackground
                                      .withOpacity(.9),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(height: wXD(31, context)),
                            Text(
                              "Percurso total de ${totalDistance}km",
                              style: textFamily(
                                context,
                                fontSize: 16,
                                color: getColors(context).onBackground,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // const Spacer(),
                  ],
                ),
              ),
              // Positioned(
              //   bottom: wXD(0, context),
              //   child: Container(
              //     height: wXD(147, context),
              //     width: maxWidth(context),
              //     alignment: Alignment.topCenter,
              //     child: Row(
              //       children: [
              //         const Spacer(),
              //         SvgPicture.asset("./assets/svg/refuse.svg"),
              //         const Spacer(),
              //         SvgPicture.asset("./assets/svg/3backward.svg"),
              //         const Spacer(flex: 3),
              //         SvgPicture.asset("./assets/svg/3frontward.svg"),
              //         const Spacer(),
              //         SvgPicture.asset("./assets/svg/confirm.svg"),
              //         const Spacer(),
              //       ],
              //     ),
              //   ),
              // ),
              DefaultAppBar("Nova missão", noPop: true),
            ],
          );
        });
  }
}
