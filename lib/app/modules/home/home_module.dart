import 'package:delivery_agent_white_label/app/modules/home/home_Page.dart';
import 'package:delivery_agent_white_label/app/modules/home/home_store.dart';
import 'package:delivery_agent_white_label/app/modules/home/widgets/full_performance.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => HomeStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => HomePage()),
    ChildRoute('/full-performance', child: (_, args) => FullPerformance()),
  ];

  @override
  Widget get view => HomePage();
}
