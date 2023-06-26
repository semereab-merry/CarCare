import 'dart:ffi';
import 'dart:typed_data';

import 'package:carlife/model/records.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carlife/resources/storageMethod.dart';
import 'package:uuid/uuid.dart';

class RecordMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadRecords(String notes, Uint8List file, String carid,
      String cost, String datetime) async {
    // asking carid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrls =
          await StorageMethods().uploadImageToStorage('record', file, true);
      String recordId = const Uuid().v1(); // creates unique id based on time
      Record record = Record(
        recordId: recordId,
        notes: notes,
        carid: carid,
        cost: cost,
        dateAdded: datetime,
        photoUrl: photoUrls,
      );
      _firestore.collection('records').doc(recordId).set(record.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deleteRecord(String recordId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('records').doc(recordId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
