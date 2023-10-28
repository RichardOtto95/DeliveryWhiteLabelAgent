import 'dart:async';
import 'dart:ui';

import 'package:delivery_agent_white_label/app/core/models/address_model.dart';
import 'package:delivery_agent_white_label/app/core/models/order_model.dart';
import 'package:delivery_agent_white_label/app/modules/address/address_store.dart';
import 'package:delivery_agent_white_label/app/modules/main/main_store.dart';
import 'package:delivery_agent_white_label/app/modules/orders/orders_store.dart';
import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'widgets/address_edition.dart';
import 'widgets/confirm_popup.dart';

class Overlays {
  final BuildContext context;
  Overlays(this.context);

  final MainStore mainStore = Modular.get();

  void insertMissionConcludedOverlay() {
    double opacity = 0;
    double sigma = 0;
    double bottom = -172;
    bool backing = false;

    late OverlayEntry concludeOverlay;

    concludeOverlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          height: maxHeight(context),
          width: maxWidth(context),
          child: Material(
            color: Colors.transparent,
            child: StatefulBuilder(
              builder: (context, setScreen) {
                if (!backing) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setScreen(() {
                      opacity = .51;
                      sigma = 3;
                      bottom = 0;
                    });
                  });
                }
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    GestureDetector(
                      onTap: () {
                        backing = true;
                        setScreen(() {
                          opacity = 0;
                          sigma = 0;
                          bottom = -172;
                        });
                        Future.delayed(
                          const Duration(milliseconds: 400),
                          () {
                            concludeOverlay.remove();
                            mainStore.missionCompleted = false;
                            mainStore.priceRateDelivery = 0;
                          },
                        );
                      },
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            getColors(context).shadow,
                            BlendMode.color,
                          ),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.ease,
                            opacity: opacity,
                            child: Container(
                              color: getColors(context).shadow,
                              height: maxHeight(context),
                              width: maxWidth(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      bottom: bottom,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.ease,
                      child: Container(
                        height: wXD(172, context),
                        width: maxWidth(context),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(3)),
                          color: getColors(context).onSurface,
                        ),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: wXD(75, context)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Missão concluída",
                                    style: textFamily(
                                      context,
                                      fontSize: 21,
                                      color: getColors(context).primary,
                                    ),
                                  ),
                                  SizedBox(height: wXD(13, context)),
                                  Text(
                                    "Missão no valor de R\$ 50,00\nfinalizada com sucesso.",
                                    style: textFamily(
                                      context,
                                      fontSize: 15,
                                      color: getColors(context)
                                          .onBackground
                                          .withOpacity(.5),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: wXD(20, context),
                              right: wXD(-24, context),
                              child: SvgPicture.asset(
                                "./assets/svg/hand_phone.svg",
                                height: wXD(108, context),
                              ),
                            ),
                            Positioned(
                              top: wXD(19, context),
                              left: wXD(26, context),
                              child: InkWell(
                                onTap: () {
                                  backing = true;
                                  setScreen(() {
                                    opacity = 0;
                                    sigma = 0;
                                    bottom = -172;
                                  });
                                  Future.delayed(
                                    Duration(milliseconds: 400),
                                    () {
                                      concludeOverlay.remove();
                                      mainStore.missionCompleted = false;
                                      mainStore.priceRateDelivery = 0;
                                    },
                                  );
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  size: wXD(30, context),
                                  color: getColors(context)
                                      .onBackground
                                      .withOpacity(.7),
                                ),
                              ),
                            ),
                            Observer(
                              builder: (context) {
                                if (mainStore.removeOverlay) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((timeStamp) {
                                    backing = true;
                                    setScreen(() {
                                      opacity = 0;
                                      sigma = 0;
                                      bottom = -172;
                                    });
                                    Future.delayed(
                                      Duration(milliseconds: 400),
                                      () {
                                        concludeOverlay.remove();
                                        mainStore.missionCompleted = false;
                                        mainStore.priceRateDelivery = 0;
                                      },
                                    );
                                    mainStore.removeOverlay = false;
                                  });
                                }
                                return Container();
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
    Overlay.of(context)!.insert(concludeOverlay);
  }

  getTokenOverlay(Order orderModel, BuildContext screenContext) {
    final OrdersStore ordersStore = Modular.get();
    final _formKey = GlobalKey<FormState>();

    String token = "";
    mainStore.setVisibleNav(false);
    mainStore.globalOverlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          child: Stack(
            alignment: Alignment.center,
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: GestureDetector(
                  onTap: () {
                    mainStore.globalOverlay!.remove();
                    mainStore.globalOverlay = null;
                    mainStore.setVisibleNav(true);
                  },
                  child: Container(
                    height: maxHeight(context),
                    width: maxWidth(context),
                    color: getColors(context).shadow,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              Material(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(3),
                  topRight: Radius.circular(3),
                ),
                color: getColors(context).surface,
                child: Container(
                  height: wXD(180, context),
                  width: wXD(327, context),
                  padding: EdgeInsets.all(wXD(24, context)),
                  decoration: BoxDecoration(
                    color: getColors(context).surface,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(3),
                      topRight: Radius.circular(3),
                    ),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 18, color: getColors(context).shadow)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Preencha com o token do pedido fornecido pelo cliente!",
                        style: textFamily(context, fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      Form(
                        key: _formKey,
                        child: SizedBox(
                          // width: wXD(80, context),
                          child: TextFormField(
                            onChanged: (val) => token = val,
                            style: textFamily(
                              context,
                              fontSize: 18,
                              color: getColors(context).onBackground,
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textAlign: TextAlign.center,
                            inputFormatters: [UpperCaseTextFormatter()],
                            decoration: InputDecoration.collapsed(
                                hintText: "Token",
                                hintStyle: textFamily(
                                  context,
                                  fontSize: 18,
                                  color: getColors(context)
                                      .onSurface
                                      .withOpacity(.5),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: getColors(context).primary,
                                    width: wXD(2, context),
                                  ),
                                ),
                                fillColor: getColors(context).primary,
                                focusColor:
                                    getColors(context).primary.withOpacity(.7)),
                            cursorColor: getColors(context).primary,
                            validator: (value) {
                              if (value == null || value == "") {
                                return "Campo obrigatório";
                              }
                              if (value.length != 6) {
                                return "6 dígitos necessários";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const Spacer(),
                      Center(
                        child: BlackButton(
                          width: wXD(100, context),
                          text: 'Confirmar',
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              ordersStore.concludeOrder(screenContext, token);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    Overlay.of(context)!.insert(mainStore.globalOverlay!);
  }

  insertToastOverlay(String title, {Color? color}) {
    double bottom = -wXD(60, context);
    bool backing = false;

    Timer timer = Timer(Duration(), () {});

    mainStore.globalOverlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          child: StatefulBuilder(
            builder: (context, stateSet) {
              if (!backing) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  stateSet(() {
                    bottom = wXD(25, context);
                  });
                });
                Future.delayed(Duration(seconds: 3), () {
                  // WidgetsBinding.instance.addPostFrameCallback((_) {
                  stateSet(() {
                    backing = true;
                    timer.cancel();
                    bottom = -wXD(60, context);
                    Future.delayed(Duration(milliseconds: 300), () {
                      // mainStore.globalOverlay.remove();
                    });
                  });
                });
                // });
              }
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    height: maxHeight(context),
                    width: maxWidth(context),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.ease,
                    bottom: bottom,
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        height: wXD(53, context),
                        width: wXD(355, context),
                        padding:
                            EdgeInsets.symmetric(horizontal: wXD(22, context)),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: color ?? getColors(context).primary),
                          color: color,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                              "./assets/svg/check_white.svg",
                              height: wXD(20, context),
                              width: wXD(20, context),
                            ),
                            SizedBox(
                              width: wXD(261, context),
                              child: Text(
                                title,
                                style: textFamily(
                                  context,
                                  fontSize: 14,
                                  color: getColors(context).onSurface,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );

    Overlay.of(context)!.insert(mainStore.globalOverlay!);
  }

  insertAddAddress({
    bool homeRoot = false,
    bool editing = false,
    Address? model,
  }) {
    final AddressStore addressStore = Modular.get();

    double opacity = 0;
    double bottom = -maxHeight(context);

    addressStore.editAddressOverlay = OverlayEntry(
      builder: (overlayContext) {
        return Positioned(
          height: maxHeight(context),
          width: maxWidth(context),
          child: Observer(
            builder: (observerContext) {
              print(
                  'observer addressStore.addressOverlay: ${addressStore.addressOverlay}');
              if (addressStore.addressOverlay) {
                opacity = .51;
                bottom = 0;
              } else {
                bottom = -maxHeight(context);
                opacity = 0;
              }
              return Material(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        addressStore.addressOverlay = false;
                        Future.delayed(
                          Duration(milliseconds: 700),
                          () {
                            addressStore.editAddressOverlay!.remove();
                            addressStore.editAddressOverlay = null;
                          },
                        );
                      },
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.ease,
                        opacity: opacity,
                        child: Container(
                          color: getColors(context).shadow,
                          height: maxHeight(context),
                          width: maxWidth(context),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 700),
                      curve: Curves.ease,
                      bottom: bottom,
                      child: AddressEdition(
                        model: model ?? Address(),
                        editing: editing,
                        context: context,
                        homeRoot: homeRoot,
                        onBack: () async {
                          print("onBack");
                          addressStore.addressOverlay = false;
                          await Future.delayed(
                            Duration(milliseconds: 700),
                            () {
                              addressStore.editAddressOverlay!.remove();
                              addressStore.editAddressOverlay = null;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
    Overlay.of(context)!.insert(addressStore.editAddressOverlay!);
    addressStore.addressOverlay = true;
  }
}
