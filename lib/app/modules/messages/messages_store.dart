import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_agent_white_label/app/modules/profile/profile_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mime/mime.dart';
import 'package:mobx/mobx.dart';
import '../../core/models/customer_model.dart';
import '../../core/models/message_model.dart';
import '../../core/models/seller_model.dart';
import '../../shared/widgets/load_circular_overlay.dart';
part 'messages_store.g.dart';

class MessagesStore = _MessagesStoreBase with _$MessagesStore;

abstract class _MessagesStoreBase with Store {
  final ProfileStore profileStore = Modular.get();
  @observable
  String chatId = "";
  @observable
  String receiverName = "";
  @observable
  String recColl = "";
  @observable
  String text = "";
  @observable
  String searchText = "";
  @observable
  Customer? customer;
  @observable
  Seller? seller;
  // @observable
  // Agent? agent;
  @observable
  TextEditingController? textChatController;
  @observable
  List<String> messageIds = [];
  @observable
  File? cameraImage;
  @observable
  ObservableList<File> images = <File>[].asObservable();
  @observable
  int imagesPage = 0;
  // @observable
  // bool imagesBool = false;
  @observable
  List<DocumentSnapshot<Map<String, dynamic>>>? searchedChats;
  @observable
  List<SearchMessage>? searchedMessages;
  @observable
  ObservableList<Message> messages = <Message>[].asObservable();
  @observable
  // ignore: cancel_subscriptions
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? messagesSubscription;

  bool getShowUserData(int i) => messages[i].author != messages[i - 1].author;

  bool getIsAuthor(int i) => messages[i].userType == "AGENT";

  @action
  Future<void> clearNewMessages() async {
    print('clearNewMessages');
    User? _user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('agents')
        .doc(_user!.uid)
        .update({
      "new_messages": 0,
    });
    FirebaseFirestore.instance
        .collection("chats")
        .where("agent_id", isEqualTo: _user.uid)
        .orderBy("updated_at", descending: true)
        .get()
        .then((value) {
      value.docs.forEach((chatDoc) {
        chatDoc.reference.update({
          "agent_notifications": 0,
        });
      });
    });
    profileStore.setProfileEditFromDoc();
  }

  @action
  searchMessages(
    String _text,
    QuerySnapshot<Map<String, dynamic>> chatQue,
  ) async {
    print("searchMessages: $searchMessages");
    if (_text == "") {
      searchedChats = null;
      searchedMessages = null;
      return;
    }

    List<DocumentSnapshot<Map<String, dynamic>>> _chats = [];
    List<SearchMessage> _messages = [];

    for (DocumentSnapshot<Map<String, dynamic>> chatDoc in chatQue.docs) {
      DocumentSnapshot userDoc;
      String receiverId = "";
      String receiverCollection = "";
      if (chatDoc["customer_id"] != null) {
        final cusDoc = await FirebaseFirestore.instance
            .collection("customers")
            .doc(chatDoc["customer_id"])
            .get();
        userDoc = cusDoc;
        receiverCollection = "customers";
        receiverId = chatDoc["customer_id"];
        if (cusDoc["username"]
            .toString()
            .toLowerCase()
            .contains(_text.toLowerCase())) {
          _chats.add(chatDoc);
        }
      } else {
        final emiDoc = await FirebaseFirestore.instance
            .collection("sellers")
            .doc(chatDoc["seller_id"])
            .get();
        userDoc = emiDoc;
        receiverCollection = "sellers";
        receiverId = chatDoc["seller_id"];
        if (emiDoc["username"]
            .toString()
            .toLowerCase()
            .contains(_text.toLowerCase())) {
          _chats.add(chatDoc);
        }
      }

      final mesQue = await chatDoc.reference.collection("messages").get();

      for (DocumentSnapshot mesDoc in mesQue.docs) {
        if (mesDoc["text"]
            .toString()
            .toLowerCase()
            .contains(_text.toLowerCase())) {
          _messages.add(
            SearchMessage(
              Message.fromDoc(mesDoc),
              mesDoc["user_type"] == "AGENT" ? "Você" : userDoc["username"],
              receiverId,
              receiverCollection,
            ),
          );
        }
      }
    }

    searchedChats = _chats;
    searchedMessages = _messages;
  }

