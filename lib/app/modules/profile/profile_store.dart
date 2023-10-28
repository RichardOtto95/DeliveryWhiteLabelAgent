import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_agent_white_label/app/modules/main/main_store.dart';
import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../constants/.info.dart';
part 'profile_store.g.dart';

class ProfileStore = _ProfileStoreBase with _$ProfileStore;

abstract class _ProfileStoreBase with Store {
  final MainStore mainStore = Modular.get();

  @observable
  ObservableMap profileEdit = {}.asObservable();
  @observable
  ObservableMap profileData = {}.asObservable();
  @observable
  bool birthdayValidate = false;
  @observable
  bool bankValidate = false;
  @observable
  bool genderValidate = false;
  @observable
  bool avatarValidate = false;
  @observable
  bool pixKeyValidate = false;
  @observable
  bool concluded = false;
  @observable
  List<DocumentSnapshot>? bankDocs;
  @observable
  List<DocumentSnapshot> bankDocsSearch = [];
  @observable
  OverlayEntry? loadOverlay;

  Future<void> getBanks() async {
    bankDocs = (await FirebaseFirestore.instance
            .collection("info")
            .doc(infoId)
            .collection("banks")
            .orderBy("label")
            .get())
        .docs;
  }

  void searchBank(String? txt) {
    bankDocsSearch.clear();
    if (txt == null || txt == "") {
      return;
    }
    if (bankDocs != null) {
      List<DocumentSnapshot> search = [];
      for (final bank in bankDocs!) {
        if (bank.get("label").toString().toLowerCase().contains(txt)) {
          search.add(bank);
        }
      }
      bankDocsSearch = search;
    }
  }

  @action
  Future<void> clearNewRatings() async {
    print('clearNewRatings');
    User? _user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('agents')
        .doc(_user!.uid)
        .update({
      "new_ratings": 0,
    });
    setProfileEditFromDoc();
  }

  @action
  changeNotificationEnabled(bool change) async {
    print('changeNotificationEnabled $change');
    final User? _user = FirebaseAuth.instance.currentUser;
    profileData['notification_enabled'] = change;
    FirebaseFirestore.instance
        .collection('agents')
        .doc(_user!.uid)
        .update({'notification_enabled': change});
  }

  @action
  Future setProfileEditFromDoc() async {
    final User? _user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot _ds = await FirebaseFirestore.instance
        .collection("agents")
        .doc(_user!.uid)
        .get();
    print("user.exist? ${_ds.exists}");
    Map<String, dynamic> map = _ds.data() as Map<String, dynamic>;
    map['linked_to_cnpj'] = map['linked_to_cnpj'] ?? false;
    map['savings_account'] = map['savings_account'] ?? false;
    ObservableMap<String, dynamic> agentMap = map.asObservable();
    print("agentMap: ${agentMap["agency_digit"]}");
    profileData = agentMap;
    // profileEdit = sellerMap;
    // print("Seller Map: $sellerMap");
    // print("Username: ${sellerMap['username']}");
  }

