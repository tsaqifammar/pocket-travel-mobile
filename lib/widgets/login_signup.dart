import 'dart:js';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:animate_navigator_transition_do/animate_navigator_transition_do.dart';
import 'package:pocket_travel_mobile/screens/home_page_after_login.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_travel_mobile/utils/urls.dart';
import 'package:pocket_travel_mobile/providers/user_login_provider.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

//TODO factorize jadi service

class LoginSignUpScreen extends StatelessWidget {
  const LoginSignUpScreen({Key? key}) : super(key: key);

  Duration get loginTime => Duration(milliseconds: 2250);
  @override
  Widget build(BuildContext context) {
    void _updateUserLoginProvider(BuildContext context, userId, token) {
      Provider.of<UserLoginProvider>(context, listen: false)
          .updateUserIdToken(userId, token);
    }

    _sendLoginRequest(email, password) async {
      var url = Uri.parse(
        '${URLS.BACKEND}/login',
      );
      var body = <String, String>{"email": email, "password": password};

      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(body));

      if (response.statusCode == 200) {
        var userid = jsonDecode(response.body)['user']['user_id'];
        var token = jsonDecode(response.body)['token'];
        _updateUserLoginProvider(context, userid, token);
      }
      return response;
    }

    _sendSignupRequest(name, email, password) async {
      var url = Uri.parse(
        '${URLS.BACKEND}/register',
      );
      var body = <String, String>{
        "name": name,
        "email": email,
        "password": password
      };

      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(body));

      await _sendLoginRequest(email, password);

      return response;
    }

    Future<String?> _authUser(LoginData data) async {
      var response = await _sendLoginRequest(data.name, data.password);

      return Future.delayed(loginTime).then((_) {
        if (response.statusCode == 400) {
          return 'Incorrect username or password.';
        }
        if (response.statusCode != 200) {
          return 'Internal server error';
        }

        return null;
      });
    }

    Future<String?> _signupUser(SignupData data) async {
      var response = await _sendSignupRequest(
          data.additionalSignupData?.values.toList()[0],
          data.name,
          data.password);

      return Future.delayed(loginTime).then((_) {
        if (response.statusCode == 400) {
          return jsonDecode(response.body)['message'];
        }
        if (response.statusCode != 201) {
          return 'Internal server error';
        }
        return null;
      });
    }

    //not used but required
    Future<String> _recoverPassword(String name) {
      return Future.delayed(loginTime).then((_) {
        return '';
      });
    }

    return FlutterLogin(
      additionalSignupFields: [
        UserFormField(
            keyName: 'Name',
            userType: LoginUserType.name,
            fieldValidator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            })
      ],
      onLogin: _authUser,
      onSignup: _signupUser,
      onRecoverPassword: _recoverPassword,
      hideForgotPasswordButton: true,
      onSubmitAnimationCompleted: () {
        AnimateNavigationTrasitionDo(
            context: context, //BuildContext
            childPage: HomePageAfterLogin(), // Page to go
            animation: AnimationType.scale,
            duration: Duration(milliseconds: 300));
      },
    );
  }
}
