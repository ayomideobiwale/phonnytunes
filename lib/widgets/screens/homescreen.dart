import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:phonnytunes_application/widgets/colors.dart';
import 'package:phonnytunes_application/widgets/screens/DrawerScreen.dart';
import 'package:phonnytunes_application/widgets/screens/loginscreen.dart';
import 'package:phonnytunes_application/widgets/screens/profileScreen.dart';
import 'package:phonnytunes_application/widgets/screens/settings.dart';
import '';
import 'mapview.dart';

class MapHome extends StatefulWidget {
  @override
  _MapHomeState createState() => _MapHomeState();
}

class _MapHomeState extends State<MapHome> {
  @override
  Widget build(BuildContext context) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
      
    return Scaffold(
      appBar: AppBar(
        
        title: Text(''),
        backgroundColor:  ColorConstants.primaryColor,
        
      ),
        drawer: SafeArea(
          child: Drawer(
            
            elevation: 0,
            child: ListView(
              children: [
                DrawerHeader(
                  
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                       color:  Colors.grey[200]
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,

                        ),
                        SizedBox(width: 13),
                        Text('Username')
                      ],
                    )
                  ),

                ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profiles()));
                    }),
                SizedBox(height: 10),
                ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: () {
                      Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Settings()));
                    }),
                SizedBox(height: 10),
                ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () {
                     Navigator.pushReplacementNamed(context, '/auth');
                    }),
                    SizedBox(height: 10),
                ListTile(
                    leading: Icon(Icons.help_center),
                    title: Text('Help'),
                    onTap: () {
                      //Goes to hel screen 
                    })
              ],
            ),
          ),
        ),
        body: Stack(
          children: [],
        ));
  }
}
