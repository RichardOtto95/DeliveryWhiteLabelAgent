import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_agent_white_label/app/core/modules/root/root_store.dart';
// import 'package:delivery_agent_white_label/app/core/utils/auth_status_enum.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
import '../../../shared/utilities.dart';
// import '../../models/agent_model.dart';
import 'auth_service.dart';
part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  final AuthService _authService = Modular.get();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RootStore rootController = Modular.get();

  @observable
  String? userVerificationId;
  @observable
  int? userForceResendingToken;

  @action
  Future signinWithGoogle() async {
    await _authService.handleGoogleSignin();
  }

  // @action
  // Future linkAccountGoogle() async {
  //   await _authService.handleLinkAccountGoogle(user!);
  // }

  // @action
  // Future getUser() async {
  //   user = await _authService.handleGetUser();
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user!.uid)
  //       .get()
  //       .then((value) {
  //     // //print'dentro do then  ${value.data['firstName']}');
  //     agentBD = Agent.fromDoc(value);
  //     // user = ;
  //     // //print'depois do fromDoc  $user');

  //     return user;
  //   });
  // }

  // @action
  // Future signup(Agent agent) async {
  //   agent = await _authService.handleSignup(agent);
  // }

  // @action
  // Future siginEmail(String email, String password) async {
  //   user = await _authService.handleEmailSignin(email, password);
  // }

  @action
  Future signout() async {
    // setUser(null);
    return _authService.handleSetSignout();
  }

  @action
  Future sentSMS(String userPhone) async {
    return _authService.verifyNumber(userPhone);
  }

  @action
  Future verifyNumber(String userPhone,
      {required Function removeLoad, required Function timerInit}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: userPhone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) async {
        print('verificationCompleted%%%%%%%%%%%%%%%%%');
        try {
          final User _user =
              (await _auth.signInWithCredential(authCredential)).user!;

          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection("agents")
              .doc(_user.uid)
              .get();

          print('userDoc.exists: ${userDoc.exists} %%%%%%%%%%%%%%%%%');

          if (userDoc.exists) {
            String? tokenString = await FirebaseMessaging.instance.getToken();
            await userDoc.reference.update({
              'token_id': [tokenString]
            });
          } else {
            await _authService.handleSignup();
          }
          Modular.to.pushReplacementNamed('/main');
        } catch (e) {
          if (e.toString() ==
              '[firebase_auth/session-expired] The sms code has expired. Please re-send the verification code to try again.') {
            Fluttertoast.showToast(
                msg: "Sessão expirada!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
        removeLoad();
      },
      verificationFailed: (FirebaseAuthException authException) {
        print(
            '%%%%%%%%%%%%%%%%%%%%% verification failed %%%%%%%%%%%%%%%%%%%%%');
        print(authException.message);
        print(authException.code);
        removeLoad();

        showToast(authException.code);
      },
      codeSent: (String verificationId, int? forceResendingToken) async {
        print("verificationId: $verificationId");
        userVerificationId = verificationId;
        userForceResendingToken = forceResendingToken;
        timerInit();
        removeLoad();
        await Modular.to.pushNamed('/sign/verify', arguments: userPhone);
      },
      codeAutoRetrievalTimeout: (String verificationId) async {
        print("codeAutoRetrievalTimeout ID: $verificationId");
      },
    );
  }

  @action
  handleSmsSignin(String smsCode) async {
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: userVerificationId!, smsCode: smsCode);
    try {
      final User _user = (await _auth.signInWithCredential(credential)).user!;

      return _user;
    } on FirebaseAuthException catch (e) {
      print('%%%%%%%%% error: ${e.code} %%%%%%%%%%%');
      showErrorToast(context, 'error: ${e.code}');
      if (e.code == 'invalid-verification-code') {
        showErrorToast(context, "Código inválido!");
      }
      if (e.toString() ==
          '[firebase_auth/session-expired] The sms code has expired. Please re-send the verification code to try again.') {
        Fluttertoast.showToast(
            msg: "Sessão expirada!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  @action
  void resendingSMS(String userPhone,
      {required Function removeLoadOverlay, required Function timerInit}) {
    _auth.verifyPhoneNumber(
      forceResendingToken: userForceResendingToken,
      phoneNumber: userPhone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) async {
        try {
          final User _user =
              (await _auth.signInWithCredential(authCredential)).user!;

          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection("agents")
              .doc(_user.uid)
              .get();

          if (userDoc.exists) {
            String? tokenString = await FirebaseMessaging.instance.getToken();
            print('tokenId: $tokenString');

            await userDoc.reference.update({
              'token_id': [tokenString]
            });
          } else {
            await _authService.handleSignup();
          }
          Modular.to.pushReplacementNamed('/main');
        } catch (e) {
          if (e.toString() ==
              '[firebase_auth/session-expired] The sms code has expired. Please re-send the verification code to try again.') {
            Fluttertoast.showToast(
                msg: "Sessão expirada!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
        removeLoadOverlay();
      },
      verificationFailed: (FirebaseAuthException authException) {
        print(
            '%%%%%%%%%%%%%%%%%%%%% verification failed %%%%%%%%%%%%%%%%%%%%%');
        print(authException.message);
        print(authException.code);
        showToast(authException.code);
        removeLoadOverlay();
      },
      codeSent: (String verificationId, int? forceResendingToken) async {
        print("verificationId: $verificationId");
        userVerificationId = verificationId;
        userForceResendingToken = forceResendingToken;
        timerInit();
        removeLoadOverlay();
      },
      codeAutoRetrievalTimeout: (String verificationId) async {
        print("codeAutoRetrievalTimeout ID: $verificationId");
      },
    );
  }
}
