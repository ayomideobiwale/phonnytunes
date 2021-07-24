
import 'package:card_scanner/card_scanner.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:phonnytunes_application/services/payment/exsistingcard.dart';



class AddCard2 extends StatefulWidget {
  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard2> {
  CardDetails cardDetailss;

  Future<void> scanCard() async {
    var cardDetails = await CardScanner.scanCard(
        scanOptions: CardScanOptions(scanCardHolderName: true));
      

    if (!mounted) return;
    setState(() {
      cardDetailss = cardDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(child: Container(
            margin: EdgeInsets.only(top: 50, left: 35, right: 35, bottom: 30),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(15),
              child: Container(
                height: 100,
                width: 100,
                child: Text('$cardDetailss'),
              ),
            ),
          ),),
          Container(
              margin: EdgeInsets.only(top: 30, left: 2),
              child: GestureDetector(
                onTap: () {},
                child: Card(
                    shape: CircleBorder(side: BorderSide.none),
                    child: Container(
                        height: 30,
                        width: 30,
                        child: Center(
                          child: Icon(Icons.menu),
                        ))), //
              )),
          Container(
            margin: EdgeInsets.only(top: 35),
            alignment: Alignment.topCenter,
            child: Text(
              'Add card',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                height: 50,
                child: Row(children: [
                  Icon(Icons.scanner),
                  SizedBox(width: 10),
                  GestureDetector(
                      onTap: () async {
                        var status = await Permission.camera.request();
                        if (status == PermissionStatus.granted) {
                          scanCard();
                        }
                      }, // on tap Scan
                      child: Text('Scan card')),
                  Spacer(),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ExistingCards(
                                                  cardNumber: cardDetailss.cardNumber,
                                                  expiryDate: cardDetailss.expiryDate,
                                                  cardHolderName: cardDetailss.cardHolderName,
                                                  cvvCode: cardDetailss.cardIssuer,
                                                ),
                                          ));
                    }, // on tap DONE
                    child: Text('Done',
                        style: TextStyle(
                          color: Colors.brown,
                        )),
                  )
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}