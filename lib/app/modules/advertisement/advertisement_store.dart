import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_agent_white_label/app/core/models/announcement_model.dart';
import 'package:delivery_agent_white_label/app/modules/main/main_store.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/load_circular_overlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';

part 'advertisement_store.g.dart';

class AdvertisementStore = _AdvertisementStoreBase with _$AdvertisementStore;

abstract class _AdvertisementStoreBase with Store {
  final MainStore mainStore = Modular.get();

  @observable
  bool addAnnouncement = true;
  @observable
  bool delete = false;
  @observable
  bool takePicture = false;
  @observable
  bool searchType = false;
  @observable
  bool deleteImage = false;
  @observable
  bool announcementIsNew = true;
  @observable
  bool categoryValidateVisible = false;
  @observable
  bool typeValidateVisible = false;
  @observable
  bool imagesEmpty = false;
  @observable
  bool circularIndicator = false;
  @observable
  bool charging = true;
  @observable
  bool editingAd = false;
  @observable
  int imageSelected = 0;
  @observable
  int announcementsActive = 0;
  @observable
  int announcementsPending = 0;
  @observable
  int announcementsExpired = 0;
  @observable
  double? announcementPrice;
  @observable
  String announcementTitle = '';
  @observable
  String announcementDescription = '';
  @observable
  String announcementCategory = '';
  @observable
  String announcementType = '';
  @observable
  String announcementOption = '';
  @observable
  String announcementStatusSelected = 'active';
  @observable
  AnnouncementModel adDelete = AnnouncementModel();
  @observable
  AnnouncementModel adEdit = AnnouncementModel();
  @observable
  ObservableList<Uint8List> images = <Uint8List>[].asObservable();
  @observable
  ObservableList<AnnouncementModel> activeAds =
      <AnnouncementModel>[].asObservable();
  @observable
  ObservableList<AnnouncementModel> pendingAds =
      <AnnouncementModel>[].asObservable();
  @observable
  ObservableList<AnnouncementModel> expiredAds =
      <AnnouncementModel>[].asObservable();

  @action
  setAddAnnouncement(_addAnnouncement) => addAnnouncement = _addAnnouncement;
  @action
  setdelete(_delete) => delete = _delete;
  @action
  settakePicture(_takePicture) => takePicture = _takePicture;
  @action
  setSearchType(_searchType) => searchType = _searchType;
  @action
  setImageSelected(_imageSelected) => imageSelected = _imageSelected;
  @action
  setDeleteImage(_deleteImage) => deleteImage = _deleteImage;
  @action
  setAdDelete(_adDelete) => adDelete = _adDelete;
  @action
  setEditingAd(_editingAd) => editingAd = _editingAd;
  @action
  setAdEdit(_adEdit) => adEdit = _adEdit;
  @action
  setAnnouncementTitle(_announcementTitle) =>
      announcementTitle = _announcementTitle;
  @action
  setAnnouncementDescription(_announcementDescription) =>
      announcementDescription = _announcementDescription;
  @action
  setAnnouncementCategory(_announcementCategory) =>
      announcementCategory = _announcementCategory;
  @action
  setAnnouncementOption(_announcementOption) =>
      announcementOption = _announcementOption;
  @action
  setAnnouncementType(_announcementType) =>
      announcementType = _announcementType;
  @action
  setAnnouncementIsNew(_announcementIsNew) =>
      announcementIsNew = _announcementIsNew;
  @action
  setAnnouncementPrice(_announcementPrice) =>
      announcementPrice = _announcementPrice;
  @action
  setAnnouncementStatusSelected(_announcementStatusSelected) =>
      announcementStatusSelected = _announcementStatusSelected;

  @action
  bool getProgress() => circularIndicator;

