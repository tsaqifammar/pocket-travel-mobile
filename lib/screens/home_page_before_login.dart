import 'package:flutter/material.dart';
import 'package:pocket_travel_mobile/screens/diaries.dart';
import 'package:pocket_travel_mobile/widgets/login_signup.dart';

class HomePageBeforeLogin extends StatefulWidget {
  const HomePageBeforeLogin({Key? key}) : super(key: key);
  @override
  State<HomePageBeforeLogin> createState() => _HomePageBeforeLoginState();
}

class _HomePageBeforeLoginState extends State<HomePageBeforeLogin> {
  int _selectedNavbar = 0;

  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }

  static List<Widget> _pages = <Widget>[
    PublicDiaries(),
    LoginSignUpScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('PocketTravel',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,),
      body: _pages.elementAt(_selectedNavbar),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Login/Signup',
          ),
        ],
        currentIndex: _selectedNavbar,
        selectedItemColor: const Color(0xFF3E66FB),
        unselectedItemColor: Colors.grey,
        onTap: _changeSelectedNavBar,
      ),
    );
  }
}
