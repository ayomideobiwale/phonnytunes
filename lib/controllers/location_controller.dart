import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phonnytunes_application/constants/assets_path.dart';
import 'package:phonnytunes_application/constants/firebase.dart';
import 'package:phonnytunes_application/model/driver.dart';
import 'package:phonnytunes_application/model/map_route.dart';
import 'package:phonnytunes_application/model/ride_Request.dart';
import 'package:phonnytunes_application/model/user.dart';
import 'package:phonnytunes_application/services/drivers.dart';
import 'package:phonnytunes_application/services/google_request.dart';
import 'package:phonnytunes_application/services/payment-services.dart';
import 'package:phonnytunes_application/services/ride_requests.dart';
import 'package:phonnytunes_application/widgets/colors.dart';
import 'package:phonnytunes_application/widgets/custom_text.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart' as g;

class LocationController extends GetxController {
  static LocationController instance = Get.find();
  RxString userLocation = "".obs;
  RxString userAddress = "".obs;
  Position _currentPosition;
  final box = GetStorage();
  TextEditingController destinationController = TextEditingController();
  TextEditingController pickupLocationController = TextEditingController();
  static const ACCEPTED = 'accepted';
  static const CANCELLED = 'cancelled';
  static const PENDING = 'pending';
  static const EXPIRED = 'expired';
  static const PICKUP_MARKER_ID = 'pickup';
  static const LOCATION_MARKER_ID = 'location';
  static const DRIVER_AT_LOCATION_NOTIFICATION = 'DRIVER_AT_LOCATION';
  static const REQUEST_ACCEPTED_NOTIFICATION = 'REQUEST_ACCEPTED';
  static const TRIP_STARTED_NOTIFICATION = 'TRIP_STARTED';

  @override
  void onReady() {
    super.onReady();
       fcm.configure(
//      this callback is used when the app runs on the foreground
        onMessage: handleOnMessage,
//        used when the app is closed completely and is launched using the notification
        onLaunch: handleOnLaunch,
//        when its on the background and opened using the notification drawer
        onResume: handleOnResume);

    _getCurrentLocation();
    _setCustomMapPin();
    _getUserLocation();
  }

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    await Geolocator().getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            )
        .then((Position position) {
      _currentPosition = position;
      print(_currentPosition);
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<g.Placemark> placemarks = await Geolocator().placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      g.Placemark place = placemarks[0];

      userAddress.value = "${place.locality}, ${place.country}";
      print(userAddress.value);
    } catch (e) {
      print(e);
    }
  }

  BuildContext mainContext;

  //  Driver request related variables
  DriverService _driverService = DriverService();
  Rx<RideRequestModel> rideRequestModel;
  Rx<DriverModel> driverModel;
  RxBool lookingForDriver = false.obs;
  RxBool alertsOnUi = false.obs;
  RxBool driverFound = false.obs;
  RxBool driverArrived = false.obs;
  RideRequestServices _requestServices = RideRequestServices();
  Timer periodicTimer;
  //  this variable will listen to the status of the ride request
  StreamSubscription<QuerySnapshot> requestStream;
  // this variable will keep track of the drivers position before and during the ride
  StreamSubscription<QuerySnapshot> driverStream;
