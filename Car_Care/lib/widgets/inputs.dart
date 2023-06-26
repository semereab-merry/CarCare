// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utilis/colors.dart';

class InputFields extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  const InputFields({
    Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            title,
          ),
          Container(
              height: 52,
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.only(left: 14),
              decoration: BoxDecoration(
                  border: Border.all(color: primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: widget == null ? false : true,
                      controller: controller,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: hint,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: mobileBackgroundColor, width: 0)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: mobileBackgroundColor, width: 0)),
                      ),
                    ),
                  ),
                  widget == null ? Container() : Container(child: widget)
                ],
              ))
        ]));
  }
}
