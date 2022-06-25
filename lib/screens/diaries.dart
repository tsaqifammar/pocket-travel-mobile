import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pocket_travel_mobile/providers/user_login_provider.dart';
import 'package:pocket_travel_mobile/utils/urls.dart';

class PublicDiary extends StatefulWidget {
  @override
  _DiariesState createState() => _DiariesState(true);
}

class PrivateDiary extends StatefulWidget {
  @override
  _DiariesState createState() => _DiariesState(false);
}

class _DiariesState extends State {
  bool isPublic;
  _DiariesState(this.isPublic);

  var _diaries = [];
  bool _firstRun = false;
  bool _dbg = false;
  var _dbMsg;
  late String _token;

  Future<void> _getDiary() async {
    var response;
    if (this.isPublic) {
      response = await http.get(Uri.parse('${URLS.BACKEND}/public'));
    } else {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token'
      };
      response = await http.get(Uri.parse('${URLS.BACKEND}/diary'), headers: headers);
    }
    setState(() {
      if (response.statusCode == 200) _diaries = jsonDecode(response.body)['data'];
    });
    _firstRun = false;
  }

  @override
  void initState() {
    super.initState();
    _token = context.watch<UserLoginProvider>().getToken;
    () async { await _getDiary(); } ();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await _getDiary();
        },
        child:
          ListView (
            children: [
              if (_dbg) _buildBox(Text("$_dbMsg")),
              _buildBox(_buildHeader(this.isPublic)),
              for (var _diary in _diaries)
                _buildBox(_buildPostCard(_diary, _firstRun)),],),),);
  }
}

Widget _buildBox(Widget content) {
  return Container(
      padding: const EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey.shade400),
        color: Colors.white
      ),
      child: content,);
}

Widget _buildHeader(bool isPublic) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      if (isPublic) const Text('Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
      else const Text('Diary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      if (!isPublic) ElevatedButton(
        onPressed: () {},
        child: const Text('Create +'),),],);
}

Widget _buildPostCard(var diary, bool firstRun) {
  return Column(
    children: [
      ListTile(
        dense: true,
        leading: FlutterLogo(),
        title: Text("${diary['user']}"),
        subtitle: Row(
        children: [
          Flag.fromString("${diary['country']}", height: 13.5, width: 18, replacement: Text("${diary[1]}"),),
          Text("  ${diary['location']}"),],),),
      if (firstRun) Image.asset('2p3dw0.jpg')
      else  Image.network("${diary['image']}"),
      ListTile(
        title: Text("${diary['caption']}"),
        subtitle: Text("${diary['created_at']}"),
        dense: true,),],);
}