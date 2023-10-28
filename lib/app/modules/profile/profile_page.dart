import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_agent_white_label/app/core/services/auth/auth_store.dart';
import 'package:delivery_agent_white_label/app/modules/main/main_store.dart';
import 'package:delivery_agent_white_label/app/modules/profile/widget/profile_app_bar.dart';
import 'package:delivery_agent_white_label/app/modules/profile/widget/profile_tile.dart';
import 'package:delivery_agent_white_label/app/shared/utilities.dart';

import 'package:delivery_agent_white_label/app/shared/widgets/confirm_popup.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_agent_white_label/app/modules/profile/profile_store.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String title;
  const ProfilePage({Key? key, this.title = 'ProfilePage'}) : super(key: key);
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final ProfileStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  final AuthStore authStore = Modular.get();
  late OverlayEntry overlayEntry;
  OverlayEntry? overlayCircular;

  @override
  initState() {
    store.setProfileEditFromDoc();
    super.initState();
  }

  OverlayEntry getOverlay() {
    return OverlayEntry(
      builder: (context) => ConfirmPopup(
        text: 'Tem certeza que deseja sair?',
        onConfirm: () async {
          overlayCircular =
              OverlayEntry(builder: (context) => LoadCircularOverlay());
          overlayEntry.remove();
          Overlay.of(context)!.insert(overlayCircular!);
          authStore.signout();
          overlayCircular!.remove();
          overlayCircular = null;
          mainStore.page = 0;
          User? _user = FirebaseAuth.instance.currentUser;

          if (!kIsWeb) {
            String? token;
            token = await FirebaseMessaging.instance.getToken();

            await FirebaseFirestore.instance
                .collection('agents')
                .doc(_user!.uid)
                .update({
              'token_id': FieldValue.arrayRemove([token]),
            });
          }
          // Get
          await Modular.to.pushReplacementNamed("/sign");
          // await Modular.to
          //     .pushNamedAndRemoveUntil("/", ModalRoute.withName('/sign'));
        },
        onCancel: () {
          overlayEntry.remove();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Column(
        children: [
          ProfileAppBar(),
          SizedBox(height: wXD(8, context)),
          ProfileTile(
            icon: Icons.star_border_rounded,
            title: 'Avaliações',
            onTap: () => Modular.to.pushNamed('/profile/ratings'),
            notifications: store.profileData['new_ratings'],
          ),
          ProfileTile(
            icon: Icons.email_outlined,
            title: 'Mensagens',
            onTap: () => Modular.to.pushNamed('/messages'),
            notifications: store.profileData['new_messages'],
          ),
          // ProfileTile(
          //   icon: Icons.account_balance_wallet_outlined,
          //   title: 'Financeiro',
          //   onTap: () => Modular.to.pushNamed('/payment'),
          // ),
          ProfileTile(
            icon: Icons.settings_outlined,
            title: 'Configurações',
            onTap: () => Modular.to.pushNamed('/profile/settings'),
          ),
          ProfileTile(
            icon: Icons.exit_to_app_outlined,
            title: 'Sair',
            onTap: () {
              overlayEntry = getOverlay();
              Overlay.of(context)?.insert(overlayEntry);
            },
          ),
        ],
      );
    });
  }
}
