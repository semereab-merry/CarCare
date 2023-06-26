import 'package:carlife/resources/detailsMethods.dart';
import 'package:carlife/resources/scheduleMethods.dart';
import 'package:carlife/responsive/mobileScreenLayout.dart';
import 'package:carlife/responsive/responsive_layout.dart';
import 'package:carlife/responsive/webScreenLayout.dart';
import 'package:carlife/screens/addRecordsScreen.dart';
import 'package:carlife/screens/pastRecords.dart';
import 'package:carlife/screens/updateScheduleScreen.dart';
import 'package:carlife/utilis/fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carlife/utilis/colors.dart';
import 'package:carlife/utilis/utilis.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class CarProfileScreen extends StatefulWidget {
  final String carid;
  const CarProfileScreen({Key? key, required this.carid}) : super(key: key);

  @override
  _CarProfileScreenState createState() => _CarProfileScreenState();
}

class _CarProfileScreenState extends State<CarProfileScreen> {
  String dateOil = DateFormat.yMd()
      .format(DateTime.now().add(const Duration(days: 180)))
      .toString();
  String dateEngine = DateFormat.yMd()
      .format(DateTime.now().add(const Duration(days: 365)))
      .toString();
  DateTime now =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  var carData = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
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
      isLoading = false;
    });
  }

  deleteCar(String carId) async {
    try {
      await DetailsMethods().deleteCar(carId);
    } catch (err) {
      showSnackBar(
        err.toString(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                carData['title'],
                style: heading,
              ),
              centerTitle: false,
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    showDialog(
                      useRootNavigator: false,
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shrinkWrap: true,
                            children: [
                              'Delete Car',
                            ]
                                .map(
                                  (e) => InkWell(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 16),
                                        child: Text(e),
                                      ),
                                      onTap: () {
                                        deleteCar(carData['carId']);
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ResponsiveLayout(
                                                      mobileScreenLayout:
                                                          MobileScreenLayout(),
                                                      // mobileScreenLayout: HomeScreen(),
                                                      webScreenLayout:
                                                          WebScreenLayout(),
                                                    )));
                                      }),
                                )
                                .toList(),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(children: [
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Brand: ' + carData['brand'],
                                    style: subHeading,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(right: 35, left: 15),
                        child: Text(
                          "Your Current Scheduled Activities",
                          style: normal,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => UpdateCarSchedule(
                                      carid: carData['carId'],
                                    )),
                          );
                        },
                        child: Container(
                            width: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: primaryColor,
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              "Add",
                              style: emp_button,
                            )),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),

                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('schedule')
                        .where('carId', isEqualTo: carData['carId'])
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return (snapshot.data as dynamic).docs.length == 0
                          ? SizedBox(
                              height: 30,
                              child: ListView(
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 25),
                                        child: Text(
                                          "No scheculed activites",
                                          style: emp_grey,
                                        ),
                                      ),
                                    )
                                  ]))
                          : Column(children: [
                              GridView.builder(
                                shrinkWrap: true,
                                itemCount: 1,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 0,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (context, index) {
                                  DocumentSnapshot snap =
                                      (snapshot.data! as dynamic)
                                          .docs[index = 0];

                                  return SizedBox(
                                    child: ListView(
                                        scrollDirection: Axis.vertical,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.all(25),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: primaryColor,
                                                ),
                                                child: Column(children: [
                                                  Column(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          /// oil and filter change
                                                          Row(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Oil and filter change',
                                                                    style:
                                                                        emp_dark,
                                                                  ),
                                                                  _getDaysLeft(snap[
                                                                      'oilDate']),
                                                                ],
                                                              ),
                                                              const Spacer(),
                                                              // update schedule when pressed
                                                              IconButton(
                                                                onPressed: () {
                                                                  showDialog(
                                                                    useRootNavigator:
                                                                        false,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Dialog(
                                                                        child:
                                                                            ListView(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 16),
                                                                          shrinkWrap:
                                                                              true,
                                                                          children: [
                                                                            'Confirm oil and filter change done',
                                                                          ]
                                                                              .map(
                                                                                (e) => InkWell(
                                                                                    child: Container(
                                                                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                                      child: Text(e),
                                                                                    ),
                                                                                    onTap: () {
                                                                                      ScheduleMethods().updateOil(dateOil, snap['scheduleId']);
                                                                                      Navigator.of(context).pop();
                                                                                    }),
                                                                              )
                                                                              .toList(),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .done_all_rounded,
                                                                  color:
                                                                      secondaryColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const Divider(),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Tire rotation ',
                                                                    style:
                                                                        emp_dark,
                                                                  ),
                                                                  _getDaysLeft(snap[
                                                                      'tireDate']),
                                                                ],
                                                              ),
                                                              const Spacer(),
                                                              // update schedule when pressed
                                                              IconButton(
                                                                onPressed: () {
                                                                  showDialog(
                                                                    useRootNavigator:
                                                                        false,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Dialog(
                                                                        child:
                                                                            ListView(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 16),
                                                                          shrinkWrap:
                                                                              true,
                                                                          children: [
                                                                            'Confirm tire rotation done',
                                                                          ]
                                                                              .map(
                                                                                (e) => InkWell(
                                                                                    child: Container(
                                                                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                                      child: Text(e),
                                                                                    ),
                                                                                    onTap: () {
                                                                                      ScheduleMethods().updateTire(dateOil, snap['scheduleId']);
                                                                                      Navigator.of(context).pop();
                                                                                    }),
                                                                              )
                                                                              .toList(),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .done_all_rounded,
                                                                  color:
                                                                      secondaryColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const Divider(),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Brake inspection',
                                                                    style:
                                                                        emp_dark,
                                                                  ),
                                                                  _getDaysLeft(snap[
                                                                      'brakeDate']),
                                                                ],
                                                              ),
                                                              const Spacer(),
                                                              // update schedule when pressed
                                                              IconButton(
                                                                onPressed: () {
                                                                  showDialog(
                                                                    useRootNavigator:
                                                                        false,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Dialog(
                                                                        child:
                                                                            ListView(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 16),
                                                                          shrinkWrap:
                                                                              true,
                                                                          children: [
                                                                            'Confirm brake inspection done',
                                                                          ]
                                                                              .map(
                                                                                (e) => InkWell(
                                                                                    child: Container(
                                                                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                                      child: Text(e),
                                                                                    ),
                                                                                    onTap: () {
                                                                                      ScheduleMethods().updateBrake(dateEngine, snap['scheduleId']); // remove the dialog box
                                                                                      Navigator.of(context).pop();
                                                                                    }),
                                                                              )
                                                                              .toList(),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .done_all_rounded,
                                                                  color:
                                                                      secondaryColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const Divider(),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Engine air filter replacement',
                                                                    style:
                                                                        emp_dark,
                                                                  ),
                                                                  _getDaysLeft(snap[
                                                                      'engineDate']),
                                                                ],
                                                              ),
                                                              const Spacer(),
                                                              // update schedule when pressed
                                                              IconButton(
                                                                onPressed: () {
                                                                  showDialog(
                                                                    useRootNavigator:
                                                                        false,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Dialog(
                                                                        child:
                                                                            ListView(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 16),
                                                                          shrinkWrap:
                                                                              true,
                                                                          children: [
                                                                            'Confirm engine air filter replacement done',
                                                                          ]
                                                                              .map(
                                                                                (e) => InkWell(
                                                                                    child: Container(
                                                                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                                      child: Text(e),
                                                                                    ),
                                                                                    onTap: () {
                                                                                      ScheduleMethods().updateEngine(dateEngine, snap['scheduleId']);
                                                                                      // remove the dialog box
                                                                                      Navigator.of(context).pop();
                                                                                    }),
                                                                              )
                                                                              .toList(),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .done_all_rounded,
                                                                  color:
                                                                      secondaryColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const Divider(),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ])),
                                          ),
                                        ]),
                                  );
                                },
                              ),
                            ]);
                    },
                  ),
                  // add records and history acess
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => AddRecordScreen(
                                        carid: carData['carId'],
                                      )),
                            );
                          },
                          child: Container(
                              width: 145,
                              height: 100,
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: secondaryColor,
                              ),
                              child: Column(children: [
                                Text(
                                  "Add records",
                                  style: emp_bold,
                                ),
                                const Icon(
                                  Icons.upload_rounded,
                                )
                              ])),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => PastRecords(
                                        carid: carData['carId'],
                                      )),
                            );
                          },
                          child: Container(
                              width: 145,
                              height: 100,
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: secondaryColor,
                              ),
                              child: Column(children: [
                                Text(
                                  "Access History",
                                  style: emp_bold,
                                ),
                                const Icon(
                                  Icons.archive_rounded,
                                )
                              ])),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }

  _getDaysLeft(String date) {
    String output = '';
    DateTime dates = DateFormat('MM/dd/yyyy').parse(date);
    Duration difference = dates.difference(now);
    int res = difference.inDays;
    if (res == 0) {
      output = 'Scheduled today';
      return Text(
        output,
        style: sucess,
      );
    } else if (res > 0) {
      output = "Scheduled ${res} days ahead";
      return Text(
        output,
        style: emp_dark,
      );
    } else {
      output = "Scheduled ${-res} days ago";
      return Text(
        output,
        style: warning,
      );
    }
  }
}