//  this stream is for all the driver on the app
  StreamSubscription<List<DriverModel>> allDriversStream;

  // Everything that has to do with the map
  // static const PICKUP_MARKER_ID = 'pickup';
  // static const LOCATION_MARKER_ID = 'location';
  GoogleMapController googleMapController;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  static Rx<LatLng> _center = LatLng(0, 0).obs;
  Position position;
  Set<Marker> _markers = {};
  //  this polys will be displayed on the map
  Set<Polyline> _poly = {};
  // this polys temporarely store the polys to destination
  // ignore: unused_field
  Set<Polyline> _routeToDestinationPolys = {};
  Rx<Show> show = Show.DESTINATION_SELECTION.obs;
  RxInt timeCounter = 0.obs;
  RxDouble percentage = 0.0.obs;
  RxString requestedDestination = "".obs;

  RxString requestStatus = "".obs;
  RxDouble requestedDestinationLat = 0.0.obs;

  RxDouble requestedDestinationLng = 0.0.obs;

  Rx<LatLng> pickupCoordinates = LatLng(0, 0).obs;
  Rx<LatLng> destinationCoordinates = LatLng(0, 0).obs;
  Rx<double> ridePrice = 0.0.obs;
  RouteModel routeModel;
  // ignore: unused_field
  LatLng _lastPosition = _center.value;
  RxString  notificationType = "".obs;

  LatLng get center => _center.value;
  Set<Marker> get markers => _markers;
  Set<Polyline> get poly => _poly;

  //   taxi pin
  BitmapDescriptor carPin;

  //   location pin
  BitmapDescriptor locationPin;

  _setCustomMapPin() async {
    carPin = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), car);

    locationPin = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), pin);
  }

  Future<Position> _getUserLocation() async {
    position = await Geolocator().getCurrentPosition();
    print(
        "==============================>${position.latitude}, ${position.longitude}");

    List<g.Placemark> placemark =
        await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);

    if (box.read('country') == null) {
      String country = placemark[0].isoCountryCode.toLowerCase();
      box.write('country', country);
    }

    _center.value = LatLng(position.latitude, position.longitude);
    print(
        "=========passed==center===================>${_center.value.latitude}, ${_center.value.longitude}");
    return position;
  }

  changeRequestedDestination({String reqDestination, double lat, double lng}) {
    requestedDestination.value = reqDestination;
    requestedDestinationLat.value = lat;
    requestedDestinationLng.value = lng;
    print("===========change requested destination==========");
    print(requestedDestination.value);
    print(requestedDestinationLat.value);
    print(requestedDestinationLng.value);
  }

  void updateDestination({String destination}) {
    destinationController.text = destination;
    print("===========update destination==========");
    print(destinationController.text);
  }

  setDestination({LatLng coordinates}) {
    destinationCoordinates.value = coordinates;
    print("===========set destination==========");
    print(destinationCoordinates.value);
  }

  setPickCoordinates({LatLng coordinates}) {
    pickupCoordinates.value = coordinates;
    print("===========set pick up coordinates==========");
    print(pickupCoordinates.value);
  }

  addPickupMarker(LatLng position) {
    if (pickupCoordinates == null) {
      pickupCoordinates.value = position;
      print("===========add pickup marker==========");
      print(pickupCoordinates.value);
    }
    _markers.add(Marker(
        markerId: MarkerId(PICKUP_MARKER_ID),
        position: position,
        anchor: Offset(0, 0.85),
        zIndex: 3,
        infoWindow: InfoWindow(title: "YOU", snippet: "Your location"),
        icon: locationPin));
  }

  changePickupLocationAddress({String address}) async {
    pickupLocationController.text = address;
    if (pickupCoordinates != null) {
      _center = pickupCoordinates;
    }
  }

  changeWidgetShowed({Show showWidget}) {
    show.value = showWidget;
    print("Change Widget");
  }

  // ANCHOR: MARKERS AND POLYS
  _addLocationMarker(LatLng position, String distance) {
    _markers.add(Marker(
        markerId: MarkerId(LOCATION_MARKER_ID),
        position: position,
        anchor: Offset(0, 0.85),
        infoWindow:
            InfoWindow(title: destinationController.text, snippet: distance),
        icon: locationPin));
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
    var lList = [];
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

  clearPoly() {
    _poly.clear();
  }

  _createRoute(String decodeRoute, {Color color}) {
    clearPoly();
    var uuid = new Uuid();
    String polyId = uuid.v1();
    _poly.add(
      Polyline(
        polylineId: PolylineId(polyId),
        width: 12,
        color: color ?? ColorConstants.primaryColor,
        onTap: () {},
        points: _convertToLatLong(
          _decodePoly(decodeRoute),
        ),
      ),
    );
  }

  Future sendRequest({LatLng origin, LatLng destination}) async {
    LatLng _org;
    LatLng _dest;

    if (origin == null && destination == null) {
      _org = pickupCoordinates.value;
      _dest = destinationCoordinates.value;
    } else {
      _org = origin;
      _dest = destination;
    }

    RouteModel route =
        await _googleMapsServices.getRouteByCoordinates(_org, _dest);
    routeModel = route;

    if (origin == null) {
      ridePrice.value =
          double.parse((routeModel.distance.value / 500).toStringAsFixed(2));
    }
    List<Marker> mks = _markers
        .where((element) => element.markerId.value == "location")
        .toList();
    if (mks.length >= 1) {
      _markers.remove(mks[0]);
    }
// ! another method will be created just to draw the polys and add markers
    _addLocationMarker(destinationCoordinates.value, routeModel.distance.text);
    _center = destinationCoordinates;
    if (_poly != null) {
      _createRoute(route.points, color: ColorConstants.primaryColor);
    }
    _createRoute(
      route.points,
    );
    _routeToDestinationPolys = _poly;
  }

  onCameraMove(CameraPosition position) {
    //  MOVE the pickup marker only when selecting the pickup location
    if (show.value == Show.PICKUP_SELECTION) {
      _lastPosition = position.target;
      changePickupLocationAddress(address: "loading...");
      if (_markers.isNotEmpty) {
        _markers.forEach((element) async {
          if (element.markerId.value == PICKUP_MARKER_ID) {
            _markers.remove(element);
            pickupCoordinates.value = position.target;
            addPickupMarker(position.target);
            List<g.Placemark> placemark = await Geolocator().placemarkFromCoordinates(
                position.target.latitude, position.target.longitude);
            pickupLocationController.text = placemark[0].name;
          }
        });
      }
    }
  }

  listenToRequest({String id, BuildContext context}) async {
    requestStream = _requestServices.requestStream().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((doc) async {
        if (doc.doc.get("id") == id) {
          rideRequestModel.value = RideRequestModel.fromSnapshot(doc.doc);
          // notifyListeners();
          switch (doc.doc.get("status")) {
            case CANCELLED:
              break;
            case ACCEPTED:
              if (lookingForDriver.value) Navigator.pop(context);
              lookingForDriver.value = false;
              driverModel.value =
                  await _driverService.getDriverById(doc.doc.get('driverId'));
              periodicTimer.cancel();
              clearPoly();
              _stopListeningToDriversStream();
              _listenToDriver();
              show.value = Show.DRIVER_FOUND;
              // notifyListeners();

              // showDriverBottomSheet(context);
              break;
            case EXPIRED:
              showRequestExpiredAlert(context);
              break;
            default:
              break;
          }
        }
      });
    });
  }

  requestDriver(
      {UserData user,
      double lat,
      double lng,
      BuildContext context,
      Map distance}) {
    alertsOnUi.value = true;
    // notifyListeners();
    var uuid = new Uuid();
    String id = uuid.v1();
    // creates the ride request via server side
    _requestServices.createRideRequest(
        id: id,
        userId: user.uid,
        username: user.name,
        distance: distance,
        destination: {
          "address": requestedDestination,
          "latitude": requestedDestinationLat,
          "longitude": requestedDestinationLng
        },
        position: {
          "latitude": lat,
          "longitude": lng
        });
    // listen for changes in case a driver accepts to drive
    listenToRequest(id: id, context: context);
    percentageCounter(requestId: id, context: context);
  }

  clearMarkers() {
    _markers.clear();
    // notifyListeners();
  }

  cancelRequest() {
    lookingForDriver.value = false;
    _requestServices.updateRequest(
        {"id": rideRequestModel.value.id, "status": "cancelled"});
    periodicTimer.cancel();
  }

  void _addDriverMarker({LatLng position, double rotation, String driverId}) {
    var uuid = new Uuid();
    String markerId = uuid.v1();
    _markers.add(Marker(
        markerId: MarkerId(markerId),
        position: position,
        rotation: rotation,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(1, 1),
        icon: carPin));
  }

  _updateMarkers(List<DriverModel> drivers) {
//    this code will ensure that when the driver markers are updated the location marker wont be deleted
    List<Marker> locationMarkers = _markers
        .where((element) => element.markerId.value == 'location')
        .toList();
    clearMarkers();
    if (locationMarkers.length > 0) {
      _markers.add(locationMarkers[0]);
    }

//    here we are updating the drivers markers
    drivers.forEach((DriverModel driver) {
      _addDriverMarker(
          driverId: driver.id,
          position: LatLng(driver.position.lat, driver.position.lng),
          rotation: driver.position.heading);
    });
  }

  _updateDriverMarker(Marker marker) {
    _markers.remove(marker);
    sendRequest(
        origin: pickupCoordinates.value,
        destination: driverModel.value.getPosition());
    // notifyListeners();
    _addDriverMarker(
        position: driverModel.value.getPosition(),
        rotation: driverModel.value.position.heading,
        driverId: driverModel.value.id);
  }

