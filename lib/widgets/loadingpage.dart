import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phonnytunes_application/widgets/details_page.dart';

import 'colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
        body: Stack(children: <Widget>[
      _buildBottomPart(context),
      _buildTopPart(),
    ]));
  }
}

Widget _buildBottomPart(BuildContext context) {
  return Positioned.fill(
      child: Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(color: ColorConstants.primaryColor),
          child: Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/auth');
                },
                child: Text(
                  'Get Started',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )),
          )));
}

Widget _buildTopPart() {
  return Positioned.fill(
      bottom: 70,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: Column(
            children: [
              SvgPicture.asset('assets/phonny2.svg'),
              Text('Fast Delivery',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )),
              Text('Reliable and cultured',
                  style: TextStyle(color: Colors.grey)),
              Text(
                  'We are here to ease your delivery stress \n Why not give us a trial\n trust us with your goods',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ))
            ],
          )));
}
