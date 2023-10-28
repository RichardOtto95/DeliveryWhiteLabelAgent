import 'package:delivery_agent_white_label/app/modules/address/address_module.dart';
import 'package:delivery_agent_white_label/app/modules/home/home_module.dart';
import 'package:delivery_agent_white_label/app/modules/home/widgets/current_position.dart';
import 'package:delivery_agent_white_label/app/modules/main/main_module.dart';
import 'package:delivery_agent_white_label/app/modules/main/main_store.dart';
import 'package:delivery_agent_white_label/app/modules/messages/messages_module.dart';
import 'package:delivery_agent_white_label/app/modules/orders/orders_module.dart';
import 'package:delivery_agent_white_label/app/modules/payment/payment_module.dart';
import 'package:delivery_agent_white_label/app/modules/profile/profile_module.dart';
import 'package:delivery_agent_white_label/app/modules/sign/sign_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../modules/sign/widgets/on_boarding.dart';
import '../../../modules/support/widgets/support_chat.dart';
import 'root_page.dart';
import 'root_store.dart';

class RootModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => RootStore()),
    Bind.lazySingleton((i) => MainStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute("/", child: (_, args) => RootPage()),
    ChildRoute('/on-boarding', child: (_, args) => OnBoarding()),
    ChildRoute('/root-page', child: (_, args) => RootPage()),
    ModuleRoute('/orders', module: OrdersModule()),
    ModuleRoute('/address', module: AddressModule()),
    ModuleRoute('/main', module: MainModule()),
    ModuleRoute('/sign', module: SignModule()),
    ModuleRoute('/profile', module: ProfileModule()),
    ModuleRoute('/messages', module: MessagesModule()),
    ModuleRoute('/payment', module: PaymentModule()),
    ModuleRoute('/home', module: HomeModule()),
    ChildRoute('/support-chat', child: (_, args) => SupportChat()),
    ChildRoute('/current-position',
        child: (_, args) => const CurrentPosition()),
  ];
}
