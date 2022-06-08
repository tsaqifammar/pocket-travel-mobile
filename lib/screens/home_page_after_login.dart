import 'package:flutter/material.dart';

class HomePageAfterLogin extends StatelessWidget {
  const HomePageAfterLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: const Text('PocketTravel',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.white,
            elevation: 0),
        body: const Center(
          child: Text('dah masuk'),
        ),
      ),
    );
  }
}
