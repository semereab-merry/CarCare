// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:typed_data';
import 'package:carlife/responsive/mobileScreenLayout.dart';
import 'package:carlife/responsive/responsive_layout.dart';
import 'package:carlife/responsive/webScreenLayout.dart';
import 'package:flutter/material.dart';
import 'package:carlife/resources/detailsMethods.dart';
import 'package:carlife/utilis/colors.dart';
import 'package:carlife/utilis/utilis.dart';

import 'package:carlife/providers/userProvider.dart';
import 'package:provider/provider.dart';

import '../utilis/fonts.dart';
import 'package:carlife/widgets/inputs.dart';

class AddCarsScreen extends StatefulWidget {
  const AddCarsScreen({super.key});

  @override
  State<AddCarsScreen> createState() => _AddCarsScreenState();
}

class _AddCarsScreenState extends State<AddCarsScreen> {
  final TextEditingController _titecontroller = TextEditingController();
  String _brandController = " ";
  List<String> brandList = ['Toyota', 'Hyundai', 'Nissan', 'Other'];
  bool _isLoading = false;

  void addcars(
    String title,
    String brand,
    String uid,
  ) async {
    setState(() {
      _isLoading = true;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                // mobileScreenLayout: HomeScreen(),
                webScreenLayout: WebScreenLayout(),
              )));
    });

    // start the loading
    try {
      // upload to storage and db
      String res = await DetailsMethods().addCars(
        title,
        brand,
        uid,
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
    _titecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
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
              padding: const EdgeInsets.symmetric(horizontal: 32),
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
                    "Add Car Profile",
                    style: follow,
                  ),

                  // separator
                  const SizedBox(
                    height: 24,
                  ),

                  InputFields(
                    title: "Your car brand brand",
                    hint: _brandController,
                    widget: DropdownButton(
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      elevation: 4,
                      iconSize: 24,
                      underline: Container(height: 0),
                      items: brandList.map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: emp),
                          );
                        },
                      ).toList(),
                      onChanged: (String? newvalue) {
                        setState(() {
                          _brandController = newvalue!;
                        });
                      },
                    ),
                  ),

                  InputFields(
                    title: "Put a nickname for your car",
                    hint: "Abc",
                    controller: _titecontroller,
                  ),
// separator
                  const SizedBox(
                    height: 24,
                  ),
                  InkWell(
                      onTap: () => addcars(
                            _titecontroller.text,
                            _brandController,
                            userProvider.getUser.uid,
                          ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: primaryColor,
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Add vehicle',
                          style: emp_button,
                        ),
                      )),
                ],
              ))),
        ));
  }
}
