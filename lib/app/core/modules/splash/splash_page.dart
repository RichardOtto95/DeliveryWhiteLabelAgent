import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

import '../../../shared/utilities.dart';
import 'splash_store.dart';

class SplashPage extends StatefulWidget {
  final String title;
  const SplashPage({Key? key, this.title = 'SplashPage'}) : super(key: key);
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  final SplashStore store = Modular.get();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 4), () {
        if (FirebaseAuth.instance.currentUser != null) {
          Modular.to.pushReplacementNamed("/main");
        } else {
          Modular.to.pushReplacementNamed("/sign");
        }
      });
    });
    super.initState();
  }

  Future<File?> logo() async {
    final file = File("/assets/images/logotipo.png");
    if (await file.exists()) {
      return file;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColors(context).surface,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: wXD(100, context)),
        alignment: Alignment.center,
        child: Image.asset(
          brightness == Brightness.light
              ? "./assets/images/logo.png"
              : "./assets/images/logo_dark.png",
          fit: BoxFit.fitHeight,
          width: maxWidth(context),
        ),
      ),
    );
  }
}
