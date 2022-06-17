import 'package:flutter/material.dart';
import 'package:pocket_travel_mobile/providers/user_login_provider.dart';
import 'package:pocket_travel_mobile/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LogoutService {
  var _context;
  var _token;
  Duration get loginTime => const Duration(milliseconds: 2250);
  LogoutService(BuildContext context) {
    _context = context;
    _token = Provider.of<UserLoginProvider>(_context).getToken;
  }

  void sendLogoutRequest() async {
    var url = Uri.parse(
      '${URLS.BACKEND}/logout',
    );

    var response = await http.delete(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode != 200) {
      throw Exception('token $_token tidak valid');
    }
  }
}
