import 'package:delivery_agent_white_label/app/core/models/address_model.dart';
import 'package:delivery_agent_white_label/app/modules/address/address_store.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:place_picker/entities/location_result.dart';

import '../color_theme.dart';
import '../overlays.dart';
import '../utilities.dart';

class AddressEdition extends StatefulWidget {
  final bool homeRoot;
  final Future<void> Function() onBack;
  final bool editing;
  final BuildContext context;
  final Address model;

  AddressEdition(
      {Key? key,
      required this.homeRoot,
      required this.onBack,
      required this.context,
      required this.editing,
      required this.model})
      : super(key: key);

  @override
  _AddressEditionState createState() => _AddressEditionState();
}

class _AddressEditionState extends State<AddressEdition> {
  final AddressStore addressStore = Modular.get();
  final _formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  double height = 0;
  Map<String, dynamic> addressMap = {};
  FocusNode numberFocus = FocusNode();
  FocusNode complementFocus = FocusNode();
  late Address address;

  @override
  void initState() {
    print('widget.editing: ${widget.editing}');
    address = widget.model;
    addressMap = !widget.editing
        ? {
            "address_name": null,
            "cep": addressStore.locationResult!.postalCode!.replaceAll("-", ""),
            "city": addressStore.locationResult!.administrativeAreaLevel2!.name,
            "state":
                addressStore.locationResult!.administrativeAreaLevel1!.name,
            "neighborhood": null,
            "formated_address": addressStore.locationResult!.formattedAddress,
            "address_number": null,
            "address_complement": null,
            "main": true,
            "latitude": addressStore.locationResult!.latLng!.latitude,
            "longitude": addressStore.locationResult!.latLng!.longitude,
            "status": "PENDING",
            "without_complement": false,
          }
        : widget.model.toJson();

    print('addressMap: $addressMap');
    // print("addressMap: $addressMap");

    numberFocus.addListener(() async {
      if (numberFocus.hasFocus) {
        height = 100;
        setState(() {});
        print("height = 100");

        await Future.delayed(Duration(milliseconds: 300));
        print("Animating");
        await scrollController.animateTo(
          scrollController.position.maxScrollExtent + 100,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } else {
        setState(() {
          height = 0;
        });
      }
    });

    complementFocus.addListener(() async {
      if (complementFocus.hasFocus) {
        height = 100;
        setState(() {});
        print("height = 100");

        await Future.delayed(Duration(milliseconds: 300));
        print("Animating");
        await scrollController.animateTo(
          scrollController.position.maxScrollExtent + 100,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } else {
        setState(() {
          height = 0;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    numberFocus.removeListener(() {});
    numberFocus.dispose();
    complementFocus.removeListener(() {});
    complementFocus.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // LocationResult _loc = addressStore.locationResult!;
    // print(
    //     "_loc.administrativeAreaLevel1: ${_loc.administrativeAreaLevel1 != null ? _loc.administrativeAreaLevel1!.name : null}");
    // print(
    //     "_loc.administrativeAreaLevel2: ${_loc.administrativeAreaLevel2 != null ? _loc.administrativeAreaLevel2!.name : null}");
    // print("_loc.city: ${_loc.city != null ? _loc.city!.name : null}");
    // print("_loc.country: ${_loc.country != null ? _loc.country!.name : null}");
    // print("_loc.formattedAddress: ${_loc.formattedAddress}");
    // print("_loc.latLng: ${_loc.latLng}");
    // print("_loc.locality: ${_loc.locality}");
    // print("_loc.name: ${_loc.name}");
    // print("_loc.placeId: ${_loc.placeId}");
    // print("_loc.postalCode: ${_loc.postalCode}");
    // print(
    //     "_loc.subLocalityLevel1: ${_loc.subLocalityLevel1 != null ? _loc.subLocalityLevel1!.name : null}");
    // print(
    //     "_loc.subLocalityLevel2: ${_loc.subLocalityLevel2 != null ? _loc.subLocalityLevel2!.name : null}");
    // print("_loc.toString(): ${_loc.toString()}");
    return Listener(
      onPointerDown: (event) =>
          FocusScope.of(context).requestFocus(FocusNode()),
      child: Container(
        height: maxHeight(context),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              GestureDetector(
                onTap: widget.onBack,
                child: Container(
                  color: Colors.transparent,
                  height: wXD(141, context),
                  width: maxWidth(context),
                ),
              ),
              Container(
                // height: hXD(526, context),
                width: maxWidth(context),
                padding: EdgeInsets.only(top: wXD(24, context)),
                decoration: BoxDecoration(
                  color: getColors(context).onSurface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: maxWidth(context),
                              alignment: Alignment.center,
                              child: Text(
                                'Conferir endereço',
                                style: textFamily(
                                  context,
                                  fontSize: 15,
                                  color: getColors(context).onSurface,
                                ),
                              ),
                            ),
                            Positioned(
                              right: wXD(26, context),
                              child: InkWell(
                                onTap: widget.onBack,
                                child: Icon(
                                  Icons.close,
                                  size: wXD(22, context),
                                  color: getColors(context).onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: wXD(21, context),
                            right: wXD(21, context),
                            top: wXD(28, context),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Esse é o endereço do local indicado no mapa.',
                                style: textFamily(
                                  context,
                                  fontSize: 14,
                                  color: getColors(context).onSurface,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Você pode editar o texto, se necessário.',
                                style: textFamily(context,
                                    fontSize: 14,
                                    color: getColors(context).onSurface,
                                    fontWeight: FontWeight.w400,
                                    height: 1.4),
                              ),
                            ],
                          ),
                        ),
                        AddressField(
                          'Nome',
                          initialValue: addressMap["address_name"],
                          onChanged: (val) => addressMap['address_name'] = val,
                        ),
                        AddressField(
                          'CEP',
                          initialValue: addressMap["cep"],
                          inputFormatters: [Masks().cepMask],
                          onChanged: (val) => addressMap['cep'] = val,
                          enabled: false,
                        ),
                        AddressField(
                          'Cidade',
                          enabled: false,
                          initialValue: addressMap["city"],
                        ),
                        AddressField(
                          'Estado',
                          enabled: false,
                          initialValue: addressMap["state"],
                        ),
                        AddressField(
                          'Bairro',
                          onChanged: (val) => addressMap['neighborhood'] = val,
                          initialValue: addressMap["neighborhood"],
                        ),
                        AddressField(
                          'Endereço',
                          initialValue: addressMap["formated_address"],
                          onChanged: (val) =>
                              addressMap['formated_address'] = val,
                        ),
                        Row(
                          children: [
                            SizedBox(width: wXD(18, context)),
                            AddressField(
                              'Número',
                              textInputType: TextInputType.number,
                              width: wXD(120, context),
                              initialValue: addressMap["address_number"],
                              onChanged: (val) =>
                                  addressMap['address_number'] = val,
                              focus: numberFocus,
                            ),
                            SizedBox(width: wXD(12, context)),
                            AddressField(
                              'Complemento',
                              width: wXD(207, context),
                              onChanged: (val) =>
                                  addressMap['address_complement'] = val,
                              initialValue: addressMap["address_complement"],
                              validate: !addressMap['without_complement'],
                              focus: complementFocus,
                            ),
                          ],
                        ),
                        Container(
                          width: maxWidth(context),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                            top: wXD(23, context),
                            left: wXD(15, context),
                            bottom: wXD(38, context),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // withoutComplement = !withoutComplement;
                                        addressMap['without_complement'] =
                                            !addressMap['without_complement'];
                                      });
                                    },
                                    child: Container(
                                      height: wXD(20, context),
                                      width: wXD(20, context),
                                      margin: EdgeInsets.only(
                                          right: wXD(3, context)),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        border: Border.all(
                                          color: getColors(context).onSurface,
                                        ),
                                        color: addressMap['without_complement']
                                            ? getColors(context).primary
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Não tenho complemento',
                                    style: textFamily(
                                      context,
                                      fontSize: 13,
                                      color: getColors(context).onSurface,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: wXD(12, context)),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => setState(() =>
                                        addressMap["main"] =
                                            !addressMap["main"]),
                                    child: Container(
                                      height: wXD(20, context),
                                      width: wXD(20, context),
                                      margin: EdgeInsets.only(
                                          right: wXD(3, context)),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        border: Border.all(
                                          color: getColors(context).onSurface,
                                        ),
                                        color: addressMap["main"]
                                            ? getColors(context).primary
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Definir como principal',
                                    style: textFamily(
                                      context,
                                      fontSize: 13,
                                      color: getColors(context).onSurface,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SideButton(
                          onTap: () async {
                            // addressStore.setCheckLocation(false);
                            // print("homeRoot: $homeRoot");
                            if (_formKey.currentState!.validate()) {
                              // if (widget.homeRoot) {
                              await addressStore.newAddress(
                                  addressMap, context, widget.editing);
                              widget.onBack();
                              //   } else {
                              //     await addressStore.newAddress(
                              //         addressMap, context, widget.editing);
                              //     widget.onBack();
                              //   }
                            }
                          },
                          title: 'Salvar',
                          width: wXD(142, context),
                          height: wXD(52, context),
                        ),
                        SizedBox(height: wXD(16, context)),
                        TextButton(
                          onPressed: () async {
                            await widget.onBack();
                            addressStore.locationResult = await Modular.to
                                .pushNamed("/address/place-picker");
                            if (addressStore.locationResult !=
                                null) if (addressStore
                                    .locationResult!.postalCode !=
                                null) {
                              address.cep = addressStore
                                  .locationResult!.postalCode!
                                  .replaceAll("-", "");
                            }
                            if (addressStore
                                    .locationResult!.administrativeAreaLevel2 !=
                                null) {
                              address.city = addressStore.locationResult!
                                  .administrativeAreaLevel2!.name;
                            }
                            if (addressStore
                                    .locationResult!.administrativeAreaLevel1 !=
                                null) {
                              address.state = addressStore.locationResult!
                                  .administrativeAreaLevel1!.name;
                            }
                            if (addressStore.locationResult!.formattedAddress !=
                                null) {
                              address.formatedAddress =
                                  addressStore.locationResult!.formattedAddress;
                            }
                            address.main = addressMap["main"];
                            address.latitude =
                                addressStore.locationResult!.latLng!.latitude;
                            address.longitude =
                                addressStore.locationResult!.latLng!.longitude;

                            Overlays(widget.context).insertAddAddress(
                              editing: widget.editing,
                              model: widget.model,
                            );
                          },
                          child: Text(
                            'Alterar local no mapa',
                            style: textFamily(context,
                                fontSize: 14,
                                color: getColors(context).primary),
                          ),
                        ),
                        SizedBox(height: wXD(17, context)),
                        Container(height: wXD(height, context)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AddressField extends StatelessWidget {
  final double? width;
  final String title;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final bool validate;
  final bool enabled;
  final void Function(String)? onChanged;
  final FocusNode? focus;
  final TextInputType? textInputType;
  AddressField(
    this.title, {
    this.width,
    this.initialValue,
    this.inputFormatters,
    this.validate = true,
    this.onChanged,
    this.enabled = true,
    this.focus,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: wXD(52, context),
      width: width ?? wXD(339, context),
      margin: EdgeInsets.only(top: wXD(29, context)),
      padding: EdgeInsets.fromLTRB(
        wXD(8, context),
        wXD(6, context),
        wXD(8, context),
        wXD(6, context),
      ),
      decoration: BoxDecoration(
        border:
            Border.all(color: getColors(context).onBackground.withOpacity(.11)),
        borderRadius: BorderRadius.all(Radius.circular(3)),
        color: getColors(context).onSurface,
        boxShadow: [
          BoxShadow(
            blurRadius: wXD(7, context),
            offset: Offset(0, wXD(10, context)),
            color: getColors(context).shadow,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textFamily(
              context,
              fontSize: 15,
              color: getColors(context).onSurface,
              // fontWeight: FontWeight.w400,
              // height: 1.4
            ),
          ),
          Container(
              width: wXD(315, context),
              child: TextFormField(
                keyboardType: textInputType,
                focusNode: focus,
                enabled: enabled,
                onChanged: onChanged,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) {
                  if (validate) {
                    if (val != null && val.isEmpty) {
                      return "Preencha o campo corretamente";
                    }
                  }
                },
                initialValue: initialValue,
                inputFormatters: inputFormatters,
                decoration: InputDecoration.collapsed(hintText: ''),
              ))
        ],
      ),
    );
  }
}
