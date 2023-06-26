// ignore_for_file: use_build_context_synchronously

import 'dart:ffi';
import 'dart:typed_data';

import 'package:carlife/resources/recordMethods.dart';
import 'package:carlife/widgets/inputs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carlife/utilis/colors.dart';
import 'package:carlife/utilis/utilis.dart';
import 'package:intl/intl.dart';

import '../utilis/fonts.dart';

class AddRecordScreen extends StatefulWidget {
  final String carid;

  const AddRecordScreen({Key? key, required this.carid}) : super(key: key);

  @override
  _AddRecordScreenState createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  var carData = {};
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  DateTime _dateAddedController = DateTime.now();

  @override
// initializing the page with car details
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

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Add a record'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void addRecord(String carid) async {
    setState(() {
      isLoading = true;
      Navigator.pop(context);
    });

    // start the loading
    try {
      // upload to storage and db
      String res = await RecordMethods().uploadRecords(
        _noteController.text,
        _file!,
        carid,
        _costController.text,
        DateFormat.yMd().format(_dateAddedController),
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          'Posted!',
          context,
        );
        clearImage();
      } else {
        showSnackBar(res, context);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        err.toString(),
        context,
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _file == null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_rounded),
              ),
              title: const Text(
                'Add a record',
              ),
              centerTitle: false,
            ),
            body: Center(
              child: IconButton(
                icon: const Icon(
                  Icons.upload_rounded,
                ),
                onPressed: () => _selectImage(context),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text(
                'Add',
              ),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                    onPressed: () => addRecord(carData['carId']),
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: primaryColor,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Upload',
                        style: emp_button,
                      ),
                    ))
              ],
            ),
            // POST FORM
            body: Column(
              children: <Widget>[
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: _noteController,
                        decoration: const InputDecoration(
                            hintText: "Add a note...",
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      width: 45.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                            image: MemoryImage(_file!),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: _costController,
                    decoration: const InputDecoration(
                        hintText: "Add cost", border: InputBorder.none),
                  ),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: InputFields(
                      title: "Date of activity",
                      hint: DateFormat.yMd().format(_dateAddedController),
                      widget: IconButton(
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _getDate();
                        },
                      )),
                ),
              ],
            ),
          );
  }

  _getDate() async {
    DateTime? _pickedDate = await _showDatePicker();
    if (_pickedDate != null) {
      setState(() {
        _dateAddedController = _pickedDate;
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
