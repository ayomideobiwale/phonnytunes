import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:phonnytunes_application/Driver/constants/controller.dart';
import 'package:phonnytunes_application/Driver/constants/stars_method.dart';
import 'package:phonnytunes_application/Driver/driver_controller/driver_controller.dart';
import 'package:phonnytunes_application/Driver/screens/widgets/rider_draggable.dart';
import 'package:phonnytunes_application/widgets/custom_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: GOOGLE_MAPS_API_KEY);

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _deviceToken();
    _updatePosition();
  }

  _deviceToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    UserProvider _user = Provider.of<UserProvider>(context, listen: false);

    if (_user.userModel.token != preferences.getString('token')) {
      Provider.of<UserProvider>(context, listen: false).saveDeviceToken();
    }
  }

  _updatePosition() async {
    //    this section down here will update the drivers current position on the DB when the app is opened
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _id = _prefs.getString("id");
    UserProvider _user = Provider.of<UserProvider>(context, listen: false);
    AppStateProvider _app =
        Provider.of<AppStateProvider>(context, listen: false);
    _user.updateUserData({"id": _id, "position": _app.position.toJson()});
  }

  @override
  Widget build(BuildContext context) {
    // AppStateProvider appState = Provider.of<AppStateProvider>(context);
    // UserProvider userProvider = Provider.of<UserProvider>(context);
    Widget home = SafeArea(
      child: Scaffold(
        key: scaffoldState,
        drawer: Drawer(
            child: ListView(
          children: [
            UserAccountsDrawerHeader(
                accountName: CustomText(
                  text: "",
                  size: 18,
                  weight: FontWeight.bold,
                ),
                accountEmail: CustomText(
                  text: userProvider.userModel?.email ?? "",
                )),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: CustomText(text: "Log out"),
              onTap: () {
                // userProvider.signOut();
                // changeScreenReplacement(context, LoginScreen());
              },
            )
          ],
        )),
        body: Stack(
          children: [
            MapScreen(scaffoldState),
            Positioned(
                top: 60,
                left: MediaQuery.of(context).size.width / 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 17)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: userProvider.userModel?.phone == null
                                ? CircleAvatar(
                                    radius: 30,
                                    child: Icon(
                                      Icons.person_outline,
                                      size: 25,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        userProvider.userModel?.photo),
                                  ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: 'userProvider',
                                  size: 18,
                                  weight: FontWeight.bold,
                                ),
                                stars(
                                    rating: userProvider.userModel.rating,
                                    votes: userProvider.userModel.votes)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            //  ANCHOR Draggable DRIVER
            Visibility(
                visible: driverController.show.value == Show.RIDER,
                child: RiderWidget()),
          ],
        ),
      ),
    );

    switch (driverController.hasNewRideRequest.value) {
      case false:
        return home;
      case true:
        return RideRequestScreen();
      default:
        return home;
    }
  }
}

class MapScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldState;

  MapScreen(this.scaffoldState);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapsPlaces googlePlaces;
  TextEditingController destinationController = TextEditingController();
  Color darkBlue = Colors.brown;
  Color grey = Colors.grey;
  GlobalKey<ScaffoldState> scaffoldSate = GlobalKey<ScaffoldState>();
  String position = "postion";

  @override
  void initState() {
    super.initState();
    scaffoldSate = widget.scaffoldState;
  }

  @override
  Widget build(BuildContext context) {
    //AppStateProvider appState = Provider.of<AppStateProvider>(context);
    return driverController.center == null
        ? CircularProgressIndicator()
        : Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: driverController.center, zoom: 15),
                onMapCreated: driverController.onCreate,
                myLocationEnabled: true,
                mapType: MapType.normal,
                tiltGesturesEnabled: true,
                compassEnabled: false,
                markers: driverController.markers,
                onCameraMove: driverController.onCameraMove,
                polylines: driverController.poly,
              ),
              Positioned(
                top: 10,
                left: 15,
                child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      scaffoldSate.currentState.openDrawer();
                    }),
              ),
            ],
          );
  }
}
