import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:phonnytunes_application/controllers/user_controller.dart';
import 'package:phonnytunes_application/widgets/loadingpage.dart';
import 'package:phonnytunes_application/widgets/screens/homescreen.dart';
import 'package:phonnytunes_application/widgets/screens/loginscreen.dart';
import 'package:phonnytunes_application/widgets/screens/profileScreen.dart';
import 'package:phonnytunes_application/widgets/screens/signup.dart';
import 'package:phonnytunes_application/widgets/screens/userchooserscreen.dart';
import 'package:phonnytunes_application/widgets/screens/profileScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(UserController());
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
