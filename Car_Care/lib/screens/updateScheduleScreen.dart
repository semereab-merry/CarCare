// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:typed_data';
import 'package:carlife/resources/detailsMethods.dart';
import 'package:carlife/resources/scheduleMethods.dart';
import 'package:carlife/responsive/mobileScreenLayout.dart';
import 'package:carlife/responsive/responsive_layout.dart';
import 'package:carlife/responsive/webScreenLayout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carlife/utilis/colors.dart';
import 'package:carlife/utilis/utilis.dart';
import 'package:intl/intl.dart';

import '../utilis/fonts.dart';
import 'package:carlife/widgets/inputs.dart';

class UpdateCarSchedule extends StatefulWidget {
  final String carid;
  const UpdateCarSchedule({Key? key, required this.carid}) : super(key: key);

  @override
  State<UpdateCarSchedule> createState() => _UpdateCarScheduleState();
}

class _UpdateCarScheduleState extends State<UpdateCarSchedule> {
  DateTime oilDate = DateTime.now();
  DateTime tireDate = DateTime.now();
  DateTime brakeDate = DateTime.now();
  DateTime engineDate = DateTime.now();
  bool _isLoading = false;
  var carData = {};

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var carSnap = await FirebaseFirestore.instance
          .collection('cars')
          .doc(widget.carid)
          .get();

      carData = carSnap.data()!;

      setState(() {});
    } catch (e) {
      showSnackBar(
        e.toString(),
        context,
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  void addSchedule(
    String oilDate,
    String tireDate,
    String brakeDate,
    String engineDate,
    String carid,
  ) async {
    setState(() {
      _isLoading = true;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    });

    // start the loading
    try {
      // upload to storage and db
      String res = await ScheduleMethods().addSchedule(
        oilDate,
        tireDate,
        brakeDate,
        engineDate,
        carid,
      );
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
      } else {
        showSnackBar(res, context);
      }
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(
        err.toString(),
        context,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios_new),
              ),
              backgroundColor: mobileBackgroundColor,
            ),
            body: SafeArea(
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// fix the position
                      // separator
                      const SizedBox(
                        height: 34,
                      ),
                      Text(
                        "Update your schedules: ",
                        style: follow,
                      ),
                      // separator
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Enter the dates of your last maintenance activity",
                        style: normal,
                      ),
                      // separator
                      const SizedBox(
                        height: 24,
                      ),

                      InputFields(
                          title: "Oil and filter change",
                          hint: DateFormat.yMd().format(oilDate),
                          widget: IconButton(
                            icon: const Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              _getHistoryOil();
                            },
                          )),
                      const SizedBox(width: 12),
                      InputFields(
                          title: "Tire rotation",
                          hint: DateFormat.yMd().format(tireDate),
                          widget: IconButton(
                            icon: const Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              _getHistoryTire();
                            },
                          )),
                      const SizedBox(width: 12),

                      InputFields(
                          title: "Brake inspection",
                          hint: DateFormat.yMd().format(brakeDate),
                          widget: IconButton(
                            icon: const Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              _getHistoryBrake();
                            },
                          )),
                      const SizedBox(width: 12),
                      InputFields(
                          title: "Replace engine air filter",
                          hint: DateFormat.yMd().format(engineDate),
                          widget: IconButton(
                            icon: const Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              _getHistoryEngine();
                            },
                          )),

// separator
                      const SizedBox(
                        height: 24,
                      ),
                      InkWell(
                          onTap: () => addSchedule(
                                DateFormat.yMd()
                                    .format(oilDate.add(Duration(days: 180))),
                                DateFormat.yMd()
                                    .format(tireDate.add(Duration(days: 180))),
                                DateFormat.yMd()
                                    .format(brakeDate.add(Duration(days: 365))),
                                DateFormat.yMd().format(
                                    engineDate.add(Duration(days: 365))),
                                carData['carId'].toString(),
                              ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: secondaryColor,
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'Update',
                              style: emp_bold,
                            ),
                          )),
                    ],
                  ))),
            ));
  }

  _getHistoryOil() async {
    DateTime? _pickedOil = await _showDatePicker();
    if (_pickedOil != null) {
      setState(() {
        oilDate = _pickedOil;
      });
    }
  }

  _getHistoryTire() async {
    DateTime? _pickedTire = await _showDatePicker();
    if (_pickedTire != null) {
      setState(() {
        tireDate = _pickedTire;
      });
    }
  }

  _getHistoryBrake() async {
    DateTime? _pickedBrake = await _showDatePicker();
    if (_pickedBrake != null) {
      setState(() {
        brakeDate = _pickedBrake;
      });
    }
  }

  _getHistoryEngine() async {
    DateTime? _pickedEngine = await _showDatePicker();
    if (_pickedEngine != null) {
      setState(() {
        engineDate = _pickedEngine;
      });
    }
  }

  _showDatePicker() {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime(2035));
  }
}
