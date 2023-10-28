import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_agent_white_label/app/modules/support/support_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import '../../../core/models/message_model.dart';
import '../../../shared/utilities.dart';
import '../../../shared/widgets/center_load_circular.dart';
import '../../../shared/widgets/default_app_bar.dart';
import '../../../shared/widgets/floating_circle_button.dart';
import '../../main/main_store.dart';
import '../../messages/widgets/message.dart';
import '../../messages/widgets/message_bar.dart';

class SupportChat extends StatefulWidget {
  @override
  State<SupportChat> createState() => _SupportChatState();
}

class _SupportChatState extends State<SupportChat> {
  final MainStore mainStore = Modular.get();

  final SupportStore store = Modular.get();

  final User? _user = FirebaseAuth.instance.currentUser;

  final PageController pageController = PageController();

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (store.imagesBool || store.cameraImage != null) {
          store.images.clear();
          store.imagesBool = false;
          store.cameraImage = null;
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Observer(
          builder: (context) {
            print("store.cameraImage: ${store.cameraImage}");
            return Stack(
              children: [
                SizedBox(
                  height: maxHeight(context),
                  width: maxWidth(context),
                  child: SingleChildScrollView(
                    reverse: true,
                    padding: EdgeInsets.symmetric(vertical: wXD(80, context)),
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("supports")
                          .where("user_id", isEqualTo: _user!.uid)
                          .where("user_collection", isEqualTo: "AGENTS")
                          .snapshots(),
                      builder: (context, supportSnap) {
                        if (!supportSnap.hasData) {
                          return CenterLoadCircular();
                        }

                        if (supportSnap.data!.docs.isEmpty) {
                          return Container();
                        }

                        final supportDoc = supportSnap.data!.docs.first;

                        return StreamBuilder<
                            QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection("supports")
                              .doc(supportDoc.id)
                              .collection("messages")
                              .orderBy("created_at")
                              .snapshots(),
                          builder: (context, messagesSnap) {
                            if (!messagesSnap.hasData) {
                              return CenterLoadCircular();
                            }
                            List<Message> messages = [];
                            messagesSnap.data!.docs.forEach((messageDoc) {
                              messages.add(Message.fromDoc(messageDoc));
                            });

                            // bool needAvatar(int index) {
                            //   if (index == 0) return true;
                            //   if (messages[index].senderId ==
                            //       messages[index - 1].senderId) {
                            //     return false;
                            //   }
                            //   return true;
                            // }

                            return Column(
                              children: List.generate(messages.length, (index) {
                                Message _message = messages[index];
                                Message? _previousMessage;
                                if (index > 0) {
                                  _previousMessage = messages[index - 1];
                                }

                                print('_message: ${_message.createdAt}');

                                return MessageWidget(
                                  isAuthor: _message.author == _user!.uid,
                                  // rightName: mainStore.agentMap["username"],
                                  // leftName: "Suporte",
                                  messageData: _message,
                                  // showUserData: index == 0
                                  //     ? true
                                  //     : _message.author !=
                                  //         _previousMessage!.author,
                                  messageBold: false,
                                );
                              }),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                DefaultAppBar('Suporte'),
                Positioned(
                  bottom: 0,
                  child: MessageBar(
                    focus: focusNode,
                    controller: store.textController,
                    onSend: () => store.sendSupportMessage(),
                    onEditingComplete: () => store.sendSupportMessage(),
                    takePictures: () async {
                      List? response = await pickMultiImageWithName();
                      if (response != null) {
                        print('response: ${response[0]}');
                        print('response: ${response[1]}');
                        List<File> images = response[0];
                        store.images = images.asObservable();
                        store.imagesName = response[1];
                        // store.imagesBool = response[0].isNotEmpty;
                      }

                      // List<File> images = await pickMultiImage() ?? [];
                      // store.images = images.asObservable();
                    },
                    getCameraImage: () async {
                      List? response = await pickCameraImageWithName();
                      if (response != null) {
                        store.cameraImage = response[0];
                        store.imagesName = response[1];
                        store.sendImage(context);
                      }
                    },
                  ),
                ),
                // AnimatedPositioned(
                //   duration: Duration(milliseconds: 500),
                //   top: store.imagesBool ? 0 : maxHeight(context),
                //   child: Stack(
                //     alignment: Alignment.center,
                //     children: [
                //       GestureDetector(
                //         onTap: () {
                //           // store.cameraImage = null;
                //           store.imagesBool = false;
                //           Future.delayed(Duration(milliseconds: 500),
                //               () => store.images = []);
                //         },
                //         child: Container(
                //           color: Colors.transparent,
                //           height: maxHeight(context),
                //           width: maxWidth(context),
                //         ),
                //       ),
                //       Container(
                //         height: hXD(550, context),
                //         width: wXD(300, context),
                //         margin:
                //             EdgeInsets.symmetric(vertical: wXD(58, context)),
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.all(Radius.circular(3)),
                //         ),
                //         alignment: Alignment.center,
                //         child: ClipRRect(
                //           borderRadius: BorderRadius.all(Radius.circular(3)),
                //           child: SingleChildScrollView(
                //             child: Column(
                //               mainAxisSize: MainAxisSize.max,
                //               children: List.generate(
                //                 store.images!.length,
                //                 (index) => Image.file(
                //                   store.images![index],
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //       Positioned(
                //         bottom: wXD(10, context),
                //         right: wXD(10, context),
                //         child: GestureDetector(
                //           onTap: () => store.sendImage(context),
                //           child: Container(
                //             height: wXD(50, context),
                //             width: wXD(50, context),
                //             decoration: BoxDecoration(
                //               color: getColors(context).primary,
                //               shape: BoxShape.circle,
                //             ),
                //             child: Icon(
                //               Icons.send_outlined,
                //               color: getColors(context).onSurface,
                //               size: wXD(23, context),
                //             ),
                //           ),
                //         ),
                //       ),
                //       Positioned(
                //         top: wXD(10, context) +
                //             MediaQuery.of(context).viewPadding.top,
                //         left: wXD(45, context),
                //         child: InkWell(
                //           onTap: () {
                //             store.imagesBool = false;
                //             Future.delayed(
                //               Duration(milliseconds: 500),
                //               () => store.images!.clear(),
                //             );
                //           },
                //           child: Stack(
                //             alignment: Alignment.center,
                //             children: [
                //               Icon(
                //                 Icons.close_rounded,
                //                 size: wXD(35, context),
                //                 color: getColors(context).onSurface,
                //               ),
                //               Icon(Icons.close_rounded,
                //                   size: wXD(30, context)),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Visibility(
                  visible: store.images.isNotEmpty,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        color: getColors(context).surface,
                        height: maxHeight(context),
                        width: maxWidth(context),
                        child: Container(
                          height: wXD(800, context),
                          width: maxWidth(context),
                          margin:
                              EdgeInsets.symmetric(vertical: wXD(58, context)),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                          ),
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(3)),
                            child: Observer(builder: (context) {
                              return PageView(
                                children: List.generate(
                                  store.images.length,
                                  (index) => Image.file(
                                    store.images[index],
                                  ),
                                ),
                                onPageChanged: (page) =>
                                    store.imagesPage = page,
                                controller: pageController,
                              );
                            }),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: SizedBox(
                          width: maxWidth(context),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  right: wXD(10, context),
                                  bottom: wXD(10, context),
                                ),
                                alignment: Alignment.centerRight,
                                child: FloatingCircleButton(
                                  onTap: () => store.sendImage(context),
                                  icon: Icons.send_outlined,
                                  iconColor: getColors(context).primary,
                                  size: wXD(55, context),
                                  iconSize: 30,
                                ),
                              ),
                              Observer(
                                builder: (context) {
                                  return SizedBox(
                                    width: maxWidth(context),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                          store.images.length,
                                          (index) => InkWell(
                                            onTap: () => pageController
                                                .jumpToPage(index),
                                            child: Container(
                                              height: wXD(70, context),
                                              width: wXD(70, context),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                width: 2,
                                                color: index == store.imagesPage
                                                    ? getColors(context).primary
                                                    : Colors.transparent,
                                              )),
                                              child: Image.file(
                                                store.images[index],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: wXD(10, context) +
                            MediaQuery.of(context).viewPadding.top,
                        child: Container(
                          width: maxWidth(context),
                          padding: EdgeInsets.symmetric(
                              horizontal: wXD(10, context)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  store.cancelImages();
                                },
                                icon: Icon(Icons.close_rounded,
                                    size: wXD(30, context)),
                              ),
                              IconButton(
                                onPressed: () => store.removeImage(),
                                icon: Icon(Icons.delete_outline_rounded,
                                    size: wXD(30, context)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
