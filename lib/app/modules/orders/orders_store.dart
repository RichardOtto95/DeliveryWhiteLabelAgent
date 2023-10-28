import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:delivery_agent_white_label/app/core/models/address_model.dart';
import 'package:delivery_agent_white_label/app/core/models/directions_model.dart';
import 'package:delivery_agent_white_label/app/core/models/order_model.dart';
import 'package:delivery_agent_white_label/app/modules/main/main_store.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/confirm_popup.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'widgets/network_helper.dart';
part 'orders_store.g.dart';

class OrdersStore = _OrdersStoreBase with _$OrdersStore;

abstract class _OrdersStoreBase with Store {
  final MainStore mainStore = Modular.get();

  @observable
  ObservableList viewableOrderStatus = <String>[].asObservable();
  @observable
  int secondsToCancel = 0;
  @observable
  Timer timer = Timer(const Duration(), () {});
  @observable
  bool canBack = true;
  @observable
  bool hasArrived = false;
  // @observable
  // bool inNavigationMap = false;
  // @observable
  // Order? orderSelected;
  // @observable
  // Seller? seller;
  // @observable
  // Customer? customer;
  // @observable
  // Address? destinationAddress;
  // @observable
  // GoogleMapController? navigationMapController;
  // @observable
  // Circle? circle;
  // @observable
  // ignore: cancel_subscriptions
  // StreamSubscription<Position>? positionSubscription;
  // @observable
  // bool scrollingMap = false;
  // @observable
  // ignore: cancel_subscriptions
  // StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? orderListen;
  @observable
  String storeName = "";
  @observable
  String customerUsername = "";
  @observable
  // ignore: cancel_subscriptions
  StreamSubscription<Position>? positionListen;
  @observable
  Address? destinyAddress;
  @observable
  bool inNavigation = false;

  /* OSM */
  @observable
  MapTileLayerController? mapTileLayerController;
  @observable
  MapZoomPanBehavior? zoomPanBehavior;
  @observable
  List<MapMarker> mapMarkersListOSMap = <MapMarker>[];
  @observable
  List<MapLatLng> polyPointsOSMap = [];
  @observable
  DirectionsOSMap? destinyDirectionOSMap;
  @observable
  MapCircle? mapCircleOSMap;
  @observable
  bool scrollingOSMap = false;

  /* GOOGLE MAP */
  @observable
  GoogleMapController? googleMapController;
  @observable
  Marker? location;
  @observable
  Marker? destination;
  @observable
  DirectionsGoogleMap? info;
  @observable
  Circle? circle;
  @observable
  bool scrollingGoogleMap = false;

