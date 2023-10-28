import 'package:delivery_agent_white_label/app/core/models/announcement_model.dart';
import 'package:delivery_agent_white_label/app/modules/main/main_store.dart';

import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/confirm_popup.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/congratulations_popup.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../advertisement_store.dart';

class DeleteAnnouncement extends StatefulWidget {
  final ScrollController scrollController;

  const DeleteAnnouncement({Key? key, required this.scrollController})
      : super(key: key);
  @override
  _DeleteAnnouncementState createState() => _DeleteAnnouncementState();
}

class _DeleteAnnouncementState extends State<DeleteAnnouncement> {
  final AdvertisementStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  final TextEditingController textController = TextEditingController();

  ScrollPhysics scrollPhysics =
      BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

  FocusNode focusNode = FocusNode();

  late OverlayEntry overlayEntry;
  OverlayEntry? overlayDeleteAnnouncement;

  int reasonToDelete = 0;
  double grade = .5;
  String note = '';

  double height = 0;

  @override
  void initState() {
    widget.scrollController.addListener(() {
      print("offSet: ${wXD(widget.scrollController.offset, context)}");
    });

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          height = wXD(250, context);
        });
        print('height: $height');
        Future.delayed(
            Duration(milliseconds: 550),
            () => widget.scrollController.animateTo(
                  widget.scrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                ));
      } else {
        setState(() {
          height = 0;
        });
        print('height: $height');
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    widget.scrollController.removeListener(() {});
    super.dispose();
  }

  OverlayEntry getoverlay() {
    return OverlayEntry(
      builder: (context) {
        return CongratulationsPopup(
          text: 'Parabéns',
          subText: 'Você despegou!\nObrigado por anunciar com a gente',
          onNewAd: () async {
            overlayEntry.remove();
            overlayDeleteAnnouncement!.remove();
            overlayDeleteAnnouncement = null;
            store.callDelete(removeDelete: true);
            await Modular.to.pushNamed('/advertisement/create-announcement');
          },
          onBack: () {
            overlayEntry.remove();
            overlayDeleteAnnouncement!.remove();
            overlayDeleteAnnouncement = null;
            store.callDelete(removeDelete: true);
          },
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      height: maxHeight(context),
      child: SingleChildScrollView(
        physics: scrollPhysics,
        controller: widget.scrollController,
        child: Listener(
          onPointerDown: (a) {
            focusNode.unfocus();
          },
          child: Column(
            children: [
              GestureDetector(
                onTap: () => store.callDelete(removeDelete: true),
                child: Container(
                  height: wXD(120, context),
                  width: maxWidth(context),
                  color: Colors.transparent,
                ),
              ),
              Container(
                width: maxWidth(context),
                decoration: BoxDecoration(
                  color: getColors(context).onSurface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(3),
                  ),
                ),
                child: Observer(builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: wXD(46, context),
                        width: maxWidth(context),
                        decoration: BoxDecoration(
                          color: getColors(context).primary,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(3),
                          ),
                        ),
                        child: Text('Excluir anúncio',
                            style: textFamily(
                              context,
                              fontSize: 17,
                              color: getColors(context).onSurface,
                            )),
                        alignment: Alignment.center,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: wXD(12, context),
                          top: wXD(14, context),
                          bottom: wXD(11, context),
                        ),
                        width: maxWidth(context),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: getColors(context)
                                        .onBackground
                                        .withOpacity(.9)
                                        .withOpacity(.2)))),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Excluir anúncio',
                              style: textFamily(
                                context,
                                fontSize: 14,
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.7),
                              ),
                            ),
                            Text(
                              'Anúncio: ${store.adDelete.title}',
                              style: textFamily(
                                context,
                                fontSize: 12,
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: wXD(12, context),
                          top: wXD(18, context),
                        ),
                        width: maxWidth(context),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.9)
                                    .withOpacity(.2)),
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Qual o motivo para excluir esse anúncio?',
                              style: textFamily(context,
                                  fontSize: 12,
                                  color: getColors(context).onBackground),
                            ),
                            SizedBox(height: wXD(25, context)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => reasonToDelete = 1),
                                  child: Container(
                                    height: wXD(19, context),
                                    width: wXD(19, context),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0XFF9F9F9F),
                                          width: wXD(2, context)),
                                      shape: BoxShape.circle,
                                    ),
                                    margin: EdgeInsets.only(
                                      right: wXD(12, context),
                                      bottom: wXD(13, context),
                                    ),
                                    alignment: Alignment.center,
                                    child: reasonToDelete == 1
                                        ? Container(
                                            height: wXD(11, context),
                                            width: wXD(11, context),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    getColors(context).primary),
                                          )
                                        : Container(),
                                  ),
                                ),
                                Text(
                                  'Vendi pela Scorefy',
                                  style: textFamily(
                                    context,
                                    fontSize: 12,
                                    color: getColors(context).onBackground,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => reasonToDelete = 2),
                                  child: Container(
                                    height: wXD(19, context),
                                    width: wXD(19, context),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0XFF9F9F9F), width: 2),
                                      shape: BoxShape.circle,
                                    ),
                                    margin: EdgeInsets.only(
                                      right: wXD(12, context),
                                      bottom: wXD(13, context),
                                    ),
                                    alignment: Alignment.center,
                                    child: reasonToDelete == 2
                                        ? Container(
                                            height: wXD(11, context),
                                            width: wXD(11, context),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    getColors(context).primary),
                                          )
                                        : Container(),
                                  ),
                                ),
                                Text(
                                  'Vendi por outro meio',
                                  style: textFamily(
                                    context,
                                    fontSize: 12,
                                    color: getColors(context).onBackground,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => reasonToDelete = 3),
                                  child: Container(
                                    height: wXD(19, context),
                                    width: wXD(19, context),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0XFF9F9F9F), width: 2),
                                      shape: BoxShape.circle,
                                    ),
                                    margin: EdgeInsets.only(
                                      right: wXD(12, context),
                                      bottom: wXD(13, context),
                                    ),
                                    alignment: Alignment.center,
                                    child: reasonToDelete == 3
                                        ? Container(
                                            height: wXD(11, context),
                                            width: wXD(11, context),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    getColors(context).primary),
                                          )
                                        : Container(),
                                  ),
                                ),
                                Text(
                                  'Desisti de vender',
                                  style: textFamily(
                                    context,
                                    fontSize: 12,
                                    color: getColors(context).onBackground,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => reasonToDelete = 4),
                                  child: Container(
                                    height: wXD(19, context),
                                    width: wXD(19, context),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0XFF9F9F9F), width: 2),
                                      shape: BoxShape.circle,
                                    ),
                                    margin: EdgeInsets.only(
                                      right: wXD(12, context),
                                      bottom: wXD(13, context),
                                    ),
                                    alignment: Alignment.center,
                                    child: reasonToDelete == 4
                                        ? Container(
                                            height: wXD(11, context),
                                            width: wXD(11, context),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    getColors(context).primary),
                                          )
                                        : Container(),
                                  ),
                                ),
                                Text(
                                  'Outro motivo',
                                  style: textFamily(
                                    context,
                                    fontSize: 12,
                                    color: getColors(context).onBackground,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => reasonToDelete = 5),
                                  child: Container(
                                    height: wXD(19, context),
                                    width: wXD(19, context),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0XFF9F9F9F), width: 2),
                                      shape: BoxShape.circle,
                                    ),
                                    margin: EdgeInsets.only(
                                      right: wXD(12, context),
                                      bottom: wXD(13, context),
                                    ),
                                    alignment: Alignment.center,
                                    child: reasonToDelete == 5
                                        ? Container(
                                            height: wXD(11, context),
                                            width: wXD(11, context),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    getColors(context).primary),
                                          )
                                        : Container(),
                                  ),
                                ),
                                Text(
                                  'Ainda não vendi',
                                  style: textFamily(
                                    context,
                                    fontSize: 12,
                                    color: getColors(context).onBackground,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: wXD(12, context),
                          top: wXD(18, context),
                        ),
                        width: maxWidth(context),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.9)
                                    .withOpacity(.2)),
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Você recomendaria a Scorefy?',
                              style: textFamily(context,
                                  fontSize: 12,
                                  color: getColors(context).onBackground),
                            ),
                            SizedBox(height: wXD(25, context)),
                            Center(
                              child: Container(
                                width: wXD(310, context),
                                child: Slider(
                                  onChanged: (a) => setState(() => grade = a),
                                  value: grade,
                                  activeColor: getColors(context).primary,
                                  inactiveColor: Color(0xffbdbdbd),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(width: wXD(17, context)),
                                Text(
                                  'Não',
                                  style: textFamily(context,
                                      fontSize: 12,
                                      color: getColors(context).onBackground),
                                ),
                                Spacer(),
                                Text(
                                  'Sim',
                                  style: textFamily(context,
                                      fontSize: 12,
                                      color: getColors(context).onBackground),
                                ),
                                SizedBox(width: wXD(17, context)),
                              ],
                            ),
                            SizedBox(height: wXD(17, context)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: wXD(12, context),
                            top: wXD(24, context),
                            bottom: wXD(11, context)),
                        child: Text(
                          'Você recomendaria a Scorefy?',
                          style: textFamily(context,
                              fontSize: 12,
                              color: getColors(context).onBackground),
                        ),
                      ),
                      Center(
                        child: Container(
                          height: wXD(52, context),
                          width: wXD(342, context),
                          padding: EdgeInsets.symmetric(
                              horizontal: wXD(15, context)),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: getColors(context).primary,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                          ),
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            focusNode: focusNode,
                            controller: textController,
                            decoration: InputDecoration.collapsed(
                                hintText: 'Comentário'),
                            onChanged: (val) {
                              note = val;
                            },
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: wXD(39, context),
                          bottom: wXD(34, context),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SideButton(
                              onTap: () {
                                store.callDelete(removeDelete: true);

                                cleanVars();
                              },
                              isWhite: true,
                              title: 'Cancelar',
                              height: wXD(52, context),
                              width: wXD(142, context),
                            ),
                            SideButton(
                              onTap: () {
                                overlayDeleteAnnouncement = OverlayEntry(
                                  builder: (context) => ConfirmPopup(
                                    height: wXD(140, context),
                                    text:
                                        'Tem certeza que deseja excluir esta publicação?',
                                    onConfirm: () async {
                                      if (reasonToDelete == 0) {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Selecione um motivo para a exclusão');
                                        overlayDeleteAnnouncement!.remove();
                                      } else {
                                        await store.deleteAnnouncement(
                                          context: context,
                                          reason: reasonToDelete,
                                          grade: grade,
                                          note: note,
                                        );
                                        overlayEntry = getoverlay();
                                        Overlay.of(context)
                                            ?.insert(overlayEntry);
                                        cleanVars();
                                      }
                                    },
                                    onCancel: () {
                                      overlayDeleteAnnouncement!.remove();
                                      overlayDeleteAnnouncement = null;
                                    },
                                  ),
                                );
                                Overlay.of(context)!
                                    .insert(overlayDeleteAnnouncement!);
                              },
                              title: 'Enviar',
                              height: wXD(52, context),
                              width: wXD(142, context),
                            )
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        height: height,
                      )
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  cleanVars() {
    reasonToDelete = 0;
    grade = .5;
    note = '';
    store.setAdDelete(AnnouncementModel());
    textController.clear();
    widget.scrollController
        .animateTo(0, duration: Duration(seconds: 1), curve: Curves.ease);
    focusNode.unfocus();
  }
}
