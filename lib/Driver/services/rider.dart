

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phonnytunes_application/Driver/models/rider.dart';

class RiderServices {
  String collection = "users";

  Future<RiderModel> getRiderById(String id) =>
      FirebaseFirestore.instance.collection(collection).doc(id).get().then((doc) {
        return RiderModel.fromSnapshot(doc);
      });
}