  @action
  Future<Uint8List> getMarker(context) async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("./assets/images/car.png");
    Uint8List uint8list = byteData.buffer.asUint8List();
    // Uint8List resizedData = uint8list;
    // IMG.Image img = IMG.decodeImage(uint8list)!;
    // IMG.Image resized = IMG.copyResize(img,
    //     width: (img.width / 10).round(), height: (img.height / 10).round());
    // resizedData = Uint8List.fromList(IMG.encodeJpg(resized));
    // return resizedData;
    return uint8list;
  }

  @action
  void updateMarkerAndCircle(
      context, Position newLocalData, Uint8List imageData) {
    LatLng latLng = LatLng(newLocalData.latitude, newLocalData.longitude);
    location = Marker(
      markerId: const MarkerId("home"),
      position: latLng,
      rotation: newLocalData.heading,
      draggable: false,
      zIndex: 2,
      flat: true,
      anchor: const Offset(0.5, 0.5),
      icon: BitmapDescriptor.fromBytes(imageData),
    );
    circle = Circle(
      circleId: const CircleId("car"),
      radius: newLocalData.accuracy,
      zIndex: 1,
      strokeColor: getColors(context).primary,
      center: latLng,
      fillColor: getColors(context).primary.withAlpha(70),
    );
  }

  // @action
  // Future getUsers(Order orderSelected) async {
  //   // print("SellerId: $sellerId");
  //   seller = Seller.fromDoc((await FirebaseFirestore.instance
  //       .collection("sellers")
  //       .doc(orderSelected.sellerId)
  //       .get()));

  //   // print("customerId: $customerId");
  //   customer = Customer.fromDoc((await FirebaseFirestore.instance
  //       .collection("customers")
  //       .doc(orderSelected.customerId)
  //       .get()));

  //   // print("agentId: ${mainStore.authStore.user!.uid}");
  //   // agent = agent.fromDoc((await FirebaseFirestore.instance
  //   //     .collection("agents")
  //   //     .doc(mainStore.authStore.user!.uid)
  //   //     .get()));
  // }

  // @action
  // addOrderListen(context) {
  //   Stream<DocumentSnapshot<Map<String, dynamic>>> orderStream =
  //       FirebaseFirestore.instance
  //           .collection("agents")
  //           .doc(mainStore.authStore.user!.uid)
  //           .collection("orders")
  //           .doc(mainStore.missionInProgressOrderDoc.id)
  //           .snapshots();

  //   orderListen = orderStream.listen((_orderDoc) async {
  //     Order orderSelected = Order.fromDoc(_orderDoc);
  //     // await getUsers(orderSelected);
  //     if (orderSelected.agentStatus == "GOING_TO_STORE") {
  //       Overlays(context).insertToastOverlay("Missão aceita com sucesso");
  //     }
  //     if (orderSelected.agentStatus == "GOING_TO_CUSTOMER") {
  //       Overlays(context).insertToastOverlay(
  //         "Saiu da parada 1",
  //         color: getColors(context).onBackground.withOpacity(.7),
  //       );
  //     }
  //     if (orderSelected.agentStatus == "IN_CUSTOMER") {
  //       Overlays(context).insertToastOverlay(
  //         "Chegou no cliente",
  //         color: getColors(context).onBackground.withOpacity(.7),
  //       );
  //     }
  //     getMarkers(context, orderSelected);
  //   });
  // }

  // @action
  // Future<void> getMarkers(context, Order orderSelected) async {
  //   scrollingMap = false;
  //   print("agentStatus: ${orderSelected.agentStatus}");

  //   if (orderSelected.agentStatus == "GOING_TO_STORE") {
  //     final selDoc = await FirebaseFirestore.instance
  //         .collection("sellers")
  //         .doc(orderSelected.sellerId)
  //         .get();
  //     destinationAddress = Address.fromDoc(await FirebaseFirestore.instance
  //         .collection("sellers")
  //         .doc(orderSelected.sellerId)
  //         .collection("addresses")
  //         .doc(selDoc.get("main_address"))
  //         .get());
  //   } else if (orderSelected.agentStatus == "NEAR_CUSTOMER" || orderSelected.agentStatus == "GOING_TO_CUSTOMER"  || orderSelected.agentStatus == "IN_CUSTOMER") {
  //     destinationAddress = Address.fromDoc(await FirebaseFirestore.instance
  //         .collection("customers")
  //         .doc(orderSelected.customerId)
  //         .collection("addresses")
  //         .doc(orderSelected.customerAdderessId)
  //         .get());
  //   }

  //   destination = Marker(
  //     markerId: MarkerId("destination"),
  //     infoWindow: InfoWindow(title: "destination"),
  //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
  //     position:
  //         LatLng(destinationAddress!.latitude!, destinationAddress!.longitude!),
  //   );

  //   Position currentPosition = await determinePosition();

  //   Uint8List imageData = await getMarker(context);

  //   updateMarkerAndCircle(currentPosition, imageData);

  //   final LocationSettings locationSettings = LocationSettings(
  //     accuracy: LocationAccuracy.high,
  //     distanceFilter: 10,
  //   );

  //   Directions? _directions = await DirectionRepository().getDirections(
  //       origin: location!.position, destination: destination!.position);

  //   if (_directions != null) {
  //     info = _directions;
  //   }

  //   final geoStream =
  //       Geolocator.getPositionStream(locationSettings: locationSettings);

  //   positionSubscription = geoStream.listen((_position) async {
  //     updateMarkerAndCircle(_position, imageData);
  //     if (location != null && destination != null) {
  //       Directions? _directions = await DirectionRepository().getDirections(
  //           origin: location!.position, destination: destination!.position);

  //       if (_directions != null) {
  //         info = _directions;
  //       }

  //       if (navigationMapController != null && !scrollingMap) {
  //         navigationMapController!
  //             .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //           target: LatLng(_position.latitude, _position.longitude),
  //           bearing: _position.heading,
  //           tilt: 60,
  //           zoom: 18.00,
  //         )));
  //       }
  //       if (googleMapController != null && info != null) {
  //         googleMapController!.animateCamera(
  //             CameraUpdate.newLatLngBounds(info!.bounds, wXD(40, context)));
  //       }
  //     } else {
  //       if (positionSubscription != null) positionSubscription!.cancel();
  //     }
  //   });

  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  //     if (googleMapController != null) {
  //       googleMapController!.animateCamera(
  //           CameraUpdate.newLatLngBounds(info!.bounds, wXD(40, context)));
  //     }
  //   });
  // }

  @action
  Future<Map> getRouteOSMap(Order orderModel, BuildContext context) async {
    print('getRoute: ${orderModel.status}');
    Address _destinyAddress;
    // if (orderModel.agentStatus == "GOING_TO_STORE") {
    //   Overlays(context).insertToastOverlay("Missão aceita com sucesso");
    // }
    // if (orderModel.agentStatus == "GOING_TO_CUSTOMER") {
    //   Overlays(context).insertToastOverlay(
    //     "Saiu da parada 1",
    //     color: getColors(context).onBackground.withOpacity(.7),
    //   );
    // }
    // if (orderModel.agentStatus == "IN_CUSTOMER") {
    //   Overlays(context).insertToastOverlay(
    //     "Chegou no cliente",
    //     color: getColors(context).onBackground.withOpacity(.7),
    //   );
    // }
    // print('Step 0.1');
    DocumentSnapshot customerDoc = await FirebaseFirestore.instance
        .collection("customers")
        .doc(orderModel.customerId)
        .get();

    DocumentSnapshot sellerDoc = await FirebaseFirestore.instance
        .collection("sellers")
        .doc(orderModel.sellerId)
        .get();

    customerUsername = customerDoc['username'];
    storeName = sellerDoc['store_name'];
    if (orderModel.status == "DELIVERY_ACCEPTED") {
      DocumentSnapshot sellerAddressDoc = await sellerDoc.reference
          .collection("addresses")
          .doc(orderModel.sellerAdderessId)
          .get();

      // print('Step 0.2');

      _destinyAddress = Address.fromDoc(sellerAddressDoc);
      // print('Step 0.3');
    } else {
      DocumentSnapshot customerAddressDoc = await customerDoc.reference
          .collection("addresses")
          .doc(orderModel.customerAdderessId)
          .get();

      _destinyAddress = Address.fromDoc(customerAddressDoc);
    }

    destinyAddress = _destinyAddress;

    double? _destinyLat = _destinyAddress.latitude!;
    double? _destinyLng = _destinyAddress.longitude!;

    MapMarker _destinyMapMarker = MapMarker(
      latitude: _destinyLat,
      longitude: _destinyLng,
      child: Icon(
        orderModel.status == "DELIVERY_ACCEPTED"
            ? Icons.store
            : Icons.location_on,
        color: getColors(context).primary,
      ),
    );

    // print('step 1: ${mapTileLayerController != null}');

    if (mapTileLayerController != null) {
      if (mapMarkersListOSMap.isEmpty) {
        mapMarkersListOSMap.add(_destinyMapMarker);
        mapTileLayerController!.insertMarker(0);
      }
    }

    Position currentPosition = await determinePosition();

    // if(inNavigationOSMap){
    //   mapCircle = MapCircle(
    //     center: MapLatLng(currentPosition.latitude, currentPosition.longitude),
    //     radius: 10,
    //     color: getColors(context).primary,
    //   );
    // }

    MapMarker _agentMapMarker = MapMarker(
      latitude: currentPosition.latitude,
      longitude: currentPosition.longitude,
      child: Icon(
        Icons.motorcycle,
        color: getColors(context).primary,
      ),
    );

    // print('step 2');

    if (mapTileLayerController != null) {
      if (mapMarkersListOSMap.length == 1) {
        mapMarkersListOSMap.add(_agentMapMarker);
        mapTileLayerController!.insertMarker(1);
      }
    }

    NetworkHelper network = NetworkHelper(
      startLat: currentPosition.latitude,
      startLng: currentPosition.longitude,
      endLat: _destinyMapMarker.latitude,
      endLng: _destinyMapMarker.longitude,
    );

    Map response = await network.getData();

    // print('response[status]: ${response['status']}');

    if (response['status'] == "SUCCESS") {
      DirectionsOSMap _destinyDirection = response['direction'];
      destinyDirectionOSMap = _destinyDirection;

      if (inNavigation) {
        zoomPanBehavior!.focalLatLng =
            MapLatLng(currentPosition.latitude, currentPosition.longitude);
        if (zoomPanBehavior!.zoomLevel < 18) {
          zoomPanBehavior!.zoomLevel = 18;
        }
      } else {
        zoomPanBehavior!.latLngBounds = _destinyDirection.bounds;
      }

      polyPointsOSMap = _destinyDirection.polyPoints;

      // print('step 3');
    }

    if (positionListen == null) {
      final LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
      // print('step 4');

      final Stream<Position> positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings);

      positionListen = positionStream.listen((Position _userPosition) async {
        // print('step 5');
        MapMarker _userMapMarker = MapMarker(
          latitude: _userPosition.latitude,
          longitude: _userPosition.longitude,
          child: Icon(
            Icons.motorcycle,
            color: getColors(context).primary,
          ),
        );

        if (mapTileLayerController != null) {
          mapMarkersListOSMap[1] = _userMapMarker;
          mapTileLayerController!.updateMarkers([1]);
        }

        NetworkHelper network = NetworkHelper(
          startLat: _userPosition.latitude,
          startLng: _userPosition.longitude,
          endLat: _destinyMapMarker.latitude,
          endLng: _destinyMapMarker.longitude,
        );

        Map response = await network.getData();

        DirectionsOSMap _responseDirection = response['direction-OSM'];
        destinyDirectionOSMap = _responseDirection;

        polyPointsOSMap = _responseDirection.polyPoints;
        if (inNavigation) {
          print('step 6 $scrollingOSMap');
          if (!scrollingOSMap) {
            zoomPanBehavior!.focalLatLng =
                MapLatLng(_userPosition.latitude, _userPosition.longitude);
            // if(zoomPanBehavior!.zoomLevel < 18){
            //   zoomPanBehavior!.zoomLevel = 18;
            // }
          }
        } else {
          zoomPanBehavior!.latLngBounds = _responseDirection.bounds;
        }
        // zoomPanBehavior!.latLngBounds = _responseDirection.bounds;
        // print('step 7');
      });
    }

    return {
      "current-position": currentPosition,
    };
  }

  @action
  Future<Map> getRouteGoogleMap(Order orderModel, BuildContext context) async {
    print('getRoute: ${orderModel.status}');
    Address _destinyAddress;
    // if (orderModel.agentStatus == "GOING_TO_STORE") {
    //   Overlays(context).insertToastOverlay("Missão aceita com sucesso");
    // }
    // if (orderModel.agentStatus == "GOING_TO_CUSTOMER") {
    //   Overlays(context).insertToastOverlay(
    //     "Saiu da parada 1",
    //     color: getColors(context).onBackground.withOpacity(.7),
    //   );
    // }
    // if (orderModel.agentStatus == "IN_CUSTOMER") {
    //   Overlays(context).insertToastOverlay(
    //     "Chegou no cliente",
    //     color: getColors(context).onBackground.withOpacity(.7),
    //   );
    // }
    DocumentSnapshot customerDoc = await FirebaseFirestore.instance
        .collection("customers")
        .doc(orderModel.customerId)
        .get();

    DocumentSnapshot sellerDoc = await FirebaseFirestore.instance
        .collection("sellers")
        .doc(orderModel.sellerId)
        .get();

    customerUsername = customerDoc['username'];
    storeName = sellerDoc['store_name'];
    if (orderModel.status == "DELIVERY_ACCEPTED") {
      DocumentSnapshot sellerAddressDoc = await sellerDoc.reference
          .collection("addresses")
          .doc(orderModel.sellerAdderessId)
          .get();

      _destinyAddress = Address.fromDoc(sellerAddressDoc);
    } else {
      DocumentSnapshot customerAddressDoc = await customerDoc.reference
          .collection("addresses")
          .doc(orderModel.customerAdderessId)
          .get();

      _destinyAddress = Address.fromDoc(customerAddressDoc);
    }

    destinyAddress = _destinyAddress;

    double? _destinyLat = _destinyAddress.latitude!;
    double? _destinyLng = _destinyAddress.longitude!;

    destination = Marker(
      markerId: const MarkerId("destination"),
      infoWindow: const InfoWindow(title: "destination"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      position: LatLng(_destinyLat, _destinyLng),
    );

    Position currentPosition = await determinePosition();

    Uint8List imageData = await getMarker(context);

    updateMarkerAndCircle(context, currentPosition, imageData);

    NetworkHelper network = NetworkHelper(
      startLat: currentPosition.latitude,
      startLng: currentPosition.longitude,
      endLat: _destinyLat,
      endLng: _destinyLng,
    );

    Map response = await network.getData();

    if (response['status'] == "SUCCESS") {
      DirectionsGoogleMap _destinyDirection = response['direction-googleMap'];

      info = _destinyDirection;
      if (googleMapController != null && !scrollingGoogleMap && inNavigation) {
        googleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(currentPosition.latitude, currentPosition.longitude),
          bearing: currentPosition.heading,
          tilt: 60,
          zoom: 18.00,
        )));
      }

      if (googleMapController != null && info != null && !inNavigation) {
        googleMapController!.animateCamera(
            CameraUpdate.newLatLngBounds(info!.bounds, wXD(40, context)));
      }
    }

    if (positionListen == null) {
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

      final Stream<Position> positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings);

      positionListen = positionStream.listen((Position _userPosition) async {
        updateMarkerAndCircle(context, _userPosition, imageData);
        NetworkHelper network = NetworkHelper(
          startLat: currentPosition.latitude,
          startLng: currentPosition.longitude,
          endLat: _destinyLat,
          endLng: _destinyLng,
        );

        Map response = await network.getData();

        if (response['status'] == "SUCCESS") {
          DirectionsGoogleMap _destinyDirection =
              response['direction-googleMap'];

          info = _destinyDirection;
        }

        if (googleMapController != null &&
            !scrollingGoogleMap &&
            inNavigation) {
          googleMapController!
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(_userPosition.latitude, _userPosition.longitude),
            bearing: _userPosition.heading,
            tilt: 60,
            zoom: 18.00,
          )));
        }

        if (googleMapController != null && info != null && !inNavigation) {
          googleMapController!.animateCamera(
              CameraUpdate.newLatLngBounds(info!.bounds, wXD(40, context)));
        }
      });
    }

    return {
      "current-position": currentPosition,
    };
  }

  @action
  Future<void> setCurrentLocation() async {
    if (scrollingOSMap) {
      // Position currentPosition = await determinePosition();
      scrollingOSMap = false;

      // zoomPanBehavior!.focalLatLng = MapLatLng(currentPosition.latitude, currentPosition.longitude);
      if (zoomPanBehavior!.zoomLevel < 15) {
        zoomPanBehavior!.zoomLevel = 15;
      }
    }
    if (scrollingGoogleMap) {
      scrollingGoogleMap = false;
      if (googleMapController != null && inNavigation) {
        Position currentPosition = await determinePosition();

        googleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(currentPosition.latitude, currentPosition.longitude),
          bearing: currentPosition.heading,
          tilt: 60,
          zoom: 18.00,
        )));
      }
    }
  }

  @action
  cleanMissionInProgressVars() {
    // if (positionSubscription != null) positionSubscription!.cancel();
    if (positionListen != null) positionListen!.cancel();
    // positionSubscription = null;
    // orderSelected = null;
    // seller = null;
    // customer = null;
    // location = null;
    // destination = null;
    // destinationAddress = null;
    // googleMapController = null;
    // navigationMapController = null;
    // circle = null;
    // mapCircle = null;
    destinyAddress = null;
    customerUsername = "";
    // destinyDirection = null;
    storeName = "";
    // inNavigationOSMap = false;
    // mapMarkersList = <MapMarker>[];
    // polyPoints = [];
    destinyAddress = null;
    // destinyDirection = null;
    // mapCircle = null;
    // info = null;
    // if (orderListen != null) orderListen!.cancel();
    // orderListen = null;
    // scrollingMap = false;
  }

  // @action
  // bool getInNavigationMap() => inNavigationMap;

  // @action
  // bool getCanBack() => canBack;

  @action
  setOrderStatusView(ObservableList _viewableOrderStatus) =>
      viewableOrderStatus = _viewableOrderStatus;

  // @action
  // setOrderSelected(Order _order) => orderSelected = _order;

  @action
  Future changeOrderStatus(
      Order model, String status, String token, context) async {
    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => const LoadCircularOverlay());

    Overlay.of(context)!.insert(loadOverlay);

    String function = "";

    Map<String, dynamic> object = {
      "id": model.id,
      "seller_id": model.sellerId,
      "customer_id": model.customerId,
    };

    print("status: $status");

    switch (status) {
      case "PROCESSING":
        function = "acceptOrder";
        break;
      case "REFUSED":
        function = "refuseOrder";
        break;
      case "DELIVERY_REQUESTED":
        function = "requestDelivery";
        object = {"orderId": model.id};
        break;
      case "SENDED":
        function = "sendOrder";
        object = {
          "order": {
            "order_id": model.id,
            "seller_id": model.sellerId,
            "customer_id": model.customerId,
          },
          "token": token,
        };
        break;
      case "CANCELED":
        function = "cancelOrder";
        object = {
          "order": {
            "order_id": model.id,
            "seller_id": model.sellerId,
            "customer_id": model.customerId,
          },
          "userId": model.sellerId,
          "userCollection": "sellers"
        };
        break;
      default:
        print("sem caso para o status: $status");
    }

    print("function: $function, Object: $object");
    if (function == '') {
      showToast("Erro ao alterar status");
      loadOverlay.remove();
      return false;
    }

    HttpsCallableResult<dynamic>? result =
        await cloudFunction(function: function, object: object);

    if (result != null && result.data != null) {
      showToast("${result.data['message']}");
    }

    loadOverlay.remove();
  }

  @action
  startNewMission(context) async {
    User? _user = FirebaseAuth.instance.currentUser;
    canBack = false;
    await cloudFunction(
      function: "agentResponse",
      object: {
        "orderId": mainStore.missionInProgressOrderDoc!.id,
        "agentId": _user!.uid,
        "response": {"agent_status": "GOING_TO_STORE"},
      },
    );
    secondsToCancel = 5;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (secondsToCancel == 0) {
        timer.cancel();
      } else {
        secondsToCancel -= 1;
      }
    });
    await Future.delayed(const Duration(seconds: 13), () async {
      await cloudFunction(
        function: "agentResponse",
        object: {
          "orderId": mainStore.missionInProgressOrderDoc!.id,
          "agentId": _user.uid,
          "response": {"agent_status": "NEAR_STORE"},
        },
      );
      hasArrived = true;
    });
    // await Future.delayed(Duration(seconds: 5), () {
    //   buttonText = "Saída parada 1";
    //   buttonEnable = false;
    //   Overlays(context).insertToastOverlay(
    //     "Chegou na parada 1",
    //     color: getColors(context).onBackground.withOpacity(.7),
    //   );
    // });
    // await Future.delayed(Duration(seconds: 5), () {
    //   buttonEnable = true;
    // });
    canBack = true;
  }

  @action
  Future<void> phoneCallWithCustomer(Order orderSelected) async {
    DocumentSnapshot customerDoc = await FirebaseFirestore.instance
        .collection('customers')
        .doc(orderSelected.customerId)
        .get();
    try {
      UrlLauncher.launch("tel: ${customerDoc['phone']}");
    } catch (e) {
      print('phoneCallWithCustomer error');
      print(e);
    }
  }

  @action
  confirmProduct(context) async {
    User? _user = FirebaseAuth.instance.currentUser;

    await cloudFunction(
      function: "agentResponse",
      object: {
        "orderId": mainStore.missionInProgressOrderDoc!.id,
        "agentId": _user!.uid,
        "response": {"agent_status": "NEAR_CUSTOMER"},
      },
    );
  }

  @action
  concludeOrder(context, token) async {
    OverlayEntry _overlay;
    _overlay = OverlayEntry(builder: (context) => const LoadCircularOverlay());
    Overlay.of(context)!.insert(_overlay);
    HttpsCallableResult<dynamic>? response =
        await cloudFunction(function: "concludeOrder", object: {
      "orderId": mainStore.missionInProgressOrderDoc!.id,
      "token": token,
    });
    _overlay.remove();
    var responseData = response!.data;
    print('responseDataresponseData: $responseData');

    if (responseData['status'] == "SUCCESS") {
      mainStore.globalOverlay!.remove();
      mainStore.globalOverlay = null;
      Modular.to.pop();
      cleanMissionInProgressVars();
      mainStore.setVisibleNav(true);
      await mainStore.setPage(0);
      mainStore.priceRateDelivery = responseData['price-rate-delivery'];
      mainStore.missionCompleted = true;
    }
    showToast(responseData['message']);
  }

  @action
  cancelOrder(context) {
    User? _user = FirebaseAuth.instance.currentUser;
    late OverlayEntry _confirmOverlay;
    _confirmOverlay = OverlayEntry(
      builder: (context) {
        return ConfirmPopup(
          height: wXD(150, context),
          text: "Tem certeza que deseja cancelar esta missão?",
          onConfirm: () async {
            OverlayEntry _overlay;
            _overlay =
                OverlayEntry(builder: (context) => const LoadCircularOverlay());
            timer.cancel();
            Overlay.of(context)!.insert(_overlay);
            await cloudFunction(
              function: "agentResponse",
              object: {
                "orderId": mainStore.missionInProgressOrderDoc!.id,
                "agentId": _user!.uid,
                "response": {"status": "DELIVERY_CANCELED"},
              },
            );
            _overlay.remove();
            Modular.to.pop();
          },
          onCancel: () {
            _confirmOverlay.remove();
          },
        );
      },
    );
    Overlay.of(context)!.insert(_confirmOverlay);
  }

  void sendMessage(String userId, String collection) {
    Modular.to.pushNamed('/messages/chat', arguments: {
      "receiverId": userId,
      "receiverCollection": collection,
    });
  }
}
