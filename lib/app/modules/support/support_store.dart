import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../../shared/widgets/load_circular_overlay.dart';
import 'package:mime/mime.dart';
part 'support_store.g.dart';

class SupportStore = _SupportStoreBase with _$SupportStore;

abstract class _SupportStoreBase with Store {
  _SupportStoreBase() {
    createSupport();
  }
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }

  @observable
  int imagesPage = 0;
  @observable
  ObservableList<File> images = <File>[].asObservable();
  @observable
  List<String>? imagesName = [];
  @observable
  bool imagesBool = false;
  @observable
  File? cameraImage;
  @observable
  TextEditingController textController = TextEditingController();

  @action
  Future<void> createSupport() async {
    User? _user = FirebaseAuth.instance.currentUser;

    QuerySnapshot supportQuery = await FirebaseFirestore.instance
        .collection("supports")
        .where("user_id", isEqualTo: _user!.uid)
        .where("user_collection", isEqualTo: "AGENTS")
        .get();

    print("create support: ${supportQuery.docs.isEmpty}");

    if (supportQuery.docs.isEmpty) {
      DocumentReference suporteRef =
          await FirebaseFirestore.instance.collection("supports").add({
        "user_id": _user.uid,
        "id": null,
        "created_at": FieldValue.serverTimestamp(),
        "updated_at": FieldValue.serverTimestamp(),
        "user_notification": 0,
        "support_notification": 0,
        "last_update": "",
        "user_collection": "AGENTS",
      });
      await suporteRef.update({"id": suporteRef.id});
    }
  }

  @action
  Future<void> sendSupportMessage() async {
    if (textController.text == "") return;
    User? _user = FirebaseAuth.instance.currentUser;
    QuerySnapshot supportQuery = await FirebaseFirestore.instance
        .collection("supports")
        .where("user_id", isEqualTo: _user!.uid)
        .where("user_collection", isEqualTo: "AGENTS")
        .get();

    print('supportQuery.docs.isNotEmpty: ${supportQuery.docs.isNotEmpty}');
    if (supportQuery.docs.isNotEmpty) {
      DocumentReference messageRef =
          await supportQuery.docs.first.reference.collection("messages").add({
        "id": null,
        "author": _user.uid,
        "text": textController.text,
        "created_at": FieldValue.serverTimestamp(),
        "file": null,
        "file_type": null,
      });

      await messageRef.update({
        "id": messageRef.id,
      });

      await supportQuery.docs.first.reference.update({
        "last_update": textController.text,
        "support_notification": FieldValue.increment(1),
      });
    }
    textController.clear();
  }

  @action
  void removeImage() {
    images.removeAt(imagesPage);
    if (imagesPage == images.length && imagesPage != 0) {
      imagesPage = images.length - 1;
    }
    print(imagesPage);
  }

  @action
  void cancelImages() {
    images.clear();
    imagesPage = 0;
    cameraImage = null;
  }

  @action
  Future sendImage(context) async {
    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => const LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);

    User? _user = FirebaseAuth.instance.currentUser;

    List<File> _images = cameraImage == null ? images.toList() : [cameraImage!];

    QuerySnapshot supportQuery = await FirebaseFirestore.instance
        .collection("supports")
        .where("user_id", isEqualTo: _user!.uid)
        .where("user_collection", isEqualTo: "AGENTS")
        .get();

    if (supportQuery.docs.isNotEmpty) {
      DocumentSnapshot supportDoc = supportQuery.docs.first;
      for (int i = 0; i < _images.length; i++) {
        File _imageFile = _images[i];
        String _imageName = imagesName![i];

        Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('supports/${_user.uid}/images/$_imageName');

        UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);

        TaskSnapshot taskSnapshot = await uploadTask;

        String imageString = await taskSnapshot.ref.getDownloadURL();

        String? mimeType = lookupMimeType(_imageFile.path);

        DocumentReference messageRef =
            await supportDoc.reference.collection('messages').add({
          "created_at": FieldValue.serverTimestamp(),
          "author": _user.uid,
          "text": null,
          "id": null,
          "file": imageString,
          "file_type": mimeType,
        });

        await messageRef.update({
          "id": messageRef.id,
        });
      }

      Map<String, dynamic> chatUpd = {
        "updated_at": FieldValue.serverTimestamp(),
        "last_update": "[imagem]",
        "support_notification": FieldValue.increment(1),
      };

      await supportDoc.reference.update(chatUpd);
    }

    imagesBool = false;
    cameraImage = null;
    await Future.delayed(
        const Duration(milliseconds: 500), () => images.clear());
    loadOverlay.remove();
  }
}
