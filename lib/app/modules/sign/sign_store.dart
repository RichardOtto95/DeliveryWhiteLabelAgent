import 'package:delivery_agent_white_label/app/core/services/auth/auth_service_interface.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/load_circular_overlay.dart';
import 'package:delivery_agent_white_label/app/core/services/auth/auth_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'dart:async';
import 'package:universal_html/html.dart' as html;

import '../../shared/utilities.dart';
part 'sign_store.g.dart';

class SignStore = _SignStoreBase with _$SignStore;

abstract class _SignStoreBase with Store {
  final AuthStore authStore = Modular.get();
  AuthServiceInterface authService = Modular.get();
  @observable
  String? phone;
  @observable
  int resendingSMSSeconds = 0;
  @observable
  Timer? resendingSMSTimer;
  @observable
  ConfirmationResult? resultConfirm;
  @observable
  OverlayEntry? loadOverlay;

  @observable
  _SignStoreBase();

  @action
  void setPhone(_phone) => phone = _phone;

  @action
  verifyNumber(BuildContext context) async {
    loadOverlay =
        OverlayEntry(builder: (context) => const LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay!);
    print('##### phone $phone');
    String userPhone = '+55' + phone!;
    if (!kIsWeb) {
      await authStore.verifyNumber(userPhone, removeLoad: () {
        loadOverlay!.remove();
        loadOverlay = null;
      }, timerInit: () {
        resendingSMSSeconds = 60;
        resendingSMSTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          resendingSMSSeconds--;
          if (resendingSMSSeconds == 0) {
            timer.cancel();
          }
        });
      });
    } else {
      print("isWeb");
      final FirebaseAuth _auth = FirebaseAuth.instance;

      resultConfirm = await _auth.signInWithPhoneNumber(userPhone);

      final el =
          html.window.document.getElementById('__ff-recaptcha-container');
      if (el != null) {
        el.style.visibility = 'hidden';
      }

      print("resultCOnfirm: ${resultConfirm}");
      loadOverlay!.remove();
      // authStore.canBack = true;

      Modular.to.pushNamed('/sign/verify', arguments: userPhone);
    }
  }

  @action
  signinPhone(String _code, context) async {
    print('%%%%%%%% signinPhone: $_code %%%%%%%%');
    loadOverlay =
        OverlayEntry(builder: (context) => const LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay!);
    if (!kIsWeb) {
      await authStore.handleSmsSignin(_code).then((value) async {
        if (value != null) {
          DocumentSnapshot _user = await FirebaseFirestore.instance
              .collection('agents')
              .doc(value.uid)
              .get();

          if (_user.exists) {
            String? tokenString = await FirebaseMessaging.instance.getToken();
            print('tokenId: $tokenString');
            await _user.reference.update({
              'token_id': [tokenString]
            });
          } else {
            await authService.handleSignup();
          }
          Modular.to.pushReplacementNamed("/main");
        }
      });
    } else {
      if (_code.length != 6) {
        showToast("Digite o código corretamente");
        loadOverlay!.remove();
      } else {
        try {
          print("resultConfirm");
          await resultConfirm!.confirm(_code);
          Modular.to.pushNamed("/main/");
          loadOverlay!.remove();
        } on FirebaseAuthException catch (e) {
          print('Failed with error code: ${e.code}');
          switch (e.code) {
            case 'invalid-verification-code':
              loadOverlay!.remove();
              return showToast("Código inválido");
            case "too-many-requests":
              loadOverlay!.remove();
              return showToast(
                  "Número bloqueado por muitas tentativas de login");
            default:
              loadOverlay!.remove();
              print('Case of ${e.code} not defined');
          }
        }
      }
    }

    print("Fora do then");
    loadOverlay!.remove();
    loadOverlay = null;
  }

  @action
  void resendingSMS(context) {
    loadOverlay =
        OverlayEntry(builder: (context) => const LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay!);
    String userPhone = '+55' + phone!;
    print('userPhone: $userPhone');

    authStore.resendingSMS(
      userPhone,
      removeLoadOverlay: () {
        loadOverlay!.remove();
        loadOverlay = null;
      },
      timerInit: () {
        resendingSMSSeconds = 60;
        resendingSMSTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          resendingSMSSeconds--;
          if (resendingSMSSeconds == 0) {
            timer.cancel();
          }
        });
      },
    );
  }
}
