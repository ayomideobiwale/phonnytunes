import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phonnytunes_application/controllers/location_controller.dart';
import 'package:phonnytunes_application/services/payment-services.dart';
import 'package:phonnytunes_application/services/payment/exsistingcard.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  void initState() {
    super.initState();
    StripService.init();
  }

  LocationController _locationController = Get.find();
  @override
  Widget build(BuildContext context) {
   // AppStateProviders appState = Provider.of<AppStateProviders>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Container(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                InkWell(
                    onTap: () {
                      _locationController.payViaNewCard(
                          context: context, bidPrice: _locationController.ridePrice.value);
                    },
                    child: Container(
                      child: ListTile(
                        leading: Icon(
                          Icons.add_circle,
                          color: Colors.brown,
                        ),
                        title: Text('pay via new card'),
                      ),
                    )),
                SizedBox(height: 5.0),
                Divider(
                  color: Colors.brown,
                ),
                SizedBox(height: 5.0),
                InkWell(
                    onTap: () {
                      ExistingCards();
                    },
                    child: Container(
                      child: ListTile(
                          leading: Icon(
                            Icons.add_circle,
                            color: Colors.brown,
                          ),
                          title: Text('pay via saved card')),
                    )),
              ],
            )),
      ),
    );
  }
}
