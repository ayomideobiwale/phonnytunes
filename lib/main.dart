import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:phonnytunes_application/constants/firebase.dart';
import 'package:phonnytunes_application/controllers/location_controller.dart';
import 'package:phonnytunes_application/controllers/user_controller.dart';
import 'package:phonnytunes_application/screens/homescreen.dart';
import 'package:phonnytunes_application/screens/loginscreen.dart';
import 'package:phonnytunes_application/screens/signup.dart';
import 'package:phonnytunes_application/screens/userchooserscreen.dart';
import 'package:phonnytunes_application/widgets/loadingpage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialization.then((value) {
    Get.put(UserController());
    Get.put(LocationController());
  });

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => HomePage(),
      '/auth': (context) => DrawerScreen(),
      '/SignUp': (context) => SignUp(),
      '/chooseMode': (context) => UserMode(),
      '/MapHome': (context) => MapHome(),
    },
  ));
}
