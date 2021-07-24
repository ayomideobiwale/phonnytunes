import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phonnytunes_application/controllers/location_controller.dart';
import 'package:phonnytunes_application/controllers/user_controller.dart';
import 'package:phonnytunes_application/services/payment/payment.dart';
import 'package:phonnytunes_application/widgets/custom_text.dart';

class PaymentMethodSelectionWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldState;

  PaymentMethodSelectionWidget({Key key, this.scaffoldState}) : super(key: key);

  // UserController _userController = Get.find();
  LocationController _locationController = Get.find();

  @override
  Widget build(BuildContext context) {
   // AppStateProviders appState = Provider.of<AppStateProviders>(context);
    //UserProviders userProvider = Provider.of<UserProviders>(context);

    return DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.3,
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
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomText(
                    text:
                        "The charge for this ride is ,\n\$${_locationController.ridePrice.value}", //pass bidding
                    size: 24,
                    weight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    onTap: () {
                      Payment();
                    },
                    child: Container(
                        height: 60.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Material(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).primaryColor,
                            elevation: 7.0,
                            child: Center(
                                child: Text(
                              'Accept and Pay',
                              style: TextStyle(
                                fontFamily: 'Brand Bold',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
