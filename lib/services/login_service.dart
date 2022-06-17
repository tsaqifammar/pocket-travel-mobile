import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pocket_travel_mobile/providers/user_login_provider.dart';
import 'package:pocket_travel_mobile/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_login/flutter_login.dart';

import 'dart:convert';

class LoginService {
  var _context;
  Duration get loginTime => const Duration(milliseconds: 2250);
  LoginService(BuildContext context) {
    _context = context;
  }

  void _updateUserLoginProvider(BuildContext context, userId, token) {
    Provider.of<UserLoginProvider>(context, listen: false)
        .updateUserIdToken(userId, token);
  }

  sendLoginRequest(email, password) async {
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
      _updateUserLoginProvider(_context, userid, token);
    }
    return response;
  }

  sendSignupRequest(name, email, password) async {
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

    await sendLoginRequest(email, password);

    return response;
  }

  Future<String?> authUser(LoginData data) async {
    var response = await sendLoginRequest(data.name, data.password);

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

  Future<String?> signupUser(SignupData data) async {
    var response = await sendSignupRequest(
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
  Future<String> recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      return '';
    });
  }
}
