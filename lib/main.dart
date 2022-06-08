import 'package:flutter/material.dart';
import 'package:pocket_travel_mobile/screens/home_page_before_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePageBeforeLogin(),
    );
  }
}
