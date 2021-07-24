import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phonnytunes_application/constants/firebase.dart';
import 'package:phonnytunes_application/model/driver.dart';


class DriverService {
  String collection = 'drivers';

  Stream<List<DriverModel>> getDrivers() {
    return FirebaseFirestore.instance.collection(collection).snapshots().map((event) =>
        event.docs.map((e) => DriverModel.fromSnapshot(e)).toList());
  }

  Future<DriverModel> getDriverById(String id) =>
      FirebaseFirestore.instance.collection(collection).doc(id).get().then((doc) {
        return DriverModel.fromSnapshot(doc);
      });

  Stream<QuerySnapshot> driverStream() {
    CollectionReference reference = firebaseFirestore.collection(collection);
    return reference.snapshots();
  }
}
