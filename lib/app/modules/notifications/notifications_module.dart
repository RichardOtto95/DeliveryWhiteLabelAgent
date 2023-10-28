import 'package:delivery_agent_white_label/app/modules/notifications/notifications_Page.dart';
import 'package:delivery_agent_white_label/app/modules/notifications/notifications_store.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class NotificationsModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => NotificationsStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => NotificationsPage()),
  ];

  @override
  Widget get view => NotificationsPage();
}
