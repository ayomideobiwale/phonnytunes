import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  static const ID = "uid";
  static const NAME = "name";
  static const EMAIL = "email";
  static const PASSWORD = "password";
  static const PHONENO = "phoneNumber";
  static const USERNAME = "username";
  static const PROFILEPICTURE = "profilePicture";

  String uid;
  String name;
  String email;
  String phoneNumber;
  String password;
  String username;
  String profilePicture;

  UserData({
    this.uid,
    this.name,
    this.email,
    this.phoneNumber,
    this.password,
    this.username,
    this.profilePicture,
  });

  UserData.fromSnapshot(DocumentSnapshot snapshot) {
    name = snapshot.data()[NAME];
    email = snapshot.data()[EMAIL];
    uid = snapshot.data()[ID];
    password = snapshot.data()[PASSWORD];
    phoneNumber = snapshot.data()[PHONENO];
    username = snapshot.data()[USERNAME];
    profilePicture = snapshot.data()[PROFILEPICTURE];

  }
}
