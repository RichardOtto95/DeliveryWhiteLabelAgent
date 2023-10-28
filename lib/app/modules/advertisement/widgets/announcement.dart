import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_agent_white_label/app/core/models/announcement_model.dart';
import 'package:delivery_agent_white_label/app/modules/advertisement/advertisement_store.dart';
import 'package:delivery_agent_white_label/app/modules/main/main_store.dart';

import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/confirm_popup.dart';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class Announcement extends StatefulWidget {
  final AnnouncementModel ad;
  final String image;
  Announcement({
    Key? key,
    required this.ad,
    required this.image,
  }) : super(key: key);

  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  final MainStore mainStore = Modular.get();
  final AdvertisementStore store = Modular.get();

  OverlayEntry? confirmPauseOverlay;

  LayerLink _layerLink = LayerLink();

  OverlayEntry getOverlayEntry() {
    // print("announcement Model: ${AnnouncementModel().toJson(widget.ad)}");
    return OverlayEntry(
      builder: (context) => Positioned(
        height: wXD(140, context),
        width: wXD(130, context),
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(wXD(-115, context), wXD(21, context)),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.only(left: wXD(12, context)),
              height: wXD(140, context),
              width: wXD(130, context),
              decoration: BoxDecoration(
                color: getColors(context).onSurface,
                borderRadius: BorderRadius.all(Radius.circular(3)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    offset: Offset.zero,
                    color: Color(0x30000000),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        mainStore.globalOverlay!.remove();
                        mainStore.globalOverlay = null;
                        mainStore.setAnnouncementId(widget.ad.id);
                        await Modular.to.pushNamed('/product');
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.visibility,
                              size: wXD(18, context),
                              color: getColors(context).primary,
                            ),
                            Text(
                              '  Visualizar',
                              style: textFamily(
                                context,
                                color: getColors(context).primary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        store.setAdEdit(widget.ad);
                        store.setEditingAd(true);
                        mainStore.globalOverlay!.remove();
                        mainStore.globalOverlay = null;
                        await Modular.to
                            .pushNamed('/advertisement/create-announcement');
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: wXD(18, context),
                              color: getColors(context).primary,
                            ),
                            Text(
                              '  Editar',
                              style: textFamily(
                                context,
                                color: getColors(context).primary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        confirmPauseOverlay = OverlayEntry(
                          builder: (context) => ConfirmPopup(
                            height: wXD(140, context),
                            text:
                                'Tem certeza que deseja pausar esta publicação?',
                            onConfirm: () async {
                              await store.pauseAnnouncement(
                                  adsId: widget.ad.id,
                                  pause: !widget.ad.paused,
                                  context: context);
                              confirmPauseOverlay!.remove();
                              confirmPauseOverlay = null;
                              mainStore.globalOverlay!.remove();
                              mainStore.globalOverlay = null;
                            },
                            onCancel: () {
                              confirmPauseOverlay!.remove();
                              confirmPauseOverlay = null;
                              mainStore.globalOverlay!.remove();
                              mainStore.globalOverlay = null;
                            },
                          ),
                        );
                        Overlay.of(context)!.insert(confirmPauseOverlay!);
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              widget.ad.paused
                                  ? Icons.play_arrow_rounded
                                  : Icons.pause,
                              size: wXD(18, context),
                              color: getColors(context).primary,
                            ),
                            Text(
                              widget.ad.paused ? 'Despausar' : '  Pausar',
                              style: textFamily(
                                context,
                                color: getColors(context).primary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        store.callDelete(ad: widget.ad);
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: wXD(18, context),
                              color: getColors(context).primary,
                            ),
                            Text(
                              '  Excluir',
                              style: textFamily(
                                context,
                                color: getColors(context).primary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            height: wXD(140, context),
            width: wXD(352, context),
            margin: EdgeInsets.only(bottom: wXD(12, context)),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffF1F1F1)),
              borderRadius: BorderRadius.all(Radius.circular(3)),
              color: getColors(context).onSurface,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  offset: Offset(0, 3),
                  color: Color(0x20000000),
                )
              ],
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () => Modular.to.pushNamed('/orders/order-details'),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.9)
                                    .withOpacity(.2)))),
                    padding: EdgeInsets.only(bottom: wXD(7, context)),
                    margin: EdgeInsets.fromLTRB(
                      wXD(19, context),
                      wXD(17, context),
                      wXD(6, context),
                      wXD(0, context),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          child: widget.image == ''
                              ? Image.asset(
                                  'assets/images/no-image-icon.png',
                                  height: wXD(65, context),
                                  width: wXD(62, context),
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  imageUrl: widget.image,
                                  height: wXD(65, context),
                                  width: wXD(62, context),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: wXD(8, context)),
                          width: wXD(248, context),
                          height: wXD(70, context),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // SizedBox(height: wXD(3, context)),
                              Text(
                                widget.ad.title,
                                style: textFamily(context,
                                    color: getColors(context).onBackground),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: wXD(3, context)),
                              Text(
                                widget.ad.description,
                                style: textFamily(context,
                                    color: getColors(context)
                                        .onBackground
                                        .withOpacity(.5)),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // SizedBox(height: wXD(3, context)),
                              const Spacer(),
                              Text(
                                'R\$${formatedCurrency(widget.ad.price)}',
                                style: textFamily(context,
                                    color: getColors(context).primary),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                widget.ad.paused
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pause,
                            size: wXD(30, context),
                            color: getColors(context).primary,
                          ),
                          Text(
                            '  Anúncio pausado',
                            style: textFamily(
                              context,
                              fontSize: 18,
                              color: getColors(context).primary,
                            ),
                          ),
                        ],
                      )
                    : widget.ad.highlighted
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                size: wXD(30, context),
                                color: getColors(context).primary,
                              ),
                              Text(
                                '  Anúncio destacado',
                                style: textFamily(
                                  context,
                                  fontSize: 18,
                                  color: getColors(context).primary,
                                ),
                              ),
                            ],
                          )
                        // Text(
                        //     'Anúncio destacado',
                        //     style: textFamily(context,
                        //       color: getColors(context).primary,
                        //       fontSize: 14,
                        //     ),
                        //     maxLines: 2,
                        //     overflow: TextOverflow.ellipsis,
                        //   )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(left: wXD(20, context)),
                                child: Text(
                                  'Destaque e venda mais rápido',
                                  style: textFamily(
                                    context,
                                    color: getColors(context)
                                        .onBackground
                                        .withOpacity(.9)
                                        .withOpacity(.7),
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  confirmPauseOverlay = OverlayEntry(
                                    builder: (context) => ConfirmPopup(
                                      height: wXD(140, context),
                                      text:
                                          'Tem certeza que deseja destacar esta publicação?',
                                      onConfirm: () async {
                                        await store.highlightAd(
                                            adsId: widget.ad.id,
                                            context: context);
                                        confirmPauseOverlay!.remove();
                                        confirmPauseOverlay = null;
                                      },
                                      onCancel: () {
                                        confirmPauseOverlay!.remove();
                                        confirmPauseOverlay = null;
                                      },
                                    ),
                                  );
                                  Overlay.of(context)!
                                      .insert(confirmPauseOverlay!);
                                },
                                child: Container(
                                  margin:
                                      EdgeInsets.only(right: wXD(6, context)),
                                  height: wXD(32, context),
                                  width: wXD(87, context),
                                  decoration: BoxDecoration(
                                    color: getColors(context).primary,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 3,
                                        offset: Offset(0, 3),
                                        color: Color(0x20000000),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Destacar',
                                    style: textFamily(
                                      context,
                                      fontSize: 12,
                                      color: getColors(context).onSurface,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                Spacer(),
              ],
            ),
          ),
          Positioned(
            top: wXD(12, context),
            right: wXD(6, context),
            child: GestureDetector(
              onTap: () {
                // print('menuOverlay.mounted: ${menuOverlay.mounted}');
                // if (menuOverlay.mounted) {
                //   menuOverlay.remove();
                // } else {
                print('gerOverlayEntry: ${getOverlayEntry()}');
                mainStore.setGlobalOverlay(getOverlayEntry(), context);
                // Overlay.of(context)?.insert(store.menuOverlay);
                // }
              },
              child: CompositedTransformTarget(
                link: _layerLink,
                child: Icon(
                  Icons.more_vert,
                  size: wXD(20, context),
                  color: getColors(context).primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