// ANCHOR LISTEN TO DRIVER
  _listemToDrivers() {
    allDriversStream = _driverService.getDrivers().listen(_updateMarkers);
  }

  _listenToDriver() {
    driverStream = _driverService.driverStream().listen((event) {
      event.docChanges.forEach((change) async {
        if (change.doc.get("id") == driverModel.value.id) {
          driverModel.value = DriverModel.fromSnapshot(change.doc);
          // code to update marker
//          List<Marker> _m = _markers
//              .where((element) => element.markerId.value == driverModel.id).toList();
//          _markers.remove(_m[0]);
          clearMarkers();
          sendRequest(
              origin: pickupCoordinates.value,
              destination: driverModel.value.getPosition());
          if (routeModel.distance.value <= 200) {
            driverArrived.value = true;
          }
          // notifyListeners();

          _addDriverMarker(
              position: driverModel.value.getPosition(),
              rotation: driverModel.value.position.heading,
              driverId: driverModel.value.id);
          addPickupMarker(pickupCoordinates.value);
          // _updateDriverMarker(_m[0]);
        }
      });
    });

    show.value = Show.PAYMENT_METHOD_SELECTION;
    // notifyListeners();
  }

  _stopListeningToDriversStream() {
//    _clearDriverMarkers();
    allDriversStream.cancel();
  }

