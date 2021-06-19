import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phonnytunes_application/widgets/colors.dart';

class UserMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.grey[100],
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Container(
            decoration: BoxDecoration(
                color: ColorConstants.primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100))),
            margin: EdgeInsets.only(top: 200, bottom: 270, right: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 80),
                    width: 120,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12)),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/MapHome');
                        },
                        child: Center(
                          child: Text('Request a ride',
                              style: TextStyle(
                                  color: ColorConstants.primaryColor,
                                  fontSize: 16)),
                        )),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: Container(
                    width: 120,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12)),
                    child: TextButton(
                        onPressed: () {},
                        child: Center(
                          child: Text(' Login as in rider',
                              style: TextStyle(
                                  color: ColorConstants.primaryColor,
                                  fontSize: 16)),
                        )),
                  ),
                )
              ],
            )));
  }
}
