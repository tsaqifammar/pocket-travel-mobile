import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pocket_travel_mobile/providers/user_login_provider.dart';
import 'package:pocket_travel_mobile/utils/urls.dart';
import 'package:pocket_travel_mobile/widgets/country_picker.dart';
import 'package:pocket_travel_mobile/widgets/date_picker.dart';
import 'package:pocket_travel_mobile/widgets/time_picker.dart';
import 'package:pocket_travel_mobile/utils/status_snackbars.dart';

enum ActionMenu { edit, delete }

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
  Map<String,dynamic> _diary = {};
  bool _firstRun = false;
  bool _dbg = false;
  var _dbMsg;
  late String _token;
  var _response;

  Future<void> _getDiary() async {
    setState(() {
      _firstRun = true;
    });
    if (this.isPublic) {
      _response = await http.get(Uri.parse('${URLS.BACKEND}/public'));
    } else {
      Map<String, String> _headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token'
      };
      _response = await http.get(Uri.parse('${URLS.BACKEND}/diary'), headers: _headers);
    }
    setState(() {
      if (_response.statusCode == 200) _diaries = jsonDecode(_response.body)['data'];
      _dbMsg = _diaries;
      _firstRun = false;
    });
  }

  Future<void> _addDiary(Map<String,dynamic> diary) async {
    diary['isPublic'] = true;
    Map<String, String> _headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token'
    };
    _response = await http.post(Uri.parse('${URLS.BACKEND}/diary'), headers: _headers, body: jsonEncode(diary));
    if (_response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        StatusSnackBar.success('Success')
      );
      await _getDiary();
    };
  }

  Future<void> _updateDiary(Map<String,dynamic> diary) async {
    diary['isPublic'] = true;
    Map<String, String> _headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token'
    };
    _response = await http.put(Uri.parse('${URLS.BACKEND}/diary/${diary['_id']}'), headers: _headers, body: jsonEncode(diary));
    if (_response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        StatusSnackBar.success('Success')
      );
      await _getDiary();
    };
  }

  Future<void> _deleteDiary(String id) async {
    Map<String, String> _headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token'
    };
    _response = await http.delete(Uri.parse('${URLS.BACKEND}/diary/$id'), headers: _headers);
    if (_response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        StatusSnackBar.success('Success')
      );
      await _getDiary();
    };
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _token = context.read<UserLoginProvider>().getToken;
      await _getDiary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await _getDiary();
        },
        child: () {
          if (_firstRun) return const Center(child: CircularProgressIndicator());
          return ListView(
            children: [
              if (_dbg) _buildBox(Text("$_dbMsg")),
              _buildBox(_buildHeader(context)),
              for (var _diary in _diaries)
                _buildBox(_buildPostCard(context, _diary)),],);
        }(),
      ),);
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (this.isPublic) const Text('Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
        else const Text('Diary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        if (!this.isPublic) ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => _buildForm(context, "store", _diary),
            );
          },
          child: const Text('Create +'),),],);
  }

  Widget _buildPostCard(BuildContext context, var diary) {
    return Column(
      children: [
        ListTile(
          dense: true,
          leading: FlutterLogo(),
          trailing: (!this.isPublic) ? PopupMenuButton<ActionMenu>(
            onSelected: (ActionMenu item) async {
              if (item.name == 'edit') {
                showDialog(
                  context: context,
                  builder: (context) => _buildForm(context, "update", diary),
                );
              } else {
                await _deleteDiary(diary['_id']);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ActionMenu.edit,
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: ActionMenu.delete,
                child: Text('Delete'),
              ),
            ],
          ) : Text(""),
          title: Text("${diary['user']}"),
          subtitle: Row(
          children: [
            Flag.fromString("${diary['country']}", height: 13.5, width: 18, replacement: Text("${diary[1]}"),),
            Text("  ${diary['location']}"),],),),
        Image.network("${diary['image']}"),
        ListTile(
          title: Text("${diary['caption']}"),
          subtitle: Text("${diary['created_at']}"),
          dense: true,),],);
  }

  Widget _buildForm(BuildContext context, String mode, var diary) {
    // FormState form = Form.of(context);
    final _formKey = GlobalKey<FormState>();
    return AlertDialog(
      content: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Diary',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CountryPicker(
                    onSaved: (value) {
                      diary['country'] = value;},
                    initialValue: diary['country'],),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      icon: Icon(Icons.location_pin),),
                    validator: (value) => (value == null || value.isEmpty ? 'Please enter some text' : null),
                    onSaved: (value) { diary['location'] = value; },
                    initialValue: diary['location']),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Image',
                      icon: Icon(Icons.image_rounded),),
                    validator: (value) => (value == null || value.isEmpty ? 'Please enter some text' : null),
                    onSaved: (value) { diary['image'] = value; },
                    initialValue: diary['image']),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Caption',
                      icon: Icon(Icons.text_fields),),
                    validator: (value) => (value == null || value.isEmpty ? 'Please enter some text' : null),
                    onSaved: (value) { diary['caption'] = value; },
                    initialValue: diary['caption']),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (mode == "store") {
                          await _addDiary(diary);
                        } else {
                          await _updateDiary(diary);
                        }
                        Navigator.of(context).pop();
                      }
                    },),)],),),
          Positioned(
            right: 0,
            top: 0,
            child: InkResponse(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.close, color: Colors.grey),
            ),),],),);
  }
}