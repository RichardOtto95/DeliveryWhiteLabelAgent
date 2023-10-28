import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_agent_white_label/app/core/models/announcement_model.dart';
import 'package:delivery_agent_white_label/app/modules/advertisement/widgets/advertisement_app_bar.dart';
import 'package:delivery_agent_white_label/app/modules/advertisement/widgets/announcement.dart';
import 'package:delivery_agent_white_label/app/modules/main/main_store.dart';

import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/emtpy_state.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/floating_circle_button.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_agent_white_label/app/modules/advertisement/advertisement_store.dart';
import 'package:flutter/material.dart';

import 'widgets/delete_announcement.dart';

class AdvertisementPage extends StatefulWidget {
  @override
  AdvertisementPageState createState() => AdvertisementPageState();
}

class AdvertisementPageState extends State<AdvertisementPage> {
  final AdvertisementStore store = Modular.get();
  final MainStore mainStore = Modular.get();

  late OverlayEntry overlayEntry;
  ScrollController scrollController = ScrollController();
  @override
  initState() {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        mainStore.setVisibleNav(false);
        store.setAddAnnouncement(true);
      } else {
        mainStore.setVisibleNav(true);
        store.setAddAnnouncement(false);
      }
    });
    // mainStore.mainScrollController.addListener(() {
    //   if (mainStore.mainScrollController.position.userScrollDirection ==
    //       ScrollDirection.reverse) {
    //   } else if (mainStore.mainScrollController.position.userScrollDirection ==
    //       ScrollDirection.forward) {
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        onPointerDown: (a) {
          if (mainStore.globalOverlay != null) {
            mainStore.globalOverlay?.remove();
            mainStore.globalOverlay = null;
          }
        },
        onPointerUp: (a) {
          print('pointer up: ${scrollController.offset}');
          if (wXD(scrollController.offset, context) < -55) {
            store.callDelete(removeDelete: true);
          } else if ((wXD(scrollController.position.maxScrollExtent, context) +
                  wXD(80, context)) <
              wXD(scrollController.offset, context)) {
            store.callDelete(removeDelete: true);
            scrollController.animateTo(0,
                duration: Duration(milliseconds: 10), curve: Curves.ease);
          }
        },
        child: Observer(
          builder: (context) {
            return Stack(
              children: [
                Container(
                  height: maxHeight(context),
                  width: maxWidth(context),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('announcements')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CenterLoadCircular();
                        } else {
                          QuerySnapshot qs = snapshot.data!;
                          // qs.docs.forEach((adDoc) {});
                          WidgetsBinding.instance.addTimingsCallback((_) {
                            store.charging = store.setAnnouncementValues(qs);
                          });
                          return Observer(
                            builder: (context) {
                              switch (store.announcementStatusSelected) {
                                case 'active':
                                  return store.charging
                                      ? CenterLoadCircular()
                                      : store.activeAds.isEmpty
                                          ? EmptyState(
                                              title: 'Sem anúncios ativos')
                                          : Column(
                                              children: <Widget>[
                                                SizedBox(
                                                    height: wXD(123, context)),
                                                ...store.activeAds.map(
                                                  (announcement) =>
                                                      Announcement(
                                                    ad: announcement,
                                                    image:
                                                        'https://t2.tudocdn.net/518979?w=660&h=643',
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: wXD(120, context))
                                              ],
                                            );
                                case 'pending':
                                  return store.charging
                                      ? CenterLoadCircular()
                                      : store.pendingAds.isEmpty
                                          ? EmptyState(
                                              title: 'Sem anúncios pendentes')
                                          : Column(
                                              children: <Widget>[
                                                SizedBox(
                                                    height: wXD(123, context)),
                                                ...store.pendingAds.map(
                                                  (announcement) =>
                                                      Announcement(
                                                    ad: AnnouncementModel(
                                                      id: announcement.id,
                                                      title: announcement.title,
                                                      price: announcement.price,
                                                      paused:
                                                          announcement.paused,
                                                      highlighted: announcement
                                                          .highlighted,
                                                      description: announcement
                                                          .description,
                                                    ),
                                                    image:
                                                        'https://t2.tudocdn.net/518979?w=660&h=643',
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: wXD(120, context))
                                              ],
                                            );
                                case 'expired':
                                  return store.charging
                                      ? CenterLoadCircular()
                                      : store.expiredAds.isEmpty
                                          ? EmptyState(
                                              title: 'Sem anúncios expirados')
                                          : Column(
                                              children: <Widget>[
                                                SizedBox(
                                                    height: wXD(123, context)),
                                                ...store.expiredAds.map(
                                                  (announcement) =>
                                                      Announcement(
                                                    ad: AnnouncementModel(
                                                      id: announcement.id,
                                                      title: announcement.title,
                                                      price: announcement.price,
                                                      paused:
                                                          announcement.paused,
                                                      highlighted: announcement
                                                          .highlighted,
                                                      description: announcement
                                                          .description,
                                                    ),
                                                    image:
                                                        'https://t2.tudocdn.net/518979?w=660&h=643',
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: wXD(120, context))
                                              ],
                                            );
                                default:
                                  return Text('Is wroooooooong');
                              }
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
                AdvertisementAppBar(),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 400),
                  curve: Curves.ease,
                  bottom: wXD(127, context),
                  right: store.addAnnouncement
                      ? wXD(17, context)
                      : wXD(-56, context),
                  child: FloatingCircleButton(
                    onTap: () => Modular.to
                        .pushNamed('/advertisement/create-announcement'),
                    size: wXD(56, context),
                    child: Icon(
                      Icons.add,
                      size: wXD(30, context),
                      color: getColors(context).primary,
                    ),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: store.delete ? 2 : 0,
                      sigmaY: store.delete ? 2 : 0),
                  child: AnimatedOpacity(
                    opacity: store.delete ? .6 : 0,
                    duration: Duration(seconds: 1),
                    child: GestureDetector(
                      onTap: () => store.callDelete(removeDelete: true),
                      child: Container(
                        height: store.delete ? maxHeight(context) : 0,
                        width: store.delete ? maxWidth(context) : 0,
                        color: getColors(context).onBackground,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  top: store.delete ? 0 : maxHeight(context),
                  duration: Duration(seconds: 1),
                  curve: Curves.ease,
                  child: DeleteAnnouncement(
                    scrollController: scrollController,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
