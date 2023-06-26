import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'package:carlife/model/schedules.dart';

class ScheduleMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addSchedule(
    String oilDate,
    String tireDate,
    String brakeDate,
    String engineDate,
    String carId,
  ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String scheduleId = const Uuid().v1(); // creates unique id based on time
      Schedule schedue = Schedule(
        oilDate: oilDate,
        tireDate: tireDate,
        brakeDate: brakeDate,
        engineDate: engineDate,
        carId: carId,
        scheduleId: scheduleId,
      );
      _firestore.collection('schedule').doc(scheduleId).set(schedue.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updateOil(String oilDate, String scheduleId) async {
    String res = "Some error occurred";
    try {
      _firestore
          .collection('schedule')
          .doc(scheduleId)
          .update({'oilDate': oilDate});
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updateTire(String tireDate, String scheduleId) async {
    String res = "Some error occurred";
    try {
      _firestore
          .collection('schedule')
          .doc(scheduleId)
          .update({'tireDate': tireDate});
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updateBrake(String brakeDate, String scheduleId) async {
    String res = "Some error occurred";
    try {
      _firestore
          .collection('schedule')
          .doc(scheduleId)
          .update({'brakeDate': brakeDate});
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updateEngine(String engineDate, String scheduleId) async {
    String res = "Some error occurred";
    try {
      _firestore
          .collection('schedule')
          .doc(scheduleId)
          .update({'engineDate': engineDate});
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
