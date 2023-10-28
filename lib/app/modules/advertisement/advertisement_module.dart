import 'package:delivery_agent_white_label/app/modules/advertisement/advertisement_Page.dart';
import 'package:delivery_agent_white_label/app/modules/advertisement/advertisement_store.dart';
import 'package:delivery_agent_white_label/app/modules/advertisement/widgets/announcement_confirm.dart';
import 'package:delivery_agent_white_label/app/modules/advertisement/widgets/choose_category.dart';
import 'package:delivery_agent_white_label/app/modules/advertisement/widgets/create_announcement.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'widgets/category.dart';

class AdvertisementModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AdvertisementStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => AdvertisementPage()),
    ChildRoute('/create-announcement',
        child: (_, args) => CreateAnnouncement()),
    ChildRoute('/announcement-confirm',
        child: (_, args) => AnnouncementConfirm(group: args.data)),
    ChildRoute('/choose-category', child: (_, args) => ChooseCategory()),
    ChildRoute('/category', child: (_, args) => Category()),
  ];

  @override
  Widget get view => AdvertisementPage();
}
