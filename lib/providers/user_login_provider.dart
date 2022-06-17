import 'package:flutter/cupertino.dart';

class UserLoginProvider extends ChangeNotifier {
  var _userId = '';
  var _token = 'sowa';

  String get getUserId {
    return _userId;
  }

  String get getToken {
    return _token;
  }

  void updateUserIdToken(userId, token) {
    _userId = userId;
    _token = token;
    notifyListeners();
  }
}
