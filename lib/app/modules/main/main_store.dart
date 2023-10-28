import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_agent_white_label/app/core/services/auth/auth_store.dart';
import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
// import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
part 'main_store.g.dart';

class MainStore = _MainStoreBase with _$MainStore;

abstract class _MainStoreBase with Store implements Disposable {
  _MainStoreBase() {
    // authStore.setUser(FirebaseAuth.instance.currentUser);
    userListener();
    addScrollListener();
    // setAgentMap();
  }

  final AuthStore authStore = Modular.get();
  final User? _user = FirebaseAuth.instance.currentUser;


  @observable
  ObservableMap<String, dynamic> agentMap = ObservableMap<String, dynamic>();
  @observable
  PageController pageController = PageController(initialPage: 0);
  @observable
  ScrollController mainScrollController = ScrollController();
  // @observable
  // String currentUserUid = 'fzgn1CYUlBSVnQIqlkDN';
  @observable
  String announcementId = '';
  @observable
  int page = 0;
  @observable
  int tick = 0;
  @observable
  bool visibleNav = true;
  @observable
  bool newMission = false;
  @observable
  bool paginateEnable = true;
  @observable
  bool missionCompleted = false;
  @observable
  num priceRateDelivery = 0;
  @observable
  bool removeOverlay = false;
  @observable
  OverlayEntry? globalOverlay;
  @observable
  Timer timer = Timer(const Duration(seconds: 0), () {});
  @observable
  String addressFormatted = "Localização atual";
  @observable 
  bool? isOnline;
  // @observable
  // ignore: cancel_subscriptions
  // StreamSubscription<Position>? positionSubscription;
  @observable
  Position? userCurrentposition;
  @observable
  DocumentSnapshot? missionInProgressOrderDoc;
  // @observable
  // late DocumentReference missionInProgressOrderDoc = FirebaseFirestore.instance
  //     .collection("agents")
  //     .doc(_user!.uid)
  //     .collection("orders")
  //     .doc();
  @observable
  late Stream<QuerySnapshot<Map<String, dynamic>>> ordersSnapshot =
      FirebaseFirestore.instance
          .collection("agents")
          .doc(_user!.uid)
          .collection("orders")
          .snapshots();
  @observable
  DateTime nowDate = DateTime.now();
  @observable
  // ignore: cancel_subscriptions
  StreamSubscription<Position>? positionListen;
  @observable
  // ignore: cancel_subscriptions
  StreamSubscription<DocumentSnapshot>? agentListener;

  @action
  setOnline(bool _online) async {
    User? _user = FirebaseAuth.instance.currentUser;
    if (_online) {
      PermissionStatus perStat = await Permission.location.request();

      print("perStat.isGranted: ${perStat.isGranted}");

      if (perStat.isGranted) {
        isOnline = true;
        FirebaseFirestore.instance
          .collection("agents")
          .doc(_user!.uid)
          .update({"online": true});
      } else {
        showToast("Habilite a localização para ficar online");
      }
    } else {
      isOnline = false;
      FirebaseFirestore.instance
        .collection("agents")
        .doc(_user!.uid)
        .update({"online": false});
    }
  }

  // @action
  // setAgentMap() async {
  //   final agentSnap = FirebaseFirestore.instance
  //       .collection("agents")
  //       .doc(authStore.user!.uid)
  //       .snapshots();

  //   agentSnap.listen((_agent) {
  //     agentMap = _agent.data()!.asObservable();
  //     if (_agent.get("online")) {
  //       if (positionSubscription == null) setPosition();
  //     }
  //   });
  // }

  // @action
  // Future<bool> setPosition() async {
  //   print('setPosition setPosition setPosition');
  //   PermissionStatus perStat = await Permission.location.request();

  //   print("perStat.isGranted: ${perStat.isGranted}");

  //   if (perStat.isGranted) {
  //     Stream<Position> streamPosition = Geolocator.getPositionStream();

  //     positionSubscription = streamPosition.listen((_position) {
  //       // position = _position;
  //       if (authStore.user == null) {
  //         positionSubscription!.cancel();
  //       } else {
  //         if (agentMap["online"]) {
  //           FirebaseFirestore.instance
  //               .collection("agents")
  //               .doc(authStore.user!.uid)
  //               .update({
  //             "position": {
  //               "latitude": _position.latitude,
  //               "longitude": _position.longitude,
  //             }
  //           });
  //         }
  //       }
  //     });
  //   }
  //   return await Permission.location.request().isDenied;
  // }

  @action
  addNewOrderListener() {
    // ordersSnapshot = FirebaseFirestore.instance
    //     .collection("agents")
    //     .doc(authStore.user!.uid)
    //     .collection("orders")
    //     .snapshots();
    print("######### Listeneeeeeeeeeer addNewOrderListener ############");

    ordersSnapshot.listen((event) {
      print("######### eveeeeeeeent: ${event.docs.length} ############");

      for (var orderDoc in event.docs) {
        print("######### orderDoc.get(status): ${orderDoc.get("status")} ############");      
        if (orderDoc.get("status") == "DELIVERY_REQUESTED") {
          print("######### Delivery Requested ############");
          setNewMission(orderDoc);
        }
      }
    });
  }

  @action
  setGlobalOverlay(OverlayEntry _menuOverlay, context) {
    if (globalOverlay == null) {
      globalOverlay = _menuOverlay;
      Overlay.of(context)?.insert(globalOverlay ?? _menuOverlay);
    } else {
      globalOverlay?.dispose();
      globalOverlay = _menuOverlay;
      Overlay.of(context)?.insert(globalOverlay ?? _menuOverlay);
    }
  }