  @action
  setAnnouncementValues(QuerySnapshot _qs) {
    activeAds.clear();
    pendingAds.clear();
    expiredAds.clear();

    int _announcementsActive = 0;
    int _announcementsPending = 0;
    int _announcementsExpired = 0;

    List<AnnouncementModel> _activeAds = [];
    List<AnnouncementModel> _pendingAds = [];
    List<AnnouncementModel> _expiredAds = [];

    _qs.docs.forEach((announcement) {
      // print(announcement.data());
      AnnouncementModel announcementModel =
          AnnouncementModel.fromDoc(announcement);

      switch (announcementModel.status) {
        case 'active':
          _announcementsActive += 1;
          _activeAds.add(announcementModel);
          break;
        case 'pending':
          _announcementsPending += 1;
          _pendingAds.add(announcementModel);
          break;
        case 'expired':
          _announcementsExpired += 1;
          _expiredAds.add(announcementModel);
          break;
        default:
      }
    });

    activeAds = _activeAds.asObservable();
    pendingAds = _pendingAds.asObservable();
    expiredAds = _expiredAds.asObservable();

    announcementsActive = _announcementsActive;
    announcementsPending = _announcementsPending;
    announcementsExpired = _announcementsExpired;

    return false;
  }

  @action
  String getCategoryValidateText() {
    // print('val price: $val');
    if (announcementCategory == '' && announcementOption != '') {
      print('Categoria 1');
      return 'Escolha uma categoria';
    }
    if (announcementCategory != '' && announcementOption == '') {
      print('Categoria 2');
      return 'Escolha uma opção';
    }
    if (announcementCategory == '' && announcementOption == '') {
      print('Categoria 3');
      return 'Escolha uma categoria e uma opção';
    }
    return 'Algo de errado não está certo';
  }

  @action
  callDelete({bool removeDelete = false, AnnouncementModel? ad}) {
    if (removeDelete) {
      mainStore.paginateEnable = true;
      setdelete(false);
      Future.delayed(Duration(seconds: 1), () => mainStore.setVisibleNav(true));
    } else {
      adDelete = ad!;
      mainStore.paginateEnable = false;
      mainStore.globalOverlay?.remove();
      mainStore.globalOverlay = null;
      mainStore.setVisibleNav(false);
      setdelete(true);
    }
  }

  @action
  uploadImage() async {
    if (await Permission.storage.request().isGranted) {
      final picker = ImagePicker();
      print('@@@@@@@@@@@@ images.length: ${images.length}  @@@@@@@@@ ');

      final List<XFile>? pickedFile = await picker.pickMultiImage();
      int filesLength = pickedFile!.length;
      print(
          '################## filesLength: $filesLength // images.length: ${images.length}');
      if ((filesLength + images.length) <= 6) {
        pickedFile.forEach((xFile) async {
          final String path = xFile.path;
          final Uint8List bytes = await File(path).readAsBytes();
          // final img.Image image = img.decodeImage(bytes)!;
          images.add(bytes);
        });
        settakePicture(false);
        print('############# pickedFile: $pickedFile #############');
        print('################ XFile: ${pickedFile.first}');
      } else {
        Fluttertoast.showToast(msg: 'Somente 6 imagens são permitidas');
      }
    }
  }

  @action
  pickImage() async {
    if (await Permission.storage.request().isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
          source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
      if (pickedFile != null) {
        print('Images.length: ${images.length}');
        if (images.length < 6) {
          images.add(await File(pickedFile.path).readAsBytes());
        } else {
          Fluttertoast.showToast(msg: 'Somente 6 imagens são permitidas');
        }
      }
    }
  }

  @action
  removeImage() => images.removeAt(imageSelected);

  @action
  bool getValidate() {
    print(
        'option == "$announcementOption" || announcementCategory == "$announcementCategory" || announcementType == "$announcementType"');
    if (editingAd) {
      if (adEdit.option == '') {}
      if (adEdit.category == '') {}
      if (adEdit.type == '') {}
    } else if (announcementOption == '' ||
        announcementCategory == '' ||
        announcementType == '' ||
        images.isEmpty) {
      if (announcementOption == '' || announcementCategory == '') {
        categoryValidateVisible = true;
        print('categoryValidate: $categoryValidateVisible');
      }
      if (announcementType == '') {
        typeValidateVisible = true;
      }
      if (images.isEmpty) {
        imagesEmpty = true;
      }
      return false;
    }
    imagesEmpty = false;
    categoryValidateVisible = false;
    typeValidateVisible = false;
    return true;
  }

