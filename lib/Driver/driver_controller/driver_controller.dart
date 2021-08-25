import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:phonnytunes_application/Driver/models/ride_Request.dart';
import 'package:phonnytunes_application/Driver/models/route.dart';
import 'package:phonnytunes_application/Driver/services/map_requests.dart';
import 'package:phonnytunes_application/Driver/services/ride_request.dart';
import 'package:phonnytunes_application/Driver/services/rider.dart';
import 'package:phonnytunes_application/Driver/services/user.dart';
import 'package:phonnytunes_application/Driver/models/rider.dart';
import 'package:phonnytunes_application/constants/firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart' as g;
import 'package:location/location.dart'as l;
import 'package:uuid/uuid.dart';


class DriverController extends GetxController {
  static DriverController instance = Get.find();
  final box = GetStorage();

  static const ACCEPTED = 'accepted';
  static const CANCELLED = 'cancelled';
  static const PENDING = 'pending';
  static const EXPIRED = 'expired';
  // ANCHOR: VARIABLES DEFINITION
  Rx<Set<Marker>> _markers = {}.obs as Rx<Set<Marker>>;
  Rx<Set<Polyline>> _poly = {}.obs as Rx<Set<Polyline>>;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  Rx<GoogleMapController> _mapController;
  Rx<Position> position;
  static Rx<LatLng> _center;
  Rx<LatLng> _lastPosition = _center;
  TextEditingController _locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  LatLng get center => _center.value;
  LatLng get lastPosition => _lastPosition.value;
  TextEditingController get locationController => _locationController;
  Set<Marker> get markers => _markers.value;
  Set<Polyline> get poly => _poly.value;
  GoogleMapController get mapController => _mapController.value;
  RouteModel routeModel;
  SharedPreferences prefs;

  l.Location location = new l.Location();
  RxBool hasNewRideRequest = false.obs;
  UserServices _userServices = UserServices();
  RideRequestModel rideRequestModel;
  RequestModelFirebase requestModelFirebase;

  RiderModel riderModel;
  RiderServices _riderServices = RiderServices();
  double distanceFromRider = 0;
  double totalRideDistance = 0;
  StreamSubscription<QuerySnapshot> requestStream;
  RxInt timeCounter = 0.obs;
  RxDouble percentage = 0.0.obs;
  Rx<Timer> periodicTimer;
  RideRequestServices _requestServices = RideRequestServices();
  Rx<Show> show;
  @override
  void onReady() {
    //    _subscribeUser();
    _saveDeviceToken();
    fcm.configure(
//      this callback is used when the app runs on the foreground
        onMessage: handleOnMessage,
//        used when the app is closed completely and is launched using the notification
        onLaunch: handleOnLaunch,
//        when its on the background and opened using the notification drawer
        onResume: handleOnResume);
    _getUserLocation();
    Geolocator().getPositionStream().listen(_userCurrentLocationUpdate);
    super.onReady();
  }

