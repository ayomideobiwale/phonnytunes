import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:phonnytunes_application/constants/firebase.dart';
import 'package:phonnytunes_application/model/user.dart';
import 'package:phonnytunes_application/screens/loginscreen.dart';
import 'package:phonnytunes_application/screens/userchooserscreen.dart';
import 'package:phonnytunes_application/widgets/loadingpage.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();
  // FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  Rx<User> firebaseUser;
  String usersCollection = "users";
  final _storage = GetStorage();
  Rx<UserData> userData = UserData().obs;
  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, setInitialScreen);
  }

  setInitialScreen(User user) {
    bool onInstall = _storage.read("FreshInstall");
    if (onInstall == true || onInstall == null) {
      Get.offAll(HomePage());
    } else {
      if (user == null) {
        Get.offAll(DrawerScreen());
      } else {
        userData.bindStream(userDataStream());
        Get.offAll(UserMode());
      }
    }
  }

  
  logOut() {
    auth.signOut();
    Get.offAll(HomePage());
  }

  createUserAccount() async {
    /*This creates the user account*/
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
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
      "profilePicture": "",
    }).then((value) {
      userData.bindStream(userDataStream());
      clearController();
      // Get.to(UserMode());
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
      await auth
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) {
        clearController();
        // Get.to(UserMode());
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
    // User user = await FirebaseAuth.instance.currentUser;
    // user.updatePassword(passwordController.text.trim())..then((value) {
    //   clearController();
    //   // Get.to(UserMode());
    // });
  }
  Stream<UserData> userDataStream() => firebaseFirestore
      .collection(usersCollection)
      .doc(firebaseUser.value.uid)
      .snapshots()
      .map((snapshot) => UserData.fromSnapshot(snapshot));

}