  @action
  Future<void> pickAvatar() async {
    final User? _user = FirebaseAuth.instance.currentUser;
    File? _imageFile = await pickImage();
    profileEdit['avatar'] = "";
    if (_imageFile != null) {
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('agents/${_user!.uid}/avatar/$_imageFile');

      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);

      TaskSnapshot taskSnapshot = await uploadTask;

      taskSnapshot.ref.getDownloadURL().then((downloadURL) async {
        print(
            'downloadURLdownloadURLdownloadURLdownloadURLdownloadURL    $downloadURL');
        profileEdit['avatar'] = downloadURL;
        // profileData['avatar'] = downloadURL;
        avatarValidate = false;
      });
    } else {
      if (profileData['avatar'] != "" && profileData['avatar'] != null) {
        profileEdit['avatar'] = profileData['avatar'];
      } else {
        profileEdit['avatar'] = null;
      }
    }
  }

  @action
  bool getValidate() {
    if (profileEdit['birthday'] == null && profileData['birthday'] == null) {
      birthdayValidate = true;
    } else {
      birthdayValidate = false;
    }

    if ((profileEdit['bank'] == null || profileEdit['bank'] == '') &&
        (profileData['bank'] == null || profileData['bank'] == "")) {
      bankValidate = true;
    } else {
      bankValidate = false;
    }

    if ((profileEdit['gender'] == null || profileEdit['gender'] == '') &&
        (profileData['gender'] == null || profileData['gender'] == '')) {
      genderValidate = true;
    } else {
      genderValidate = false;
    }

    if ((profileEdit['avatar'] == null || profileEdit['avatar'] == '') &&
        (profileData['avatar'] == null || profileData['avatar'] == '')) {
      avatarValidate = true;
    } else {
      avatarValidate = false;
    }

    if ((profileEdit['pix_key'] == null || profileEdit['pix_key'] == '') &&
        (profileData['pix_key'] == null || profileData['pix_key'] == '')) {
      pixKeyValidate = true;
    } else {
      pixKeyValidate = false;
    }
    print("birthdayValidate: $birthdayValidate");
    print("bankValidate: $bankValidate");
    print("genderValidate: $genderValidate");
    print("avatarValidate: $avatarValidate");
    print('profileEdit["agency_digit"]: ${profileEdit["agency_digit"]}');
    print('profileEdit["account_digit"]: ${profileEdit["account_digit"]}');
    print('profileEdit["agency_digit"]: ${profileEdit["agency_digit"]}');
    print('profileEdit["account_digit"] : ${profileEdit["account_digit"]}');
    if (profileEdit["agency_digit"] == null ||
        profileEdit["account_digit"] == null ||
        profileEdit["agency_digit"] == "" ||
        profileEdit["account_digit"] == "") {
      return false;
    }

    return !birthdayValidate &&
        !bankValidate &&
        !genderValidate &&
        !avatarValidate;
  }

  @action
  setBirthday(context, Function callBack) async {
    DateTime? _birthday;
    pickDate(context, onConfirm: (date) {
      print("Confirm pick date");
      _birthday = date;
      if (_birthday != null) {
        profileEdit["birthday"] = Timestamp.fromDate(_birthday!);
        // profileData["birthday"] = Timestamp.fromDate(_birthday!);
        birthdayValidate = false;
        callBack();
      }
    });
  }

  @action
  Future saveProfile(context) async {
    print('saveProfile');
    final User? _user = FirebaseAuth.instance.currentUser;
    print('user: ${_user!.uid}');

    loadOverlay =
        OverlayEntry(builder: (context) => const LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay!);
    print('after load');

    Map<String, dynamic> _profileMap = profileEdit.cast();
    print("_profileMap: $_profileMap");
    await FirebaseFirestore.instance
        .collection('agents')
        .doc(_user.uid)
        .update(_profileMap);
    await setProfileEditFromDoc();
    loadOverlay!.remove();
    loadOverlay = null;
    profileEdit.clear();
    Modular.to.pop();
  }

  @action
  Future<void> setTokenLogout() async {
    final User? _user = FirebaseAuth.instance.currentUser;
    String? token = await FirebaseMessaging.instance.getToken();
    print('user token: $token');
    DocumentSnapshot _userDoc = await FirebaseFirestore.instance
        .collection('agents')
        .doc(_user!.uid)
        .get();

    List tokens = _userDoc['token_id'];
    print('tokens length: ${tokens.length}');

    for (var i = 0; i < tokens.length; i++) {
      if (tokens[i] == token) {
        print('has $token');
        tokens.removeAt(i);
        print('tokens: $tokens');
      }
    }
    print('tokens2: $tokens');
    _userDoc.reference.update({'token_id': tokens});
  }

  @action
  Future<DocumentSnapshot> getAdsDoc(String orderId) async {
    QuerySnapshot orderAdsQuery = await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .collection('ads')
        .get();

    DocumentSnapshot adsDoc = await FirebaseFirestore.instance
        .collection('ads')
        .doc(orderAdsQuery.docs.first.id)
        .get();

    return adsDoc;
  }

  @action
  Future<void> answerRating(
      String ratingId, String answer, BuildContext context) async {
    print('answerRating ratingId: $ratingId');
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(overlayEntry);

    User? _user = FirebaseAuth.instance.currentUser;

    print("_user ${_user!.uid}");

    await FirebaseFirestore.instance
        .collection("agents")
        .doc(_user.uid)
        .collection('ratings')
        .doc(ratingId)
        .update({
      "answered": true,
      "answer": answer,
    });

    await FirebaseFirestore.instance
        .collection('ratings')
        .doc(ratingId)
        .update({
      "answered": true,
      "answer": answer,
    });
    print('after update');

    Modular.to.pop();
    overlayEntry.remove();
    overlayEntry = null;
  }
}
