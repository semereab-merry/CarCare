import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  final String oilDate;
  final String tireDate;
  final String brakeDate;
  final String engineDate;
  final String carId;
  final String scheduleId;

  const Schedule({
    required this.oilDate,
    required this.tireDate,
    required this.brakeDate,
    required this.engineDate,
    required this.carId,
    required this.scheduleId,
  });

  static Schedule fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Schedule(
      oilDate: snapshot["oilDate"],
      tireDate: snapshot["tireDate"],
      brakeDate: snapshot["brakeDate"],
      engineDate: snapshot["engineDate"],
      carId: snapshot["carId"],
      scheduleId: snapshot["scheduleId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "oilDate": oilDate,
        "tireDate": tireDate,
        "brakeDate": brakeDate,
        "engineDate": engineDate,
        "carId": carId,
        "scheduleId": scheduleId,
      };
}
