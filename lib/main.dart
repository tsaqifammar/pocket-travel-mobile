import 'package:flutter/material.dart';
import 'screens/Login_signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Center(child: HomePageBeforeLogin()),
    );
  }
}

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
    Center(
      child: Text(
        'Index 0: home',
      ),
    ),
    LoginSignUpScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('PocketTravel',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0),
      body: _pages.elementAt(_selectedNavbar),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun',
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
