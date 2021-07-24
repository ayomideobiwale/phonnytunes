import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:get/get.dart';
import 'package:phonnytunes_application/controllers/location_controller.dart';
import 'package:phonnytunes_application/services/payment/addCard.dart';

class ExistingCards extends StatefulWidget {
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;

  const ExistingCards(
      {Key key,
      this.cardNumber,
      this.expiryDate,
      this.cardHolderName,
      this.cvvCode})
      : super(key: key);
  @override
  _ExistingCardsState createState() => _ExistingCardsState();
}

class _ExistingCardsState extends State<ExistingCards> {
  LocationController _locationController = Get.find();

  @override
  Widget build(BuildContext context) {
    List cards = [
      {
        'cardNumber': widget.cardNumber ?? "?",
        'expiryDate': widget.expiryDate ?? "?",
        'cardHolderName': widget.cardHolderName ?? "?",
        'cvvCode': widget.cvvCode ?? "?",
        'showBackView': 'false', //true when you want to show cvv(back) view
      }
    ];

    // AppStateProviders appState = Provider.of<AppStateProviders>(context);
    return Scaffold(
      appBar: AppBar(title: Text('chose saved card')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddCard();
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView.builder(
                itemCount: cards.length,
                itemBuilder: (BuildContext context, int index) {
                  var card = cards[index];
                  return InkWell(
                    onTap: () {
                      _locationController.payViaExistingCard(
                          context: context,
                          card: card,
                          bidprice: _locationController.ridePrice.value);
                    },
                    child: CreditCardWidget(
                      cardNumber: card['cardNumber'],
                      expiryDate: card['expiryDate'],
                      cardHolderName: card['cardHolderName'],
                      cvvCode: card['cvvCode'],
                      showBackView:
                          false, //true when you want to show cvv(back) view
                    ),
                  );
                }) //Text(''),// if there is a saved card show else show 'no saved card'
            ),
      ),
    );
  }
}
