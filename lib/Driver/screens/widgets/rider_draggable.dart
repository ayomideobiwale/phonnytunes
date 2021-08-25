
import 'package:flutter/material.dart';
import 'package:phonnytunes_application/Driver/constants/constants.dart';
import 'package:phonnytunes_application/Driver/services/call_sms.dart';
import 'package:phonnytunes_application/locators/service_locator.dart';
import 'package:phonnytunes_application/widgets/custom_text.dart';



class RiderWidget extends StatelessWidget {
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();


  @override
  Widget build(BuildContext context) {
   // AppStateProvider appState = Provider.of<AppStateProvider>(context);


    return DraggableScrollableSheet(
        initialChildSize: 0.1,
        minChildSize: 0.05,
        maxChildSize: 0.6,
        builder: (BuildContext context, myscrollController) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(.8),
                      offset: Offset(3, 2),
                      blurRadius: 7)
                ]),
            child: ListView(
              controller: myscrollController,
              children: [
                SizedBox(
                  height: 12,
                ),
                ListTile(
                  leading: Container(
                    child: driverController.riderModel?.phone == null
                        ? CircleAvatar(
                            radius: 30,
                            child: Icon(
                              Icons.person_outline,
                              size: 25,
                            ),
                          )
                        : CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(driverController.riderModel?.photo),
                          ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: driverController.riderModel.name + "\n",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: driverController.rideRequestModel?.destination,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300)),
                      ], style: TextStyle(color: Colors.black))),
                    ],
                  ),
                  trailing: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(0.7, 0.7),
                                )
                              ]),
                          child: CircleAvatar(
                            child: IconButton(
                              onPressed: () {
                                _service.call(driverController.riderModel.phone);
                              },
                              icon: Icon(Icons.call),
                            ),
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(0.7, 0.7),
                                )
                              ]),
                          child: CircleAvatar(
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.message),
                            ),
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(0.7, 0.7),
                                )
                              ]),
                          child: CircleAvatar(
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.cancel
                              )
                            ),
                          )),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: CustomText(
                    text: "Ride details",
                    size: 18,
                    weight: FontWeight.bold,
                  ),
                ),
                Container(
                   decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                        color: Colors.grey,
                                        style: BorderStyle.solid,
                                        width: 1.0),
                              ),
                              
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 100,
                        width: 10,
                        child: Column(
                          children: [
                            Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).primaryColor)),
                            Padding(
                              padding: const EdgeInsets.only(left: 9),
                              child: Container(
                                height: 45,
                                width: 2,
                                color: Colors.black,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: "\nPick up location \n",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        TextSpan(
                            text: "25th avenue, flutter street \n\n\n",
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 16)),
                        TextSpan(
                            text: "Destination \n",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        TextSpan(
                            text: "${driverController.rideRequestModel?.destination} \n",
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 16)),
                      ], style: TextStyle(color: Colors.black))),
                    ],
                  ),
                ),
                 
                
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                  decoration:  BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                             
                              ),
                    child: Row(
                      children: [
                        CustomText(
                          text: "Ride price", //finalized booking price
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
