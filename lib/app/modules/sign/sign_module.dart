import 'package:delivery_agent_white_label/app/core/services/auth/auth_service.dart';
import 'package:delivery_agent_white_label/app/core/services/auth/auth_store.dart';
import 'package:delivery_agent_white_label/app/modules/main/main_module.dart';
import 'package:delivery_agent_white_label/app/modules/sign/sign_Page.dart';
import 'package:delivery_agent_white_label/app/modules/sign/sign_store.dart';
import 'package:delivery_agent_white_label/app/modules/sign/widgets/registration.dart';
import 'package:delivery_agent_white_label/app/modules/sign/widgets/verify.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/models/agent_model.dart';

class SignModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AuthStore()),
    Bind.lazySingleton((i) => Agent()),
    Bind.lazySingleton((i) => SignStore()),
    Bind.lazySingleton((i) => AuthService()),
    Bind.lazySingleton((i) => MainModule()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/sign', child: (_, args) => const SignPage()),
    ChildRoute('/verify', child: (_, args) => Verify(phoneNumber: args.data)),
    ChildRoute('/registration', child: (_, args) => const Registration()),
  ];

  @override
  Widget get view => SignPage();
}
