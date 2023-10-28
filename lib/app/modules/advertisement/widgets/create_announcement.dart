import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_agent_white_label/app/core/models/announcement_model.dart';
import 'package:delivery_agent_white_label/app/modules/advertisement/advertisement_store.dart';

import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/confirm_popup.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'announcement_details.dart';
import 'delete_photo_pop_up.dart';
import 'include_photos.dart';
import 'include_photos_pop_up.dart';
import 'search_type.dart';

class CreateAnnouncement extends StatefulWidget {
  CreateAnnouncement({Key? key}) : super(key: key);

  @override
  _CreateAnnouncementState createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {
  final AdvertisementStore store = Modular.get();

  final ScrollController scrollController = ScrollController();

  late OverlayEntry overlayEntry;

  final _formKey = GlobalKey<FormState>();

  OverlayEntry getOverlay() {
    return OverlayEntry(
      builder: (context) => ConfirmPopup(
        height: wXD(140, context),
        text: 'Tem certeza em cancelar? \nSeu anúncio será descartado!',
        onConfirm: () {
          Modular.to.pop();
          overlayEntry.remove();
          store.cleanVars();
        },
        onCancel: () {
          overlayEntry.remove();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('store.adEdit.images: ${store.adEdit.images}');
    return WillPopScope(
      onWillPop: () async {
        if (store.getProgress()) {
          return false;
        } else if (store.takePicture) {
          store.settakePicture(false);
        } else if (store.searchType) {
          store.setSearchType(false);
        } else if (store.deleteImage) {
          store.setDeleteImage(false);
        } else if (store.announcementTitle != '' ||
            store.announcementDescription != '' ||
            store.announcementCategory != '' ||
            store.announcementType != '' ||
            store.announcementIsNew != true ||
            store.announcementPrice != null ||
            store.announcementOption != '' ||
            store.images.isNotEmpty) {
          overlayEntry = getOverlay();
          Overlay.of(context)?.insert(overlayEntry);
        } else {
          store.setEditingAd(false);
          store.setAdEdit(AnnouncementModel());
          store.cleanVars();
          return true;
        }
        return false;
      },
      child: Listener(
        onPointerDown: (a) {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        onPointerUp: (a) {
          if (wXD(scrollController.offset, context) < -55) {
            store.setSearchType(false);
          }
        },
        child: Scaffold(
          backgroundColor: getColors(context).background,
          body: Observer(builder: (context) {
            return Stack(
              children: [
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: wXD(90, context)),
                      Container(
                        width: maxWidth(context),
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          physics: PageScrollPhysics(),
                          padding:
                              EdgeInsets.symmetric(horizontal: wXD(6, context)),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...List.generate(
                                store.adEdit.images.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    // print('aaaaaaaaa');
                                    // print('after: ${store.deleteImage}');
                                    store.setImageSelected(index);
                                    store.setDeleteImage(true);
                                    // print('before: ${store.deleteImage}');
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      bottom: wXD(20, context),
                                      left: wXD(6, context),
                                      right: wXD(6, context),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3)),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                            color: Color(0x30000000))
                                      ],
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3)),
                                        child: CachedNetworkImage(
                                          imageUrl: store.adEdit.images[index],
                                          fit: BoxFit.cover,
                                          height: wXD(196, context),
                                          width: wXD(282, context),
                                        )),
                                  ),
                                ),
                              ),
                              ...List.generate(
                                store.images.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    // print('aaaaaaaaa');
                                    // print('after: ${store.deleteImage}');
                                    store.setImageSelected(index);
                                    store.setDeleteImage(true);
                                    // print('before: ${store.deleteImage}');
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      bottom: wXD(20, context),
                                      left: wXD(6, context),
                                      right: wXD(6, context),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3)),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                            color: Color(0x30000000))
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3)),
                                      child: Image.memory(
                                        store.images[index],
                                        fit: BoxFit.cover,
                                        height: wXD(196, context),
                                        width: wXD(282, context),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IncludePhotos(
                                imagesLength: store.images.length,
                                onTap: () => store.settakePicture(true),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Form(key: _formKey, child: AnnouncementDetails()),
                      SizedBox(height: wXD(42, context)),
                      SideButton(
                        onTap: () {
                          _formKey.currentState!.validate();
                          if (store.getValidate() &&
                              _formKey.currentState!.validate()) {
                            store.editingAd
                                ? store.editAnnouncement(context)
                                : store.createAnnouncement(context);
                          }
                        },
                        height: wXD(52, context),
                        width: wXD(142, context),
                        title: store.editingAd ? 'Salvar' : 'Enviar',
                      ),
                      SizedBox(height: wXD(29, context)),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: textFamily(context,
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.7)),
                            children: [
                              TextSpan(
                                  text:
                                      'Ao publicar você concorda e aceita nossos'),
                              TextSpan(
                                  style: textFamily(context,
                                      color: getColors(context).primary),
                                  text: ' Termos \nde Uso e Privacidade'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: wXD(10, context)),
                    ],
                  ),
                ),
                DefaultAppBar(
                  store.editingAd ? 'Editar anúncio' : 'Inserir anúncio',
                  onPop: () {
                    if (store.announcementTitle != '' ||
                        store.announcementDescription != '' ||
                        store.announcementCategory != '' ||
                        store.announcementType != '' ||
                        store.announcementIsNew != true ||
                        store.announcementPrice != null ||
                        store.announcementOption != '' ||
                        store.images.isNotEmpty) {
                      overlayEntry = getOverlay();
                      Overlay.of(context)?.insert(overlayEntry);
                    } else {
                      store.setEditingAd(false);
                      store.setAdEdit(AnnouncementModel());
                      Modular.to.pop();
                      store.cleanVars();
                    }
                  },
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: store.takePicture ||
                            store.searchType ||
                            store.deleteImage
                        ? 2
                        : 0,
                    sigmaY: store.takePicture ||
                            store.searchType ||
                            store.deleteImage
                        ? 2
                        : 0,
                  ),
                  child: AnimatedOpacity(
                    opacity: store.takePicture ||
                            store.searchType ||
                            store.deleteImage
                        ? .6
                        : 0,
                    duration: Duration(milliseconds: 600),
                    child: GestureDetector(
                      onTap: () => store.deleteImage
                          ? store.setDeleteImage(false)
                          : store.settakePicture(false),
                      child: Container(
                        height: store.takePicture ||
                                store.searchType ||
                                store.deleteImage
                            ? maxHeight(context)
                            : 0,
                        width: store.takePicture ||
                                store.searchType ||
                                store.deleteImage
                            ? maxWidth(context)
                            : 0,
                        color: getColors(context).onBackground,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 600),
                  bottom: store.takePicture ? 0 : wXD(-181, context),
                  child: IncludePhotosPopUp(),
                ),
                AnimatedPositioned(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 600),
                  bottom: store.deleteImage ? 0 : wXD(-181, context),
                  child: DeletePhotoPupUp(),
                ),
                AnimatedPositioned(
                  top: store.searchType ? 0 : maxHeight(context),
                  duration: Duration(milliseconds: 600),
                  child: Container(
                    height: maxHeight(context),
                    width: maxWidth(context),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      child: Column(
                        children: [
                          GestureDetector(
                              onTap: () => store.setSearchType(false),
                              child: Container(
                                  color: Colors.transparent,
                                  height: hXD(144, context),
                                  width: maxWidth(context))),
                          SearchType(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