  @action
  createAnnouncement(BuildContext context) async {
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());

    Overlay.of(context)?.insert(overlayEntry);

    circularIndicator = true;

    images.forEach((image) {});

    AnnouncementModel announcement = AnnouncementModel(
      title: announcementTitle,
      description: announcementDescription,
      category: announcementCategory,
      option: announcementOption,
      type: announcementType,
      isNew: announcementIsNew,
      price: announcementPrice!,
      paused: false,
      status: 'active',
      images: ['https://t2.tudocdn.net/518979?w=660&h=643'],
    );

    print("Announcement ${AnnouncementModel().toJson(announcement)}");

    DocumentReference announcementRef = await FirebaseFirestore.instance
        .collection('announcements')
        .add(AnnouncementModel().toJson(announcement))
        .then((value) {
      value.update({
        'id': value.id,
        'created_at': FieldValue.serverTimestamp(),
      });
      return value;
    });

    print('announcement.id: ${announcementRef.id}');

    overlayEntry.remove();

    circularIndicator = false;

    await Modular.to
        .pushNamed('/advertisement/announcement-confirm', arguments: {
      'title': announcementTitle,
      'id': announcementRef.id,
    });

    cleanVars();
  }

  @action
  editAnnouncement(BuildContext context) async {
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());

    Overlay.of(context)?.insert(overlayEntry);

    circularIndicator = true;

    images.forEach((image) {});

    await FirebaseFirestore.instance
        .collection('announcements')
        .doc(adEdit.id)
        .update(AnnouncementModel().toJson(adEdit));

    overlayEntry.remove();

    circularIndicator = false;

    cleanVars();

    Modular.to.pop();
  }

  @action
  cleanVars() {
    announcementDescription = '';
    announcementCategory = '';
    announcementOption = '';
    announcementTitle = '';
    announcementType = '';
    announcementIsNew = true;
    announcementPrice = null;
    images.clear();
    imagesEmpty = false;
    categoryValidateVisible = false;
    typeValidateVisible = false;
  }

  @action
  pauseAnnouncement({
    required String adsId,
    required bool pause,
    required BuildContext context,
  }) async {
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)?.insert(overlayEntry);
    // circularIndicator = true;

    await FirebaseFirestore.instance
        .collection('announcements')
        .doc(adsId)
        .update({'paused': pause});

    overlayEntry.remove();
    // circularIndicator = false;
  }

  @action
  highlightAd({
    required String adsId,
    required BuildContext context,
  }) async {
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)?.insert(overlayEntry);
    // circularIndicator = true;

    await FirebaseFirestore.instance
        .collection('announcements')
        .doc(adsId)
        .update({'highlighted': true});

    overlayEntry.remove();
    // circularIndicator = false;
    Fluttertoast.showToast(msg: 'Anúncio destacado com sucesso');
  }

  @action
  deleteAnnouncement({
    required BuildContext context,
    required int reason,
    required double grade,
    required String note,
  }) async {
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)?.insert(overlayEntry);
    // circularIndicator = true;
    String _reasonToDelete = '';

    switch (reason) {
      case 1:
        _reasonToDelete = 'Vendi pela scorefy';
        break;
      case 2:
        _reasonToDelete = 'Vendi por outro meio';
        break;
      case 3:
        _reasonToDelete = 'Desisti de vender';
        break;
      case 4:
        _reasonToDelete = 'Outro motivo';
        break;
      case 5:
        _reasonToDelete = 'Ainda não vendi';
        break;
      default:
    }

    await FirebaseFirestore.instance
        .collection('announcements')
        .doc(adDelete.id)
        .update({
      'status': 'deleted',
      'reason_to_delete': _reasonToDelete,
      'scorefy_grade': grade,
      'scorefy_note': note,
    });

    overlayEntry.remove();
    // circularIndicator = false;
  }
}
