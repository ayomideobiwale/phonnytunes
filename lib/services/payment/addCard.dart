
import 'package:flutter/material.dart';
import 'package:phonnytunes_application/services/payment/exsistingcard.dart';

class AddCard extends StatefulWidget {
  @override
  _AddCardState createState() => new _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final formKey = GlobalKey<FormState>();
  TextEditingController cardNumberTextEditingController =
      new TextEditingController();
  TextEditingController cardHolderTextEditingController =
      new TextEditingController();
  TextEditingController expDateTextEditingController =
      new TextEditingController();
  TextEditingController cvvDateTextEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 35, left: 35, right: 35, bottom: 30),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 50),
                  height: 600,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'CARD NUMBER',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 15),
                      Theme(
                        data: ThemeData(
                            primaryColor: Colors.brown,
                            cursorColor: Colors.brown),
                        child: TextFormField(
                            controller: cardNumberTextEditingController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(color: Colors.white70)),
                            )),
                      ),
                      SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'CARD HOLDER NAME',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 5),
                      Theme(
                        data: ThemeData(
                            primaryColor: Colors.brown,
                            cursorColor: Colors.brown),
                        child: TextFormField(
                            controller: cardHolderTextEditingController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(color: Colors.white70)),
                            )),
                      ),
                      SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'EXP.DATE',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Theme(
                            data: ThemeData(
                                primaryColor: Colors.brown,
                                cursorColor: Colors.brown),
                            child: Expanded(
                              child: TextFormField(
                                  controller: expDateTextEditingController,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide:
                                            BorderSide(color: Colors.brown)),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 17,
                          ),
                          Theme(
                            data: ThemeData(
                                primaryColor: Colors.brown,
                                cursorColor: Colors.brown),
                            child: Expanded(
                              child: TextFormField(
                                  controller: cvvDateTextEditingController,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide:
                                            BorderSide(color: Colors.brown)),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 10,
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 20, bottom: 20, left: 15),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 15),
                                alignment: Alignment.topLeft,
                                child: GestureDetector(
                                  onTap: null, // onTap scan Card
                                  child: Row(
                                    children: [
                                      Icon(Icons.scanner),
                                      SizedBox(width: 10),
                                      Text('Scan card')
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 15),
                                  alignment: Alignment.centerLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ExistingCards(
                                                  cardNumber: cardNumberTextEditingController.text,
                                                  expiryDate: expDateTextEditingController.text,
                                                  cardHolderName: cardHolderTextEditingController.text,
                                                  cvvCode: cvvDateTextEditingController.text,
                                                ),
                                          ));
                                      //ExistingCards();
                                    }, // on tap DONE
                                    child: Text('Done',
                                        style: TextStyle(
                                          color: Colors.brown,
                                        )),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
                          child: Icon(Icons.arrow_back_ios),
                        ))), // this should route to the previous screen
              )),
          Container(
            margin: EdgeInsets.only(top: 30),
            alignment: Alignment.topCenter,
            child: Text(
              'Add card',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
