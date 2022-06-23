import 'package:flutter/material.dart';
import 'package:flag/flag.dart';

bool firstRun = true;

class PublicDiaries extends StatefulWidget {
  @override
  _PublicDiariesState createState() => _PublicDiariesState();
}

class _PublicDiariesState extends State {
  List <List<String>> _diaries = [["The Benevolent Admin", "FR", "La Rochelle", "https://upload.wikimedia.org/wikipedia/commons/d/d8/Siege_of_La_Rochelle_1881_Henri_Motte.png", "Oh no, Anyway.", "2022-02-22"],];

  void _fetchDiary() {
    _diaries = [["The Malevolent Admin", "FR", "La Rochelle", "https://upload.wikimedia.org/wikipedia/commons/d/d8/Siege_of_La_Rochelle_1881_Henri_Motte.png", "Oh no, Anyway.", "2022-02-22"],];
    firstRun = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(_fetchDiary);
          return Future<void>.delayed(const Duration(seconds: 2));},
        child:
          ListView (
            children: [
              buildHeader(true),
              for (List<String> _diary in _diaries)
                buildPostCard(_diary),],),),);
  }
}

class PrivateDiaries extends StatefulWidget {
  @override
  _PrivateDiariesState createState() => _PrivateDiariesState();
}

class _PrivateDiariesState extends State {
  List <List<String>> _diaries = [["The Malevolent Admin", "FR", "La Rochelle", "https://upload.wikimedia.org/wikipedia/commons/d/d8/Siege_of_La_Rochelle_1881_Henri_Motte.png", "Oh no, Anyway.", "2022-02-22"],];

  void _fetchDiary() {
    _diaries = [["The Benevolent Admin", "FR", "La Rochelle", "https://upload.wikimedia.org/wikipedia/commons/d/d8/Siege_of_La_Rochelle_1881_Henri_Motte.png", "Oh no, Anyway.", "2022-02-22"],];
    firstRun = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(_fetchDiary);
          return Future<void>.delayed(const Duration(seconds: 2));},
        child:
          ListView (
            children: [
              buildHeader(false),
              for (List<String> _diary in _diaries)
                buildPostCard(_diary),],),),);
  }
}

Widget buildHeader(bool isPublic) {
  return Container(
      padding: const EdgeInsets.all(15),
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey.shade400),
        color: Colors.white
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isPublic) const Text('Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
          else const Text('Diary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          if (!isPublic) ElevatedButton(
            onPressed: () {},
            child: const Text('Create +'),),],),);
}

Widget buildPostCard(List<String> diary) {
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
              Flag.fromString("${diary[1]}", height: 13.5, width: 18, replacement: Text("${diary[1]}"),),
              Text("  ${diary[2]}"),],),),
        if (firstRun) Image.asset('2p3dw0.jpg')
        else  Image.network("${diary[3]}"), // image
        ListTile(
          title: Text("${diary[4]}"), // caption
          subtitle: Text("${diary[5]}"), // date
          dense: true,),],),);
}