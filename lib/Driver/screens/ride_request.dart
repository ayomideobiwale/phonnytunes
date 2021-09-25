
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:phonnytunes_application/Driver/constants/constants.dart';
// import 'package:phonnytunes_application/Driver/constants/stars_method.dart';
// import 'package:phonnytunes_application/Driver/driver_controller/driver_controller.dart';
// import 'package:phonnytunes_application/widgets/custom_btn.dart';
// import 'package:phonnytunes_application/widgets/custom_text.dart';

// class RideRequestScreen extends StatefulWidget {
//   @override
//   _RideRequestScreenState createState() => _RideRequestScreenState();
// }

// class _RideRequestScreenState extends State<RideRequestScreen> {
//   TextEditingController bidTextEditingController = TextEditingController();
//   @override
//   void initState() {
//     super.initState();
//     // AppStateProvider _state =
//     //     Provider.of<AppStateProvider>(context, listen: false);
//     driverController.listenToRequest(id: _state.rideRequestModel.id, context: context);
//   }

//   @override
//   Widget build(BuildContext context) {
//    // AppStateProvider appState = Provider.of<AppStateProvider>(context);
    
//     return SafeArea(
//         child: Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: CustomText(
//           text: "New Ride Request",
//           size: 19,
//           weight: FontWeight.bold,
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: Container(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (driverController.riderModel.photo == null)
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(0.5),
//                         borderRadius: BorderRadius.circular(40)),
//                     child: CircleAvatar(
//                       backgroundColor: Colors.transparent,
//                       radius: 45,
//                       child: Icon(
//                         Icons.person,
//                         size: 65,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 if (driverController.riderModel.photo != null)
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.brown,
//                         borderRadius: BorderRadius.circular(40)),
//                     child: CircleAvatar(
//                       radius: 45,
//                       backgroundImage: NetworkImage(driverController.riderModel?.photo),
//                     ),
//                   ),
//               ],
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CustomText(text: driverController.riderModel?.name ?? "Nada"),
//               ],
//             ),
//             SizedBox(height: 10),
//             stars(
//                 rating: driverController.riderModel.rating,
//                 votes: driverController.riderModel.votes),
//             Divider(),
//             ListTile(
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CustomText(
//                     text: "Destiation",
//                     color: Colors.grey,
//                   ),
//                 ],
//               ),
//               // ignore: deprecated_member_use
//               subtitle: FlatButton.icon(
//                   onPressed: () async {
//                     LatLng destinationCoordiates = LatLng(
//                         driverController.rideRequestModel.dLatitude,
//                         driverController.rideRequestModel.dLongitude);
//                     driverController.addLocationMarker(
//                         destinationCoordiates,
//                         driverController.rideRequestModel?.destination ?? "Nada",
//                         "Destination Location");
//                     showModalBottomSheet(
//                         context: context,
//                         builder: (BuildContext bc) {
//                           return Container(
//                             height: 400,
//                             child: GoogleMap(
//                               initialCameraPosition: CameraPosition(
//                                   target: destinationCoordiates, zoom: 13),
//                               onMapCreated: driverController.onCreate,
//                               myLocationEnabled: true,
//                               mapType: MapType.normal,
//                               tiltGesturesEnabled: true,
//                               compassEnabled: false,
//                               markers: driverController.markers,
//                               onCameraMove: driverController.onCameraMove,
//                               polylines: driverController.poly,
//                             ),
//                           );
//                         });
//                   },
//                   icon: Icon(
//                     Icons.location_on,
//                   ),
//                   label: CustomText(
//                     text: driverController.rideRequestModel?.destination ?? "Nada",
//                     weight: FontWeight.bold,
//                   )),
//             ),
//             Divider(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 // ignore: deprecated_member_use
//                 FlatButton.icon(
//                     onPressed: null,
//                     icon: Icon(Icons.flag),
//                     label: Text('User is near by')),
//                 // ignore: deprecated_member_use
//                 FlatButton.icon(
//                   //bidding amount
//                   onPressed: null,
//                   icon: Icon(Icons.monetization_on),
//                   label: Container(
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.white),
//                         borderRadius: BorderRadius.circular(5)),
//                     child: Padding(
//                       padding: EdgeInsets.only(left: 10),
//                       child: TextFormField(
//                         controller: bidTextEditingController,
//                         decoration: InputDecoration(
//                           hintStyle: TextStyle(color: Colors.white),
//                           border: InputBorder.none,
//                           hintText: "Bidding amount",
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Divider(),
//              Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Text('Time of Trip: 14:20'),
//                 Text('Type of trip: family')// type of tripe that is passed from the drivers side
//               ],
//             ),
//             Divider(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 CustomBtn(
//                   text: "BID",
//                   onTap: () async {
//                     if (bidTextEditingController.text.isNotEmpty) {
//                       if (driverController.requestModelFirebase.status != "pending") {
//                         showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return Dialog(
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(
//                                         20.0)), //this right here
//                                 child: Container(
//                                   height: 200,
//                                   child: Padding(
//                                       padding: const EdgeInsets.all(12.0),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           CustomText(
//                                               text: "Sorry! Request Expired")
//                                         ],
//                                       )),
//                                 ),
//                               );
//                             });
//                       } else {
//                         //upload bidding data
//                         FirebaseFirestore.instance
//                             .collection("bidding")
//                             .doc(userProvider.userModel.id)
//                             .set({
//                           "amount": bidTextEditingController.text,
//                           "id": userProvider.userModel.id,
//                           "time": DateTime.now().millisecondsSinceEpoch
//                         }).then((_) {
//                           //get all bidding and picks the lowest
//                           FirebaseFirestore.instance
//                               .collection("bidding")
//                               .snapshots()
//                               .listen((result) {
//                             result.docs.forEach((results) {
//                               print(results.data()["amount"]);
//                               List bidAmount = [results.data()["amount"]];
//                               bidAmount.sort();
//                               print(bidAmount[0]);
//                               //finding the user with the lowest amount
//                               FirebaseFirestore.instance
//                                   .collection("bidding")
//                                   .where("amount", isEqualTo: bidAmount[0])
//                                   .orderBy('time')
//                                   .limit(1)
//                                   .get()
//                                   .then((querySnapshot) {
//                                 querySnapshot.docs.forEach((element) {
//                                   if (element.exists) {
//                                     //checks if the user has the same id as the retrived id
//                                     //var lowestBid = element.data()['amount'];
//                                     var id = element.data()['id'].toString();
//                                     if (id == userProvider.userModel.id) {
//                                       // if true then they successfully accepted the request
//                                       driverController.clearMarkers();

//                                       driverController.acceptRequest(
//                                           requestId:
//                                               driverController.rideRequestModel.id,
//                                           driverId: userProvider.userModel.id);
//                                       driverController.changeWidgetShowed(
//                                           showWidget: Show.RIDER);
//                                       driverController.sendRequest(
//                                           coordinates: driverController
//                                               .requestModelFirebase
//                                               .getCoordinates());
//                                               //deletes the user bid document
//                                       FirebaseFirestore.instance
//                                           .collection("bidding")
//                                           .doc(userProvider.userModel.id)
//                                           .delete(); 
//                                     } else {
//                                       FirebaseFirestore.instance
//                                           .collection("bidding")
//                                           .doc(userProvider.userModel.id)
//                                           .delete();
//                                       Get.snackbar(
//                                           "Sorry", "Your bid was too high",
//                                           backgroundColor: Colors.white,
//                                           colorText: Colors.brown,
//                                           snackPosition: SnackPosition.BOTTOM);
//                                     }
//                                   }
//                                 });
//                               });
//                             });
//                           });
//                         });
//                         /*enter the amount and start bid process(choosing the lowest amount from t
//                       he collection document) then continue if id is equal to 
//                         the driver id(userProvider.userModel.id) 
//                         amount: 12
//                         id: userProvider.userModel.id*/
//                         // appState.clearMarkers();

//                         // appState.acceptRequest(
//                         //     requestId: appState.rideRequestModel.id,
//                         //     driverId: userProvider.userModel.id);
//                         // appState.changeWidgetShowed(showWidget: Show.RIDER);
//                         // appState.sendRequest(
//                         //     coordinates:
//                         //         appState.requestModelFirebase.getCoordinates());
// //                      showDialog(
// //                          context: context,
// //                          builder: (BuildContext context) {
// //                            return Dialog(
// //                              shape: RoundedRectangleBorder(
// //                                  borderRadius: BorderRadius.circular(
// //                                      20.0)), //this right here
// //                              child: Container(
// //                                height: 200,
// //                                child: Padding(
// //                                  padding: const EdgeInsets.all(12.0),
// //                                  child: Column(
// //                                    mainAxisAlignment: MainAxisAlignment.center,
// //                                    crossAxisAlignment:
// //                                        CrossAxisAlignment.start,
// //                                    children: [
// //                                      SpinKitWave(
// //                                        color: black,
// //                                        size: 30,
// //                                      ),
// //                                      SizedBox(
// //                                        height: 10,
// //                                      ),
// //                                      Row(
// //                                        mainAxisAlignment:
// //                                            MainAxisAlignment.center,
// //                                        children: [
// //                                          CustomText(
// //                                              text:
// //                                                  "Awaiting rider confirmation"),
// //                                        ],
// //                                      ),
// //                                      SizedBox(
// //                                        height: 30,
// //                                      ),
// //                                      LinearPercentIndicator(
// //                                        lineHeight: 4,
// //                                        animation: true,
// //                                        animationDuration: 100000,
// //                                        percent: 1,
// //                                        backgroundColor:
// //                                            Colors.grey.withOpacity(0.2),
// //                                        progressColor: Colors.deepOrange,
// //                                      ),
// //                                      SizedBox(
// //                                        height: 20,
// //                                      ),
// //                                      Row(
// //                                        mainAxisAlignment:
// //                                            MainAxisAlignment.center,
// //                                        children: [
// //                                          FlatButton(
// //                                              onPressed: () {
// //                                                appState.cancelRequest(requestId: appState.rideRequestModel.id);
// //                                              },
// //                                              child: CustomText(
// //                                                text: "Cancel",
// //                                                color: Colors.deepOrange,
// //                                              )),
// //                                        ],
// //                                      )
// //                                    ],
// //                                  ),
// //                                ),
// //                              ),
// //                            );
// //                          });
//                       }
//                     } else {
//                       Get.snackbar(
//                         "Error!",
//                         "BID amount cannot be empty",
//                         backgroundColor: Colors.white,
//                         colorText: Colors.brown,
//                         snackPosition: SnackPosition.TOP,
//                       );
//                     }
//                   },
//                   bgColor: Colors.green,
//                   shadowColor: Colors.greenAccent,
//                 ),
//                 CustomBtn(
//                   text: "Reject",
//                   onTap: () {
//                     driverController.clearMarkers();
//                     driverController.changeRideRequestStatus();
//                   },
//                   bgColor: Colors.red,
//                   shadowColor: Colors.redAccent,
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
// }
