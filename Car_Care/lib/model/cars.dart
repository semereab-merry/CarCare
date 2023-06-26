import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  String carId;
  String brand;
  String title;
  String uid;

  Car({
    required this.carId,
    required this.title,
    required this.brand,
    required this.uid,
  });

  static Car fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Car(
      carId: snapshot['carId'],
      title: snapshot['title'],
      brand: snapshot['brand'],
      uid: snapshot["uid"],
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "brand": brand,
        "uid": uid,
        "carId": carId,
      };
}
