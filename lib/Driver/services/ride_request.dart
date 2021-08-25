
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phonnytunes_application/Driver/models/ride_Request.dart';

class RideRequestServices {
  String collection = "requests";

  void updateRequest(Map<String, dynamic> values) {
    FirebaseFirestore.instance.collection(collection).doc(values['id']).update(values);
  }

  Stream<QuerySnapshot> requestStream({String id}) {
    CollectionReference reference = FirebaseFirestore.instance.collection(collection);
    return reference.snapshots();
  }

  Future<RequestModelFirebase> getRequestById(String id) =>
      FirebaseFirestore.instance.collection(collection).doc(id).get().then((doc) {
        return RequestModelFirebase.fromSnapshot(doc);
      });

}
