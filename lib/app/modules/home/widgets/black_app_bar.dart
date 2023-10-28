import 'package:delivery_agent_white_label/app/modules/main/main_store.dart';

import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BlackAppBar extends StatelessWidget {
  final MainStore mainStore = Modular.get();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getOverlayStyleFromColor(getColors(context).primary),
      child: Observer(builder: (context) {
        return GestureDetector(
          onTap: () {
            if (mainStore.agentMap["online"]) {
              Modular.to.pushNamed("/current-position");
            }
          },
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: maxWidth(context),
                height:
                    MediaQuery.of(context).viewPadding.top + wXD(50, context),
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewPadding.top),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(3)),
                  color: getColors(context).primary,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      color: Color(0x30000000),
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.bottomCenter,
                child: Observer(builder: (context) {
                  return Container(
                    width: wXD(270, context),
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: getColors(context).onPrimary,
                          ),
                          SizedBox(width: wXD(4, context)),
                          // TextButton(
                          //   onPressed: () async => await Modular.to
                          //       .pushNamed('/address', arguments: false),
                          //   child: Text(snapshot.data!,
                          //       maxLines: 1,
                          //       style:
                          //           TextStyle(color: getColors(context).onSurface, fontSize: 12)),
                          // ),
                          Text(
                            mainStore.addressFormatted,
                            maxLines: 1,
                            style: TextStyle(
                                color: getColors(context).onPrimary,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Future<String> getAddress() async {
  //   DocumentSnapshot _user = await FirebaseFirestore.instance
  //       .collection("agents")
  //       .doc(mainStore.authStore.user!.uid)
  //       .get();
  //   if (_user.get("main_address") == null) {
  //     Modular.to.pushNamed("/address", arguments: false);
  //     return "Sem endereço cadastrado";
  //   }
  //   DocumentSnapshot address = await _user.reference
  //       .collection("addresses")
  //       .doc(_user.get("main_address"))
  //       .get();
  //   return address.get("formated_address");
  // }
}
