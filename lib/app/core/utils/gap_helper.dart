import 'package:flutter/material.dart';

class Gap {
  static SizedBox h(double value) => SizedBox(height: value);
  static SizedBox w(double value) => SizedBox(width: value);

  static SizedBox get v4 => h(4);
  static SizedBox get v8 => h(8);
  static SizedBox get v10 => h(10);
  static SizedBox get v12 => h(12);
  static SizedBox get v16 => h(16);
  static SizedBox get v20 => h(20);

  static SizedBox get h4 => w(4);
  static SizedBox get h8 => w(8);
  static SizedBox get h10 => w(10);
  static SizedBox get h12 => w(12);
  static SizedBox get h16 => w(16);
  static SizedBox get h20 => w(20);
}
