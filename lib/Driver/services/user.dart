

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:phonnytunes_application/Driver/models/user.dart';

class UserServices {
  String collection = "drivers"; 

  void createUser(
      {String id,
      String name,
      String email,
      String phone,
      String token,
      int votes = 0,
      int trips = 0,
      double rating = 0,
      Map position}) {
    FirebaseFirestore.instance.collection(collection).doc(id).set({
      "name": name,
      "id": id,
      "phone": phone,
      "email": email,
      "votes": votes,
      "trips": trips,
      "rating": rating,
      "position": position,
      "car": "Toyota Corolla",
      "plate": "CBA 321 7",
      "token": token
    });
  }

  void updateUserData(Map<String, dynamic> values) {
    FirebaseFirestore.instance.collection(collection).doc(values['id']).update(values);
  }

  void addDeviceToken({String token, String userId}) {
    FirebaseFirestore.instance
        .collection(collection)
        .doc(userId)
        .update({"token": token});
  }

  Future<UserModel> getUserById(String id) =>
      FirebaseFirestore.instance.collection(collection).doc(id).get().then((doc) {
        return UserModel.fromSnapshot(doc);
      });
}
