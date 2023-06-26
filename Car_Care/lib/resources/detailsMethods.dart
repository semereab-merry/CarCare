import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../model/cars.dart';

class DetailsMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addCars(
    String title,
    String brand,
    String uid,
  ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String carId = const Uuid().v1(); // creates unique id based on time
      Car car = Car(
        title: title,
        brand: brand,
        uid: uid,
        carId: carId,
      );

      _firestore.collection('cars').doc(carId).set(car.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete car profile
  Future<String> deleteCar(String carId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('cars').doc(carId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
