import 'package:flutter/material.dart';
import 'package:pocket_travel_mobile/screens/diaries.dart';
import 'package:pocket_travel_mobile/screens/plan_page.dart';
import 'package:pocket_travel_mobile/widgets/logout_button.dart';

class HomePageAfterLogin extends StatefulWidget {
  HomePageAfterLogin({Key? key}) : super(key: key);

  @override
  State<HomePageAfterLogin> createState() => _HomePageAfterLoginState();
}

class _HomePageAfterLoginState extends State<HomePageAfterLogin> {
  int _selectedNavbar = 0;

  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }

  static List<Widget> _pages = <Widget>[
    PublicDiary(),
    PrivateDiary(),
    Center(
      child: Text(
        'Index 2: Checklist',
      ),
    ),
    PlanPage(),
    Center(child: LogoutButton())
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
            label: 'Diary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Checklist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Logout',
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