  @action
  addScrollListener() {
    mainScrollController.addListener(() {
      if (mainScrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setVisibleNav(false);
      } else if (mainScrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setVisibleNav(true);
      }
    });
  }

  @action
  userListener() async{
    PermissionStatus locationPermission = await Permission.location.request();
    if(locationPermission.isGranted){
      User? _user = FirebaseAuth.instance.currentUser;
      // if(_user == null){
      //   if(agentListener != null){
      //     agentListener!.cancel();
      //     agentListener = null;
      //   }
      //   if(positionListen != null){
      //     positionListen!.cancel();
      //     positionListen = null;
      //   }
      // }

      Stream<DocumentSnapshot<Map<String, dynamic>>> agentSnap = FirebaseFirestore.instance
        .collection("agents")
        .doc(_user!.uid)
        .snapshots();

      agentListener = agentSnap.listen((_agent) async{
        await _user.reload();
        if(_user == null){
          agentListener!.cancel();
          if(positionListen != null){
            positionListen!.cancel();
            positionListen = null;
          }
        } else {
          isOnline ??= _agent.data()!['online'];
          agentMap = _agent.data()!.asObservable();
          // print('_agent.get("online"): ${_agent.get("online")}');

          if (_agent.get("online")) {
            // print('positionListen == null: ${positionListen == null}');
            if (positionListen == null){
              final LocationSettings locationSettings = LocationSettings(
                accuracy: LocationAccuracy.high,
                distanceFilter: 10,
              );

              final Stream<Position> positionStream =
                  Geolocator.getPositionStream(locationSettings: locationSettings);
              // print('initial step');
              positionListen = positionStream.listen((Position _userPosition) async {
                // print("currentPosition: ${_userPosition.latitude}, ${_userPosition.longitude}");
                try {
                  userCurrentposition = _userPosition;
                  // print("currentPosition: ${_userPosition.latitude}, ${_userPosition.longitude}");
                  List addresses = await placemarkFromCoordinates(_userPosition.latitude, _userPosition.longitude);
                  // print('addresses: $addresses');
                  // print('addresses[0]: ${addresses[0]}');
                  // print('addresses[0].name: ${addresses[0].name}');
                  // try {                    
                  //   print('addresses[0].name: ${addresses[0].sublocality}');
                  // } catch (e) {
                  //   print(e);
                  //   print('error on sub try');
                  // }
                  addressFormatted = addresses[0].name;
                  addressFormatted += ", " + addresses[0].street;
                  // addressFormatted += ", " + addresses[0].sublocality;
                  addressFormatted += ", " + addresses[0].postalCode;
                  addressFormatted += ", " + addresses[0].administrativeArea;
                  
                  FirebaseFirestore.instance
                    .collection("agents")
                    .doc(_user.uid)
                    .update({
                      "position": {
                        "latitude": _userPosition.latitude,
                        "longitude": _userPosition.longitude,
                      }
                    },
                  );

                  // print("final step");

                  // GeoData geoDataAddress = await Geocoder2.getDataFromCoordinates(
                  //   latitude: _userPosition.latitude,
                  //   longitude: _userPosition.longitude,
                  //   googleMapApiKey: "AIzaSyDc7Hs6X0sdZFaWGcA-AxzoC93ZtCSM6To",
                  // );
                  // // addressFormatted = addresses.address;
                  // print('geoDataAddress: ${geoDataAddress.address}');
                } catch (e) {
                  print('error on try');
                  print(e);
                } 
              });
            }
          } else {
            if(positionListen != null){
              positionListen!.cancel();
              positionListen = null;
            }
          }        
        }
      });
    }
  }

  @action
  setVisibleNav(_visibleNav) => visibleNav = _visibleNav;

  @override
  void dispose() {
    pageController.dispose();
    mainScrollController.removeListener(() {});
    mainScrollController.dispose();
    
    if(positionListen != null){
      positionListen!.cancel();
      positionListen = null;
    }
    if(positionListen != null){
      positionListen!.cancel();
      positionListen = null;
    }
  }

  @action
  setPage(_page) async {
    if (paginateEnable) {
      if (globalOverlay != null) {
        globalOverlay?.remove();
        globalOverlay = null;
      }
      await pageController.animateToPage(
        _page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.decelerate,
      );
      page = _page;
    }
  }

  @action
  setNewMission(DocumentSnapshot orderDoc) async {
    // missionInProgressOrderDoc = orderDoc.reference;
    User? _user = FirebaseAuth.instance.currentUser;
    setVisibleNav(false);
    missionInProgressOrderDoc = orderDoc;
    newMission = true;
    timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      // print("ticksss: $tick");
      if (timer.tick >= 1000) {
        tick = 0;
        timer.cancel();
      } else {
        tick = timer.tick * 10;
      }
    });
    await Future.delayed(const Duration(seconds: 1));
    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      // print("tick: ${timer.tick}");
      if (timer.tick >= 6000) {
        tick = 0;
        newMission = false;
        cloudFunction(
          function: "agentResponse",
          object: {
            "orderId": orderDoc.id,
            "agentId": _user!.uid,
            "response": {"status": "TIMEOUT"},
          },
        );
        setVisibleNav(true);
        timer.cancel();
      } else {
        tick = timer.tick;
      }
    });
  }

  @action
  setAnnouncementId(_announcementId) => announcementId = _announcementId;
}
