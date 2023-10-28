import 'dart:async';
import 'package:delivery_agent_white_label/app/core/services/auth/auth_store.dart';
import 'package:delivery_agent_white_label/app/modules/sign/sign_store.dart';
import 'package:delivery_agent_white_label/app/modules/sign/widgets/custom_pincode_textfield.dart';
import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Verify extends StatefulWidget {
  final String phoneNumber;
  const Verify({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final SignStore store = Modular.get();
  final AuthStore authStore = Modular.get();
  final TextEditingController _pinCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('onWillPo verify');
        if (store.loadOverlay != null) {
          if (store.loadOverlay!.mounted) {
            return false;
          }
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 6),
                Text(
                  'Insira o código enviado para o \n número ${Masks().fullNumberMask.maskText(widget.phoneNumber)}',
                  textAlign: TextAlign.center,
                  style: textFamily(context, fontSize: 14, height: 1.5),
                ),
                const Spacer(flex: 2),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: wXD(30, context)),
                  width: maxWidth(context),
                  child: CustomPinCodeTextField(controller: _pinCodeController),
                ),
                const Spacer(
                  flex: 2,
                ),
                // const Spacer(flex: 1),
                Observer(
                  builder: (context) => store.resendingSMSSeconds != 0
                      ? Text(
                          "Aguarde ${store.resendingSMSSeconds} segundos para reenviar um novo código",
                          style: textFamily(
                            context,
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: getColors(context).onBackground,
                          ),
                        )
                      : TextButton(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: getColors(context).primary,
                                      width: 2)),
                            ),
                            padding: EdgeInsets.only(bottom: wXD(3, context)),
                            child: Text(
                              'Reenviar o código',
                              style: textFamily(
                                context,
                                color: getColors(context).onBackground,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          onPressed: () {
                            store.resendingSMS(context);
                          },
                        ),
                ),

                const Spacer(flex: 2),
                SideButton(
                  onTap: () async {
                    print(
                        '_pinCodeController.text: ${_pinCodeController.text.isNotEmpty} - ${_pinCodeController.text.length}');
                    if (_pinCodeController.text.length == 6 &&
                        _pinCodeController.text.isNotEmpty) {
                      await store.signinPhone(
                        _pinCodeController.text,
                        context,
                      );
                    } else {
                      showErrorToast(context, "Código incompleto!");
                    }
                  },
                  title: 'Validar',
                  height: wXD(52, context),
                  width: wXD(142, context),
                ),
                const Spacer(),
              ],
            ),
            DefaultAppBar(
              'Código enviado',
              onPop: () {
                print('onWillPo verify');
                if (store.loadOverlay == null) {
                  Modular.to.pop();
                } else if (!store.loadOverlay!.mounted) {
                  Modular.to.pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // showToast(message, Color color) {
  //   Fluttertoast.showToast(
  //     msg: message,
  //     backgroundColor: color,
  //   );
  // }
}