   final FirebaseAuth _auth = FirebaseAuth.instance;
  // ANCHOR LOCATION METHODS
  _userCurrentLocationUpdate(Position updatedPosition) async {
    User currentUser;
        currentUser = _auth.currentUser;
    double distance = await Geolocator().distanceBetween(

        prefs.getDouble('lat'),
        prefs.getDouble('lng'),
        updatedPosition.latitude,
        updatedPosition.longitude);
    Map<String, dynamic> values = {
      "id": prefs.getString("id") ?? currentUser.uid,
      "position": updatedPosition.toJson()
    };
    if (distance >= 50) {
      if(show == Show.RIDER){
        sendRequest(coordinates: requestModelFirebase.getCoordinates());
      }
      _userServices.updateUserData(values);
      await prefs.setDouble('lat', updatedPosition.latitude);
      await prefs.setDouble('lng', updatedPosition.longitude);
    }
  }
   _getUserLocation() async {
    prefs = await SharedPreferences.getInstance();
    position.value = await Geolocator().getCurrentPosition();
    List<g.Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.value.latitude, position.value.longitude);
    _center.value = LatLng(position.value.latitude, position.value.longitude);
    await prefs.setDouble('lat', position.value.latitude);
    await prefs.setDouble('lng', position.value.longitude);
    _locationController.text = placemark[0].name;
    //notifyListeners();
  }
  // ANCHOR MAPS METHODS

  onCreate(GoogleMapController controller) {
    _mapController.value = controller;
    //notifyListeners();
  }

  setLastPosition(LatLng position) {
    _lastPosition.value = position;
    //notifyListeners();
  }

  onCameraMove(CameraPosition position) {
    _lastPosition.value = position.target;
    //notifyListeners();
  }

  void sendRequest({String intendedLocation, LatLng coordinates}) async {
    LatLng origin = LatLng(position.value.latitude, position.value.longitude);

    LatLng destination = coordinates;
    RouteModel route =
        await _googleMapsServices.getRouteByCoordinates(origin, destination);
    routeModel = route;
    addLocationMarker(
        destination, routeModel.endAddress, routeModel.distance.text);
    _center.value = destination;
    destinationController.text = routeModel.endAddress;

    _createRoute(route.points);
   // notifyListeners();
  }

  void _createRoute(String decodeRoute) {
    _poly.value = {};
    var uuid = new Uuid();
    String polyId = uuid.v1();
    poly.add(Polyline(
        polylineId: PolylineId(polyId),
        width: 8,
        color: Colors.black,
        onTap: () {},
        points: _convertToLatLong(_decodePoly(decodeRoute))));
    //notifyListeners();
  }

  List<LatLng> _convertToLatLong(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList =  [];
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  // ANCHOR MARKERS
  addLocationMarker(LatLng position, String destination, String distance) {
    _markers.value = {};
    var uuid = new Uuid();
    String markerId = uuid.v1();
    _markers.value.add(Marker(
        markerId: MarkerId(markerId),
        position: position,
        infoWindow: InfoWindow(title: destination, snippet: distance),
        icon: BitmapDescriptor.defaultMarker));
    //notifyListeners();
  }

  Future<Uint8List> getMarker(BuildContext context) async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/car_topjj.png");
    return byteData.buffer.asUint8List();
  }

  clearMarkers() {
    _markers.value.clear();
    //notifyListeners();
  }

  _saveDeviceToken() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') == null) {
      String deviceToken = await fcm.getToken();
      await prefs.setString('token', deviceToken);
    }
  }

// ANCHOR PUSH NOTIFICATION METHODS
  Future handleOnMessage(Map<String, dynamic> data) async {
    _handleNotificationData(data);
  }

  Future handleOnLaunch(Map<String, dynamic> data) async {
    _handleNotificationData(data);
  }

  Future handleOnResume(Map<String, dynamic> data) async {
    _handleNotificationData(data);
  }

  _handleNotificationData(Map<String, dynamic> data) async {
    hasNewRideRequest.value = true;
    rideRequestModel = RideRequestModel.fromMap(data['data']);
    riderModel = await _riderServices.getRiderById(rideRequestModel.userId);
   // notifyListeners();
  }

// ANCHOR RIDE REQUEST METHODS
  changeRideRequestStatus() {
    hasNewRideRequest.value = false;
    //notifyListeners();
  }

  listenToRequest({String id, BuildContext context}) async {
//    requestModelFirebase = await _requestServices.getRequestById(id);
    print("======= LISTENING =======");
    requestStream = _requestServices.requestStream().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((doc) {
        if (doc.doc.data()['id'] == id) {
          requestModelFirebase = RequestModelFirebase.fromSnapshot(doc.doc);
          //notifyListeners();
          switch (doc.doc.data()['status']) {
            case CANCELLED:
              print("====== CANCELELD");
              break;
            case ACCEPTED:
              print("====== ACCEPTED");
              break;
            case EXPIRED:
              print("====== EXPIRED");
              break;
            default:
              print("==== PEDING");
              break;
          }
        }
      });
    });
  }

  //  Timer counter for driver request
  percentageCounter({String requestId, BuildContext context}) {
   // notifyListeners();
    periodicTimer.value = Timer.periodic(Duration(seconds: 1), (time) {
      timeCounter.value = timeCounter.value + 1;
      percentage.value = timeCounter / 100;
      print("====== GOOOO $timeCounter");
      if (timeCounter.value == 100) {
        timeCounter.value = 0;
        percentage.value = 0;
        time.cancel();
        hasNewRideRequest.value = false;
        requestStream.cancel();
      }
     // notifyListeners();
    });
  }

  acceptRequest({String requestId, String driverId}) {
    hasNewRideRequest.value = false;
    _requestServices.updateRequest(
        {"id": requestId, "status": "accepted", "driverId": driverId});
   // notifyListeners();
  }

  cancelRequest({String requestId}) {
    hasNewRideRequest.value = false;
    _requestServices.updateRequest({"id": requestId, "status": "cancelled"});
    //notifyListeners();
  }

  //  ANCHOR UI METHODS
  changeWidgetShowed({Show showWidget}) {
    show.value = showWidget;
   // notifyListeners();
  }
}

enum Show { RIDER, TRIP }
