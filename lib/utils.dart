import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlobalTextSettings {
  static Map<String, double> _sizes = {
    "XL": 30,
    "L": 25,
    "M": 20,
    "S": 16,
    "XS": 14
  };

  static Widget pageTitleText(String title, [String size = "M"]) {
    return Text(
      title,
      textScaler: TextScaler.linear(1),
      style: GoogleFonts.poppins(
        fontSize: _sizes[size.toUpperCase()],
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }

  static Widget FormFieldText(String title, [double size = 18]) {
    return Text(
      title,
      textScaler: TextScaler.linear(1),
      style: GoogleFonts.lato(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
    );
  }
}
