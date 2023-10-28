import 'package:delivery_agent_white_label/app/core/modules/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'splash_store.dart';

class SplashModule extends WidgetModule {
  SplashModule({Key? key}) : super(key: key);

  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SplashStore()),
  ];

  @override
  Widget get view => const SplashPage();
}
