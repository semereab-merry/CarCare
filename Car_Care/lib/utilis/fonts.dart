// ignore_for_file: non_constant_identifier_names

import 'package:carlife/utilis/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle get subHeading {
  return GoogleFonts.arsenal(
      textStyle: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[400]));
}

TextStyle get heading {
  return GoogleFonts.lato(
      textStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold));
}

TextStyle get logo {
  return GoogleFonts.poppins(
      textStyle: const TextStyle(fontSize: 24, color: primaryColor));
}

TextStyle get login {
  return GoogleFonts.arsenal(
      textStyle: const TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));
}

TextStyle get follow {
  return GoogleFonts.arsenal(
      textStyle: const TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white));
}

TextStyle get normal {
  return GoogleFonts.arsenal(
      textStyle: const TextStyle(fontSize: 18, color: Colors.white));
}

TextStyle get emp {
  return GoogleFonts.arsenal(
      textStyle: const TextStyle(fontSize: 15, color: Colors.white));
}

TextStyle get emp_bold {
  return GoogleFonts.arsenal(
      textStyle: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white));
}

TextStyle get emp_grey {
  return GoogleFonts.arsenal(
      fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey);
}

TextStyle get emp_dark {
  return GoogleFonts.arsenal(
      textStyle: const TextStyle(fontSize: 15, color: Colors.black));
}

TextStyle get emp_button {
  return GoogleFonts.arsenal(
      textStyle: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black));
}

TextStyle get link {
  return GoogleFonts.arsenal(
      textStyle: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: logoSelection));
}

TextStyle get sucess {
  return GoogleFonts.arsenal(
      textStyle: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green));
}

TextStyle get warning {
  return GoogleFonts.arsenal(
      textStyle: const TextStyle(fontSize: 15, color: Colors.red));
}
