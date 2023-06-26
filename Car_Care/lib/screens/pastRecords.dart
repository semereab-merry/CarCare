import 'package:carlife/resources/recordMethods.dart';
import 'package:carlife/utilis/dimensions.dart';
import 'package:carlife/utilis/fonts.dart';
import 'package:carlife/utilis/utilis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carlife/utilis/colors.dart';
import 'package:carlife/utilis/globalVariable.dart';
import 'package:intl/intl.dart';

class PastRecords extends StatefulWidget {
  final String carid;

  const PastRecords({Key? key, required this.carid}) : super(key: key);

  @override
  State<PastRecords> createState() => _PastRecordsState();
}

class _PastRecordsState extends State<PastRecords> {
  var carData = {};

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {});
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
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              elevation: 5,
              centerTitle: false,
              title: Text(
                "Your past records",
                style: subHeading,
              ),
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_rounded),
              ),
            ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('records')
                  .where('carid', isEqualTo: carData['carId'])
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
                        child:
                            ListView(scrollDirection: Axis.vertical, children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: Text(
                                "No added records",
                                style: emp_grey,
                              ),
                            ),
                          )
                        ]))
                    : Column(children: [
                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                (snapshot.data! as dynamic).docs[index];

                            return SizedBox(
                              child: ListView(
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    snap['notes'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  IconButton(
                                                    onPressed: () {
                                                      showDialog(
                                                        useRootNavigator: false,
                                                        context: context,
                                                        builder: (context) {
                                                          return Dialog(
                                                            child: ListView(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          16),
                                                              shrinkWrap: true,
                                                              children: [
                                                                'Delete record',
                                                              ]
                                                                  .map(
                                                                    (e) => InkWell(
                                                                        child: Container(
                                                                          padding: const EdgeInsets.symmetric(
                                                                              vertical: 12,
                                                                              horizontal: 16),
                                                                          child:
                                                                              Text(e),
                                                                        ),
                                                                        onTap: () {
                                                                          RecordMethods()
                                                                              .deleteRecord(snap['recordId']);
                                                                          // remove the dialog box
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        }),
                                                                  )
                                                                  .toList(),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: const Icon(
                                                        Icons.more_vert),
                                                  )
                                                ],
                                              ),
                                              // date added and cost
                                              Text(
                                                snap['dateAdded'],
                                                style: const TextStyle(
                                                  color: secondaryColor,
                                                ),
                                              ),
                                              Text(
                                                'Cost: ' + snap['cost'],
                                                style: const TextStyle(
                                                  color: secondaryColor,
                                                ),
                                              ),
// the picture added
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    useRootNavigator: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        child: ListView(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        16),
                                                            shrinkWrap: true,
                                                            children: [
                                                              SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    1,
                                                                width: double
                                                                    .infinity,
                                                                child: Image
                                                                    .network(
                                                                  snap['photoUrl']
                                                                      .toString(),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ]
                                                                .map(
                                                                  (e) => InkWell(
                                                                      child: Container(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            vertical:
                                                                                12,
                                                                            horizontal:
                                                                                16),
                                                                        child:
                                                                            e,
                                                                      ),
                                                                      onTap: () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      }),
                                                                )
                                                                .toList()),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.20,
                                                  width: double.infinity,
                                                  child: Image.network(
                                                    snap['photoUrl'].toString(),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ])),
                                  ]),
                            );
                          },
                        ),
                      ]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
