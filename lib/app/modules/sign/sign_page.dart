import 'package:delivery_agent_white_label/app/core/services/auth/auth_store.dart';
import 'package:delivery_agent_white_label/app/modules/sign/sign_store.dart';
import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  final SignStore store = Modular.get();
  final AuthStore authStore = Modular.get();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  MaskTextInputFormatter maskFormatterPhone = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  String text = '';
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getOverlayStyleFromColor(getColors(context).background),
      child: Listener(
        onPointerDown: (a) => FocusScope.of(context).requestFocus(FocusNode()),
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
              body: PageView(
            children: [
              Observer(builder: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Image.asset(
                      brightness == Brightness.light
                          ? "./assets/images/logo.png"
                          : "./assets/images/logo_dark.png",
                      width: wXD(173, context),
                      height: wXD(153, context),
                    ),
                    const Spacer(),
                    Text(
                      'Entrar em sua conta',
                      textAlign: TextAlign.center,
                      style: textFamily(
                        context,
                        fontSize: 28,
                        color: getColors(context).onBackground,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Spacer(flex: 2),
                    Container(
                      width: wXD(235, context),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: getColors(context)
                                  .onBackground
                                  .withOpacity(.3)),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Telefone',
                            style: textFamily(
                              context,
                              fontSize: 20,
                              color: getColors(context)
                                  .onBackground
                                  .withOpacity(.5),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              inputFormatters: [maskFormatterPhone],
                              keyboardType: TextInputType.phone,
                              decoration:
                                  const InputDecoration.collapsed(hintText: ''),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              style: textFamily(context, fontSize: 20),
                              onChanged: (val) {
                                print(
                                    'val: ${maskFormatterPhone.unmaskText(val)}');
                                text = maskFormatterPhone.unmaskText(val);
                                store.setPhone(text);
                              },
                              validator: (value) {
                                if (value != null) {
                                  print(
                                      'value validator: $value ${value.length}');
                                }
                                if (value == null || value.isEmpty) {
                                  return 'Por favor preenchar o número de telefone';
                                }
                                if (value.length < 15) {
                                  return 'Preencha com todos os números';
                                }
                              },
                              onEditingComplete: () {
                                if (text.length == 11) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  store.phone ??= text;
                                  print(
                                      'store.start: ${store.resendingSMSSeconds}');
                                  if (store.resendingSMSSeconds != 0) {
                                    Fluttertoast.showToast(
                                      msg:
                                          "Aguarde ${store.resendingSMSSeconds} segundos para reenviar um novo código",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: getColors(context).error,
                                      textColor: getColors(context).onError,
                                      fontSize: 16.0,
                                    );
                                  } else {
                                    store.verifyNumber(context);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Digite o número por completo!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: getColors(context).error,
                                      textColor: getColors(context).onError,
                                      fontSize: 16.0);
                                }
                              },
                              controller: _phoneNumberController,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 1),
                    Observer(
                      builder: (context) => store.resendingSMSSeconds != 0
                          ? Text(
                              "Aguarde ${store.resendingSMSSeconds} segundos para reenviar um novo código",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: getColors(context).onBackground),
                            )
                          : Container(),
                    ),
                    const Spacer(flex: 1),
                    SideButton(
                      onTap: () {
                        if (text.length == 11) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          store.phone ??= text;
                          print('store.start: ${store.resendingSMSSeconds}');

                          if (store.resendingSMSSeconds != 0) {
                            showErrorToast(context,
                                "Aguarde ${store.resendingSMSSeconds} segundos para reenviar um novo código");
                          } else {
                            store.verifyNumber(context);
                          }
                        } else {
                          showErrorToast(
                              context, "Digite o número por completo!");
                        }
                      },
                      title: 'Entrar',
                      height: wXD(52, context),
                      width: wXD(142, context),
                    ),
                    const Spacer(),
                  ],
                );
              }),
            ],
          )),
        ),
      ),
    );
  }
}