//  Timer counter for driver request
  percentageCounter({String requestId, BuildContext context}) {
    lookingForDriver.value = true;
    // notifyListeners();
    periodicTimer = Timer.periodic(Duration(seconds: 1), (time) {
      timeCounter = timeCounter + 1;
      percentage.value = timeCounter / 100;
      print("====== GOOOO $timeCounter");
      if (timeCounter.value == 100) {
        timeCounter.value = 0;
        percentage.value = 0;
        lookingForDriver.value = false;
        _requestServices.updateRequest({"id": requestId, "status": "expired"});
        time.cancel();
        if (alertsOnUi.value) {
          Navigator.pop(context);
          alertsOnUi.value = false;
          // notifyListeners();
        }
        requestStream.cancel();
      }
      // notifyListeners();
    });
  }

  showRequestExpiredAlert(BuildContext context) {
    if (alertsOnUi.value) Navigator.pop(context);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          text: "DRIVERS NOT FOUND! \n TRY REQUESTING AGAIN")
                    ],
                  )),
            ),
          );
        });
  }

  // ANCHOR UI METHODS
  changeMainContext(BuildContext context) {
    mainContext = context;
    // notifyListeners();
  }
   //ANCHOR PUSH NOTIFICATION METHODS
  Future handleOnMessage(Map<String, dynamic> data) async {
    print("=== data = ${data.toString()}");
    notificationType.value = data['data']['type'];

    if (notificationType.value == DRIVER_AT_LOCATION_NOTIFICATION) {
    } else if (notificationType.value == TRIP_STARTED_NOTIFICATION) {
      show.value = Show.TRIP;
      sendRequest(
          origin: pickupCoordinates.value, destination: destinationCoordinates.value);
     // notifyListeners();
    } else if (notificationType.value == REQUEST_ACCEPTED_NOTIFICATION) {}
   // notifyListeners();
  }

  Future handleOnLaunch(Map<String, dynamic> data) async {
    notificationType = data['data']['type'];
    if (notificationType.value == DRIVER_AT_LOCATION_NOTIFICATION) {
    } else if (notificationType.value == TRIP_STARTED_NOTIFICATION) {
    } else if (notificationType.value == REQUEST_ACCEPTED_NOTIFICATION) {}
    driverModel.value = await _driverService.getDriverById(data['data']['driverId']);
    _stopListeningToDriversStream();

    _listenToDriver();
   // notifyListeners();
  }

  Future handleOnResume(Map<String, dynamic> data) async {
    notificationType = data['data']['type'];

    _stopListeningToDriversStream();
    if (notificationType.value == DRIVER_AT_LOCATION_NOTIFICATION) {
    } else if (notificationType.value == TRIP_STARTED_NOTIFICATION) {
    } else if (notificationType.value == REQUEST_ACCEPTED_NOTIFICATION) {}

    if (lookingForDriver.value) Navigator.pop(mainContext);
    lookingForDriver.value = false;
    driverModel.value = await _driverService.getDriverById(data['data']['driverId']);
    periodicTimer.cancel();
   // notifyListeners();
  }

  //Stripe payment
  payViaExistingCard({BuildContext context, dynamic card, var bidprice}) async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: 'please wait...');
    await dialog.show();
    var expiryArr = card['expiryDate'].split('/');
    CreditCard stripeCard = CreditCard(
      number: card['cardNumber'],
      expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),
    );
    var response = await StripService.payViaExixtingCard(
        amount: "${bidprice.toString()}00", currency: 'USD', card: stripeCard);
    await dialog.hide();

    Scaffold.of(context)
        .showSnackBar(SnackBar(
          content: Text(response.message),
          duration: new Duration(milliseconds: 1200),
        ))
        .closed
        .then((_) {
      show.value = Show.DRIVER_FOUND;
    });
  }

  payViaNewCard({BuildContext context, var bidPrice}) async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: 'please wait...');
    await dialog.show();
    var response = await StripService.payWithNewCard(
        amount: "${bidPrice.toString()}00", currency: 'USD');
    await dialog.hide();
    Scaffold.of(context)
        .showSnackBar(SnackBar(
          content: Text(response.message),
          duration: new Duration(
              milliseconds: response.success == true ? 1200 : 3000),
        ))
        .closed
        .then((_) {
      show.value = Show.DRIVER_FOUND;
    });
  }
}

// * THIS ENUM WILL CONTAIN THE DRAGGABLE WIDGET TO BE DISPLAYED ON THE MAIN SCREEN
enum Show {
  DESTINATION_SELECTION,
  PICKUP_SELECTION,
  ConfirmDetails,
  PAYMENT_METHOD_SELECTION,
  DRIVER_FOUND,
  TRIP
}
