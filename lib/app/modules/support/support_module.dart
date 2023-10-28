import 'package:delivery_agent_white_label/app/modules/support/support_page.dart';

import 'package:delivery_agent_white_label/app/modules/support/support_store.dart';
import 'package:delivery_agent_white_label/app/modules/support/widgets/support_chat.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SupportModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SupportStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => SupportPage()),
  ];

  @override
  Widget get view => SupportPage();
}