  @action
  Future<String> loadChatData(
    String receiverId,
    String receiverCollection,
  ) async {
    User? _user = FirebaseAuth.instance.currentUser;
    recColl = receiverCollection;
    QuerySnapshot chatQue;
    print("loadChatData step 1");
    DocumentSnapshot recDoc = await FirebaseFirestore.instance
        .collection(receiverCollection)
        .doc(receiverId)
        .get();
    print("loadChatData step 2");
    print("receiverCollection: $receiverCollection");

    if (receiverCollection == "customers") {
      chatQue = await FirebaseFirestore.instance
          .collection("chats")
          .where("agent_id", isEqualTo: _user!.uid)
          .where("customer_id", isEqualTo: receiverId)
          .get();
      customer = Customer.fromDoc(recDoc);
    } else {
      chatQue = await FirebaseFirestore.instance
          .collection("chats")
          .where("agent_id", isEqualTo: _user!.uid)
          .where("seller_id", isEqualTo: receiverId)
          .get();
      seller = Seller.fromDoc(recDoc);
    }
    print("loadChatData step 3");

    final agentDoc = await FirebaseFirestore.instance
        .collection("agents")
        .doc(_user.uid)
        .get();

    print("loadChatData step 4");

    // agent = Agent.fromDoc(agentDoc);

    print("loadChatData step 4.1: ${chatQue.docs.isEmpty}");

    if (chatQue.docs.isEmpty) {
      await createChat(agentDoc, recDoc);
      return recDoc["username"];
    }
    print("loadChatData step 5");

    final chatDoc = chatQue.docs.first;

    chatId = chatDoc.id;

    final chatStream = chatDoc.reference
        .collection("messages")
        .orderBy("created_at")
        .snapshots();
    print("loadChatData step 6");

    messagesSubscription = chatStream.listen((event) async {
      event.docChanges.forEach((element) {
        if (!messageIds.contains(element.doc.id) &&
            element.doc["created_at"] != null) {
          messages.insert(messages.length, Message.fromDoc(element.doc));
          messageIds.add(element.doc.id);
        }
      });
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(chatId)
          .update({"agent_notifications": 0});
    });
    print("loadChatData step 7");

    return recDoc["username"];
  }

  @action
  Future<void> createChat(
    DocumentSnapshot selDoc,
    DocumentSnapshot recDoc,
  ) async {
    User? _user = FirebaseAuth.instance.currentUser;
    final chatRef = FirebaseFirestore.instance.collection("chats").doc();

    if (recColl == "customers") {
      await chatRef.set({
        "created_at": FieldValue.serverTimestamp(),
        "customer_id": recDoc.id,
        "seller_id": null,
        "agent_id": _user!.uid,
        "updated_at": FieldValue.serverTimestamp(),
        "last_update": "",
        "id": chatRef.id,
        "seller_notifications": 0,
        "customer_notifications": 0,
        "agent_notifications": 0,
      });
    } else {
      chatRef.set({
        "created_at": FieldValue.serverTimestamp(),
        "customer_id": null,
        "seller_id": recDoc.id,
        "agent_id": _user!.uid,
        "updated_at": FieldValue.serverTimestamp(),
        "last_update": "",
        "id": chatRef.id,
        "seller_notifications": 0,
        "customer_notifications": 0,
        "agent_notifications": 0,
      });
    }

    chatId = chatRef.id;

    Stream<QuerySnapshot<Map<String, dynamic>>> messQue =
        chatRef.collection("messages").orderBy("created_at").snapshots();

    messagesSubscription = messQue.listen((event) async {
      event.docChanges.forEach((element) {
        if (!messageIds.contains(element.doc.id) &&
            element.doc["created_at"] != null) {
          messages.insert(messages.length, Message.fromDoc(element.doc));
          messageIds.add(element.doc.id);
        }
      });
      User? _user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('agents').doc(_user!.uid).update({
        "new_messages": 0,
      });
    });
  }

