import 'package:delivery_agent_white_label/app/modules/address/address_Page.dart';
import 'package:delivery_agent_white_label/app/modules/address/address_store.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:place_picker/place_picker.dart';

import 'widgets/address_map.dart';

class AddressModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AddressStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => AddressPage(signRoot: args.data)),
    ChildRoute('/address-map', child: (_, args) => AddressMap()),
    ChildRoute('/place-picker',
        child: (_, args) =>
            PlacePicker("AIzaSyBwPi2kg3SlJB9hDpuPJYYylf2cjWXYJFI")),
  ];

  @override
  Widget get view => AddressPage();
}
