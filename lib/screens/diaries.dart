import 'package:flutter/material.dart';
import 'package:flag/flag.dart';

class PublicDiaries extends StatefulWidget {
  @override
  _PublicDiariesState createState() => _PublicDiariesState();
}

class _PublicDiariesState extends State {
  List <List<String>> _diaries = [["Admin Who", "GB", "Scarborough", "", "Pull to refresh", "2022-02-22"],];
  bool _firstRun = true;

  void _fetchDiary() {
    _diaries = [["The Benevolent Admin",
              "FR",
              "La Rochelle",
              "https://upload.wikimedia.org/wikipedia/commons/d/d8/Siege_of_La_Rochelle_1881_Henri_Motte.png",
              "Oh no, Anyway.",
              "2022-02-22"],
              ["The Benevolent Admin",
              "FR",
              "La Rochelle",
              "https://upload.wikimedia.org/wikipedia/commons/d/d8/Siege_of_La_Rochelle_1881_Henri_Motte.png",
              "Oh no, Anyway.",
              "2022-02-22"],
              ["The Benevolent Admin",
              "FR",
              "La Rochelle",
              "https://upload.wikimedia.org/wikipedia/commons/d/d8/Siege_of_La_Rochelle_1881_Henri_Motte.png",
              "Oh no, Anyway.",
              "2022-02-22"],];

    _firstRun = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // Replace this delay with the code to be executed during refresh
          // and return a Future when code finish execution.
            setState(_fetchDiary);
          return Future<void>.delayed(const Duration(seconds: 2));
        },
        // Pull from top to show refresh indicator.
        child: ListView (
          children: <Widget> [
            for (List<String> _diary in _diaries) buildPostCard(_diary),
          ],
        ),
      ),
    );
  }

  Widget buildPostCard(List<String> diary){
    return Container(
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.grey.shade400),
      ),
      // alignment: Alignment(-0.9, -0.9),
      child: Column(
        children: [
          ListTile(
            dense: true,
            leading: FlutterLogo(),
            title: Text("${diary[0]}"), // name
            subtitle: Row(
              children: [
                Flag.fromString("${diary[1]}", height: 13.5, width: 18),
                Text("  ${diary[2]}"),
              ],
            ),
          ),
          if (_firstRun) Image.asset('2p3dw0.jpg')
          else  Image.network("${diary[3]}"), // image
          ListTile(
            title: Text("${diary[4]}"), // caption
            subtitle: Text("${diary[5]}"), // date
            dense: true,
          ),
        ],
      ),
    );
  }
}