  @action
  Future sendMessage() async {
    User? _user = FirebaseAuth.instance.currentUser;
    if (text == "") return;
    textChatController!.clear();
    String _text = text;
    text = "";

    DocumentSnapshot<Map<String, dynamic>> chatDoc =
        await FirebaseFirestore.instance.collection("chats").doc(chatId).get();

    final tstRef = chatDoc.reference.collection("messages").doc();

    await tstRef.set({
      "created_at": FieldValue.serverTimestamp(),
      "author": _user!.uid,
      "text": _text,
      "id": tstRef.id,
      "file": null,
      "file_type": null,
      "user_type": "AGENT",
    });

    Map<String, dynamic> chatUpd = {
      "updated_at": FieldValue.serverTimestamp(),
      "last_update": _text,
    };

    if (recColl == "customers") {
      chatUpd["customer_notifications"] = chatDoc["customer_notifications"] + 1;
      FirebaseFirestore.instance
          .collection("customers")
          .doc(chatDoc["customer_id"])
          .update({
        "new_messages": FieldValue.increment(1),
      });
    } else {
      chatUpd["seller_notifications"] = chatDoc["seller_notifications"] + 1;
      FirebaseFirestore.instance
          .collection("sellers")
          .doc(chatDoc["seller_id"])
          .update({
        "new_messages": FieldValue.increment(1),
      });
    }

    await chatDoc.reference.update(chatUpd);
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
    User? _user = FirebaseAuth.instance.currentUser;
    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);
    print('sendImage');
    List<File> _images = cameraImage == null ? images : [cameraImage!];
    DocumentSnapshot<Map<String, dynamic>> chatDoc =
        await FirebaseFirestore.instance.collection("chats").doc(chatId).get();

    for (int i = 0; i < _images.length; i++) {
      final msgRef = chatDoc.reference.collection("messages").doc();

      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('agents/${_user!.uid}/chats/${chatDoc.id}/${msgRef.id}');
      UploadTask uploadTask = firebaseStorageRef.putFile(_images[i]);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageString = await taskSnapshot.ref.getDownloadURL();

      String? mimeType = lookupMimeType(_images[i].path);

      await msgRef.set({
        "created_at": FieldValue.serverTimestamp(),
        "author": _user.uid,
        "text": null,
        "id": msgRef.id,
        "file": imageString,
        "file_type": mimeType,
        "user_type": "AGENT",
      });
    }
    Map<String, dynamic> chatUpd = {
      "updated_at": FieldValue.serverTimestamp(),
      "last_update": "[imagem]",
    };

    if (recColl == "customers") {
      chatUpd["customer_notifications"] =
          chatDoc["customer_notifications"] + _images.length;
      FirebaseFirestore.instance
          .collection("customers")
          .doc(chatDoc["customer_id"])
          .update({
        "new_messages": FieldValue.increment(1 + _images.length),
      });
    } else {
      chatUpd["seller_notifications"] =
          chatDoc["seller_notifications"] + _images.length;
      FirebaseFirestore.instance
          .collection("sellers")
          .doc(chatDoc["seller_id"])
          .update({
        "new_messages": FieldValue.increment(1 + _images.length),
      });
    }

    await chatDoc.reference.update(chatUpd);

    // imagesBool = false;
    cameraImage = null;
    await Future.delayed(Duration(milliseconds: 500), () => images.clear());
    loadOverlay.remove();
  }

  void disposeChat() {
    // print("dispose do chat");
    textChatController!.dispose();
    if (messagesSubscription != null) messagesSubscription!.cancel();
    messagesSubscription = null;
    customer = null;
    seller = null;
    messages.clear();
    messageIds.clear();
  }

  void disposeMessages() {
    searchedChats = null;
    searchedMessages = null;
  }
}
