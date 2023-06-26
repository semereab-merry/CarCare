import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final String notes;
  final String recordId;
  final String dateAdded;
  final String photoUrl;
  final String carid;
  final String cost;

  const Record({
    required this.notes,
    required this.carid,
    required this.recordId,
    required this.dateAdded,
    required this.photoUrl,
    required this.cost,
  });

  static Record fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Record(
      notes: snapshot["notes"],
      carid: snapshot["carid"],
      recordId: snapshot["recordId"],
      dateAdded: snapshot["dateAdded"],
      cost: snapshot["cost"],
      photoUrl: snapshot["photoUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
        "notes": notes,
        "carid": carid,
        "recordId": recordId,
        "dateAdded": dateAdded,
        "photoUrl": photoUrl,
        "cost": cost,
      };
}
