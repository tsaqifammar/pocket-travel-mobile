import 'package:flutter/material.dart';
import 'package:scale_button/scale_button.dart';
import 'package:animate_navigator_transition_do/animate_navigator_transition_do.dart';
import 'package:pocket_travel_mobile/screens/home_page_before_login.dart';
import 'package:pocket_travel_mobile/providers/user_login_provider.dart';
import 'package:pocket_travel_mobile/utils/urls.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:provider/provider.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var token = Provider.of<UserLoginProvider>(context).getToken;

    void _sendLogoutRequest() async {
      var url = Uri.parse(
        '${URLS.BACKEND}/logout',
      );

      var response = await http.delete(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode != 200) {
        throw Exception('token $token tidak valid');
      }
    }

    return ScaleButton(
      onTap: () {
        _sendLogoutRequest();
        AnimateNavigationTrasitionDo(
            context: context, //BuildContext
            childPage: HomePageBeforeLogin(), // Page to go
            animation: AnimationType.scale,
            duration: Duration(milliseconds: 500)); //Animation you want
      },
      bound: 0.4,
      duration: Duration(milliseconds: 100),
      child: Container(
        height: 48.0,
        width: 200.0,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
        child: Text(
          "Logout",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
