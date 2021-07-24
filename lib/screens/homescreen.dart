import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phonnytunes_application/controllers/location_controller.dart';
import 'package:phonnytunes_application/screens/map_widgets/confirm_details.dart';
import 'package:phonnytunes_application/screens/map_widgets/driver_found.dart';
import 'package:phonnytunes_application/screens/map_widgets/payment_method_selection.dart';
import 'package:phonnytunes_application/screens/map_widgets/select_destination.dart';
import 'package:phonnytunes_application/screens/map_widgets/select_pickup.dart';
import 'package:phonnytunes_application/screens/map_widgets/trip_widget.dart';
import 'package:phonnytunes_application/screens/profileScreen.dart';
import 'package:phonnytunes_application/screens/settings.dart';
import 'package:phonnytunes_application/widgets/colors.dart';

import 'mapview.dart';

class MapHome extends StatefulWidget {
  @override
  _MapHomeState createState() => _MapHomeState();
}

class _MapHomeState extends State<MapHome> {
  LocationController _locationController = Get.find();
  var scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    var _initialCameraPosition = CameraPosition(
      target: _locationController.center,
      zoom: 15,
    );

    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              compassEnabled: true,
              rotateGesturesEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (controller) =>
                  _locationController.googleMapController = controller,
              markers: _locationController.markers,
            ),
            // Align(
            //   alignment: Alignment.topCenter,
            //   child: MiddleDestination()),
            Positioned(
              top: 50,
              left: 15,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7),
                        )
                      ]),
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.menu,
                          color: Theme.of(context).primaryColor),
                      radius: 20.0),
                ),
              ),
            ),
            // ANCHOR Draggable
            Visibility(
              visible:
                  _locationController.show.value == Show.DESTINATION_SELECTION,
              child: DestinationSelectionWidget(),
            ),

            Visibility(
              visible: _locationController.show.value == Show.PICKUP_SELECTION,
              child: PickupSelectionWidget(
                scaffoldState: scaffoldState,
              ),
            ),
            //  ANCHOR Draggable CONFIRM DETAILS AND TIME
            Visibility(
                visible: _locationController.show.value == Show.ConfirmDetails,
                child: ConfirmDetails(
                  scaffoldState: scaffoldState,
                )),
            //  ANCHOR Draggable PAYMENT METHOD
            Visibility(
                visible: _locationController.show.value ==
                    Show.PAYMENT_METHOD_SELECTION,
                child: PaymentMethodSelectionWidget(
                  scaffoldState: scaffoldState,
                )),
            //  ANCHOR Draggable DRIVER
            Visibility(
                visible: _locationController.show.value == Show.DRIVER_FOUND,
                child: DriverFoundWidget()),

            //  ANCHOR Draggable DRIVER
            Visibility(
                visible: _locationController.show.value == Show.TRIP,
                child: TripWidget()),
          ],
        ),
      ),
      drawer: SafeArea(
        child: Drawer(
          elevation: 0,
          child: ListView(
            children: [
              DrawerHeader(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200]),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                      ),
                      SizedBox(width: 13),
                      Text('Username')
                    ],
                  )),
              ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profiles()));
                  }),
              SizedBox(height: 10),
              ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings()));
                  }),
              SizedBox(height: 10),
              ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/auth');
                  }),
              SizedBox(height: 10),
              ListTile(
                  leading: Icon(Icons.help_center),
                  title: Text('Help'),
                  onTap: () {
                    //Goes to hel screen
                  })
            ],
          ),
        ),
      ),
    );
  }
}
