
import 'package:flutter/material.dart';

class StatusSnackBar {
  static var error = (message) => SnackBar(content: Text(message), backgroundColor: Colors.red);
  static var success = (message) => SnackBar(content: Text(message), backgroundColor: Colors.green);
}
