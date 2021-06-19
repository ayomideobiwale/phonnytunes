import 'package:flutter/material.dart';
import 'package:phonnytunes_application/widgets/colors.dart';

class Profiles extends StatefulWidget {
  @override
  _ProfilesState createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topRight,
            height: MediaQuery.of(context).size.height / 2.9,
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                          alignment: Alignment.topLeft,
                          icon: Icon(Icons.arrow_back,
                              color: ColorConstants.primaryColor),
                          onPressed: () {
                            Navigator.pushNamed(context, '/MapHome');
                          }),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                      ),
                      IconButton(
                        alignment: Alignment.topRight,
                        icon: Icon(Icons.edit,
                            color: ColorConstants.primaryColor),
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
                CircleAvatar(
                  backgroundColor: ColorConstants.primaryColor,
                  radius: 50,
                ),
                SizedBox(height: 10),
                Text(
                  'Obiwale Ayomide',
                  style: TextStyle(
                      color: ColorConstants.primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.mail,
                            color: ColorConstants.primaryColor,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text('Mymail@gmail.com',
                              style: TextStyle(color: Colors.grey))
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Row(
                        children: [
                          Icon(Icons.phone, color: ColorConstants.primaryColor),
                          SizedBox(width: 30),
                          Text(
                            '09070903614',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 30),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                 ListTile(
                   leading: Text("Address"),
                   trailing: Text("My Adress")
                 ),
                 SizedBox(height: 20),
                  ListTile(
                   leading: Text("Address"),
                   trailing: Text("My Adress")
                 ),
                 SizedBox(height: 20),
                  ListTile(
                   leading: Text("Address"),
                   trailing: Text("My Adress")
                 ),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
