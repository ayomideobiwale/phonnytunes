import 'package:cloud_firestore/cloud_firestore.dart';

class RideRequestServices {
  String collection = "requests";
  var firebaseFirestore = FirebaseFirestore.instance;

  void createRideRequest({
    String id,
    String userId,
    String username,
    Map<String, dynamic> destination,
    Map<String, dynamic> position,
    Map distance,
  }) {
    firebaseFirestore.collection(collection).doc(id).set({
      "username": username,
      "id": id,
      "userId": userId,
      "driverId": "",
      "position": position,
      "status": 'pending',
      "destination": destination,
      "distance": distance
    });
  }

  void updateRequest(Map<String, dynamic> values) {
    firebaseFirestore.collection(collection).doc(values['id']).update(values);
  }

  Stream<QuerySnapshot> requestStream() {
    CollectionReference reference =
        FirebaseFirestore.instance.collection(collection);
    return reference.snapshots();
  }
}
