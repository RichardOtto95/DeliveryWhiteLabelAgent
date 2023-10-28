import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_agent_white_label/app/core/models/address_model.dart';
import 'package:delivery_agent_white_label/app/modules/main/main_store.dart';

import 'package:delivery_agent_white_label/app/shared/delivery_search_field.dart';
import 'package:delivery_agent_white_label/app/shared/overlays.dart';
import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/address.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/side_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_agent_white_label/app/modules/address/address_store.dart';
import 'package:flutter/material.dart';
// import '../../shared/widgets/address_popup.dart';
// import '../../shared/widgets/load_circular_overlay.dart';

class AddressPage extends StatefulWidget {
  final bool signRoot;

  AddressPage({Key? key, this.signRoot = false}) : super(key: key);
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends ModularState<AddressPage, AddressStore> {
  final MainStore mainStore = Modular.get();
  final AddressStore addressStore = Modular.get();
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    print("SignRoot: ${widget.signRoot}");
    // print("initState: ${addressStore.mainStore.authStore.user}");
    super.initState();
  }

  bool hasAddress = false;

  @override
  Widget build(context) {
    return WillPopScope(
      onWillPop: () async {
        // print("pop pop popop p");
        // print(
        //     "mainStore.globalOverlay!.mounted: ${mainStore.globalOverlay!.mounted}");
        // if (mainStore.globalOverlay!.mounted) {
        //   mainStore.globalOverlay!.remove();
        //   mainStore.globalOverlay = null;
        //   return false;
        // } else {
        return true;
        // }
      },
      child: Scaffold(
        backgroundColor: getColors(context).background,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: maxHeight(context),
              width: maxWidth(context),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: wXD(101, context)),
                    DeliverySearchField(
                      onTap: () async {
                        store.locationResult =
                            await Modular.to.pushNamed("/address/place-picker");
                        print(
                            'store.locationResult != null: ${store.locationResult != null}');
                        if (store.locationResult != null)
                          Overlays(context).insertAddAddress();
                        // print("Result: ${store.locationResult!.city!.name}");
                        // print(
                        //     "Result: ${store.locationResult!.subLocalityLevel1!.name}");
                        // print(
                        //     "Result: ${store.locationResult!.subLocalityLevel2!.name}");
                        // print(
                        //     "Result: ${store.locationResult!.administrativeAreaLevel2!.name}");
                        // print(
                        //     "Result: ${store.locationResult!.administrativeAreaLevel1!.name}");
                        // print("Result: ${store.locationResult!.country!.name}");
                        // print("Result: ${store.locationResult!.locality}");
                        // print("Result: ${store.locationResult!.name}");
                        // print(
                        //     "Result: ${store.locationResult!.formattedAddress}");
                        // print("Result: ${store.locationResult!.latLng}");
                      },
                    ),
                    // UseCurrentLocalization(),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("agents")
                          .doc(_user!.uid)
                          .collection("addresses")
                          .where("status", isEqualTo: "ACTIVE")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CenterLoadCircular();
                        }
                        List<DocumentSnapshot> addresses = snapshot.data!.docs;
                        if (addresses.isEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() => hasAddress = false);
                          });
                          return Container(
                            height: maxHeight(context) - wXD(300, context),
                            width: maxWidth(context),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  size: wXD(150, context),
                                ),
                                Text(
                                  "Sem endereços ainda",
                                  style: textFamily(context, fontSize: 15),
                                )
                              ],
                            ),
                          );
                        }
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() => hasAddress = true);
                        });
                        return Column(
                          children: addresses
                              .map((address) => AddressWidget(
                                    model: Address.fromDoc(address),
                                    iconTap: () {
                                      addressStore.getAdressPopUpOverlay(
                                          Address.fromDoc(address), context);
                                    },
                                  ))
                              .toList(),
                        );
                      },
                    ),
                    // RecentAddress(
                    //   iconTap: () {
                    //     Overlay.of(context)?.insert(addressStore.overlayEntry);
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
            Positioned(
                top: 0,
                child: DefaultAppBar('Endereço de entrega',
                    noPop: widget.signRoot)),
            Visibility(
              visible: widget.signRoot && hasAddress,
              child: Positioned(
                bottom: wXD(50, context),
                right: 0,
                child: SideButton(
                  title: "Continuar",
                  height: wXD(52, context),
                  width: wXD(120, context),
                  onTap: () {
                    if (widget.signRoot) {
                      Modular.to.pushNamed("/main");
                    } else {
                      Modular.to.pop();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UseCurrentLocalization extends StatelessWidget {
  const UseCurrentLocalization({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      padding: EdgeInsets.only(
          left: wXD(27, context),
          top: wXD(34, context),
          bottom: wXD(24, context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.my_location,
            size: wXD(20, context),
            color: getColors(context).onBackground.withOpacity(.5),
          ),
          SizedBox(width: wXD(12, context)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Usar localização atual',
                style: textFamily(
                  context,
                  fontSize: 15,
                  color: getColors(context).primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                width: wXD(225, context),
                child: Text(
                  'St. Hab. Vicente Pires Chácara 26 - Taguatinga, Brasília - DF ',
                  style: textFamily(
                    context,
                    fontSize: 13,
                    color: getColors(context).onBackground.withOpacity(.55),
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class RecentAddress extends StatelessWidget {
  final void Function() iconTap;
  const RecentAddress({Key? key, required this.iconTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: wXD(162, context),
      width: wXD(352, context),
      margin: EdgeInsets.only(bottom: wXD(13, context)),
      padding: EdgeInsets.fromLTRB(
        0,
        wXD(11, context),
        wXD(17, context),
        wXD(11, context),
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        border: Border.all(color: Color(0xfff1f1f1), width: wXD(2, context)),
        color: getColors(context).surface,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(0, 3),
            color: Color(0x20000000),
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: wXD(335, context),
            padding: EdgeInsets.only(left: wXD(53, context)),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: wXD(5, context)),
                  child: Text(
                    'St. Hab. Vicente Pires, 25',
                    style: textFamily(context, fontSize: 15),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: iconTap,
                  child: Icon(
                    Icons.more_vert,
                    color: getColors(context).primary,
                    size: wXD(24, context),
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: wXD(15, context),
                    right: wXD(13, context),
                    bottom: wXD(15, context)),
                child: Icon(
                  Icons.av_timer,
                  color: getColors(context).onBackground.withOpacity(.5),
                  size: wXD(24, context),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: wXD(200, context),
                    child: Text(
                      'Brasília, Brasília - DF',
                      style: textFamily(
                        context,
                        color: getColors(context).onBackground.withOpacity(.55),
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ),
                  Container(
                    width: wXD(250, context),
                    child: Text(
                      'Condomínio Hawai - O Condomínio fica de frente para o último balão da via marginal com a estrutural',
                      style: textFamily(
                        context,
                        color: getColors(context).onBackground.withOpacity(.55),
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WhiteButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function() onTap;

  const WhiteButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(3)),
      child: Container(
        height: wXD(47, context),
        width: wXD(116, context),
        decoration: BoxDecoration(
          color: getColors(context).surface,
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          border: Border.all(
              color: getColors(context).onBackground.withOpacity(.33)),
          boxShadow: const [
            BoxShadow(
              blurRadius: 3,
              offset: Offset(0, 3),
              color: Color(0x10000000),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: getColors(context).onBackground.withOpacity(.7),
              size: wXD(22, context),
            ),
            Text(
              text,
              style: textFamily(
                context,
                color: getColors(context).onBackground.withOpacity(.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
