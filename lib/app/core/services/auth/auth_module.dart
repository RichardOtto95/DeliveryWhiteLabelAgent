// import 'package:delivery_agent_white_label/app/core/services/auth/auth_Page.dart';
import 'package:delivery_agent_white_label/app/core/services/auth/auth_service.dart';
import 'package:delivery_agent_white_label/app/core/services/auth/auth_store.dart';
import 'package:delivery_agent_white_label/app/modules/sign/sign_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SignStore()),
    Bind.lazySingleton((i) => AuthStore()),
    Bind.lazySingleton((i) => AuthService()),
  ];

  @override
  final List<ModularRoute> routes = [
    // ChildRoute(Modular.initialRoute, child: (_, args) => AuthPage()),
  ];
}
