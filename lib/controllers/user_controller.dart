import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phonnytunes_application/widgets/loadingpage.dart';
import 'package:phonnytunes_application/widgets/screens/homescreen.dart';
import 'package:phonnytunes_application/widgets/screens/userchooserscreen.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  // @override
  // void onReady() {
  //   super.onReady();
  //   navigate();
  // }

  // navigate() {
  //   User user = _auth.currentUser;
  //   if (user != null) {
  //     Get.to(MapHome());
  //   }
  // }

  logOut() {
    _auth.signOut();
    Get.offAll(HomePage());
  }

  createUserAccount() async {
    /*This creates the user account*/
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      User user = credential.user;
      addDataToDb(uid: user.uid);
    } catch (e) {
      print(e);
      var err = e.toString().split("]");
      Get.snackbar(
        "Error",
        err[1],
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  addDataToDb({String uid}) {
    firebaseFirestore.collection("users").doc(uid).set({
      "uid": uid,
      "email": emailController.text.trim(),
      "name": fullnameController.text.trim(),
      "password": passwordController.text.trim(),
      "phoneNo": phoneNoController.text.trim(),
    }).then((value) {
      clearController();
      Get.to(UserMode());
    });
  }

  clearController() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phoneNoController.clear();
    fullnameController.clear();
  }

  _validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      // form.save();
      return true;
    }
    return false;
  }

  _validateAndSave2() {
    final form = formKey2.currentState;
    if (form.validate()) {
      //form.save();
      return true;
    }
    return false;
  }

  validateAndSubmit2() {
    if (_validateAndSave2()) {
      createUserAccount();
    }
  }

  validateAndSubmit() {
    if (_validateAndSave()) {
      loginuseraccount();
    }
  }

  loginuseraccount() async {
    /*This creates the user account*/
    try {
      await _auth
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) {
        clearController();
        Get.to(UserMode());
      });
    } catch (e) {
      print(e);
      var err = e.toString().split("]");
      Get.snackbar(
        "Error",
        err[1],
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  changePassowrd() async {
    User user = await FirebaseAuth.instance.currentUser;
    user.updatePassword(passwordController.text.trim())..then((value) {
      clearController();
      Get.to(UserMode());
    });
  }
}
