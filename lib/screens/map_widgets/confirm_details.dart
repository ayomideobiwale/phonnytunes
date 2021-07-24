import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:phonnytunes_application/controllers/location_controller.dart';
import 'package:phonnytunes_application/controllers/user_controller.dart';
import 'package:phonnytunes_application/widgets/custom_text.dart';

class ConfirmDetails extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldState;

  const ConfirmDetails({Key key, this.scaffoldState}) : super(key: key);

  @override
  _ConfirmDetailsState createState() => _ConfirmDetailsState();
}

class _ConfirmDetailsState extends State<ConfirmDetails> {
  List<String> selectedItemValue = [];
  LocationController _locationController = Get.find();
  UserController _userController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //AppStateProviders appState = Provider.of<AppStateProviders>(context);
    //UserProviders userProvider = Provider.of<UserProviders>(context);
    return DraggableScrollableSheet(
        initialChildSize: 0.28,
        minChildSize: 0.28,
        builder: (BuildContext context, myscrollController) {
          return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        offset: Offset(3, 2),
                        blurRadius: 7)
                  ]),
              child: ListView(controller: myscrollController, children: [
                Icon(
                  Icons.remove,
                  size: 50,
                  color: Colors.grey,
                ),

                // Column(
                //   children: [
                //     Padding(
                //         padding: const EdgeInsets.symmetric(
                //             horizontal: 24.0, vertical: 20.0),
                //         child: Container(
                //             height: 120.0,
                //             decoration: BoxDecoration(
                //                 color: Colors.white,
                //                 borderRadius: BorderRadius.circular(15.0),
                //                 boxShadow: [
                //                   BoxShadow(
                //                     color: Colors.black12,
                //                     blurRadius: 16.0,
                //                     spreadRadius: 0.5,
                //                     offset: Offset(0.7, 0.7),
                //                   ),
                //                 ]),
                //             child: Stack(
                //               children: [
                //                 Align(
                //                   alignment: Alignment.topLeft,
                //                   child: Container(
                //                     child: Column(
                //                       children: <Widget>[
                //                         Padding(
                //                           padding: EdgeInsets.only(
                //                               top: 15.0, bottom: 10.0),
                //                           child: Container(
                //                               width: 10,
                //                               height: 10,
                //                               decoration: BoxDecoration(
                //                                   shape: BoxShape.circle,
                //                                   color: Theme.of(context)
                //                                       .primaryColor)),
                //                         ),
                //                         Padding(
                //                           padding:
                //                               const EdgeInsets.only(left: 9),
                //                           child: Container(
                //                             height: 45,
                //                             width: 2,
                //                             color: primary,
                //                           ),
                //                         ),
                //                         Icon(
                //                           Icons.arrow_drop_down,
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //                 Padding(
                //                   padding: EdgeInsets.only(
                //                       left: 25.0, top: 5.0, bottom: 5.0),
                //                   child: Column(
                //                     children: [
                //                       SizedBox(height: 5.0),
                //                       Row(
                //                         children: [
                //                           Expanded(
                //                             child: Padding(
                //                                 padding: EdgeInsets.all(3.0),
                //                                 child: TextField(
                //                                   decoration: InputDecoration(
                //                                     hintText: 'PickUp Location',
                //                                     fillColor: Colors.white,
                //                                     filled: true,
                //                                     border: InputBorder.none,
                //                                     isDense: true,
                //                                     contentPadding:
                //                                         EdgeInsets.only(
                //                                             left: 11.0,
                //                                             top: 4.0,
                //                                             bottom: 4.0),
                //                                   ),
                //                                 )),
                //                           )
                //                         ],
                //                       ),
                //                       SizedBox(height: 5.0),
                //                       Divider(
                //                         color: Theme.of(context).accentColor,
                //                         thickness: 1.0,
                //                       ),
                //                       SizedBox(height: 5.0),
                //                       Row(
                //                         children: [
                //                           SizedBox(height: 5.0),
                //                           Expanded(
                //                             child: Padding(
                //                                 padding: EdgeInsets.all(3.0),
                //                                 child: TextField()),
                //                           )
                //                         ],
                //                       )
                //                     ],
                //                   ),
                //                 ),
                //               ],
                //             ))),
                //   ],
                // ),

                // check on Ui not so necesarry cus it shows automatically
                SizedBox(height: 10.0),
                Column(
                  children: [
                    SizedBox(height: 15),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'PICK UP TIME',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    SizedBox(height: 5),
                    Theme(
                      data: ThemeData(
                          primaryColor: Colors.brown,
                          cursorColor: Colors.brown),
                      child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.brown)),
                          )),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                              hintText: "Special Reqirement",
                            ),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                  itemCount: 1,
                                  itemExtent: 1.0,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    for (int i = 0; i < 1; i++) {
                                      selectedItemValue.add("Type Of Trip");
                                    }
                                    return DropdownButton(
                                      value:
                                          selectedItemValue[index].toString(),
                                      items: _dropDownItem(),
                                      onChanged: (value) {
                                        selectedItemValue[index] = value;
                                        setState(() {});
                                      },
                                      hint: Text('Select Type of trip'),
                                    );
                                  }),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    _locationController.lookingForDriver.value
                        ? Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: Container(
                              color: Colors.white,
                              child: ListTile(
                                title: SpinKitWave(
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                              ),
                              child: RaisedButton(
                                onPressed: () async {
                                  // button to request for ride
                                  _locationController.requestDriver(
                                      distance: _locationController
                                          .routeModel.distance
                                          .toJson(),
                                      user: _userController.userData.value,
                                      lat: _locationController
                                          .pickupCoordinates.value.latitude,
                                      lng: _locationController
                                          .pickupCoordinates.value.longitude,
                                      context: context);
                                  _locationController
                                      .changeMainContext(context);

                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20.0)), //this right here
                                          child: Container(
                                            height: 200,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SpinKitWave(
                                                    color: Colors.black,
                                                    size: 30,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CustomText(
                                                          text:
                                                              "Looking for a driver"),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  LinearPercentIndicator(
                                                    lineHeight: 4,
                                                    animation: true,
                                                    animationDuration: 100000,
                                                    percent: 1,
                                                    backgroundColor: Colors.grey
                                                        .withOpacity(0.2),
                                                    progressColor: Colors.brown,
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      FlatButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            _locationController
                                                                .cancelRequest();
                                                            widget.scaffoldState
                                                                .currentState
                                                                .showSnackBar(
                                                                    SnackBar(
                                                                        content:
                                                                            Text("Request cancelled!")));
                                                          },
                                                          child: CustomText(
                                                            text:
                                                                "Cancel Request",
                                                            color: Colors
                                                                .deepOrange,
                                                          )),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                                color: Colors.brown,
                                child: Text(
                                  "Request",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ]));
        });
  }

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddl = [
      "Business",
      "Family",
      "Group Tour",
      "City Tour",
      "Adventure",
      "Cultural",
      "Honeymoon"
    ];
    return ddl
        .map((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ))
        .toList();
  }
}
