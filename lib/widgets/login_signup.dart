import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:animate_navigator_transition_do/animate_navigator_transition_do.dart';
import 'package:pocket_travel_mobile/screens/home_page_after_login.dart';

const users = {
  'alif@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginSignUpScreen extends StatelessWidget {
  const LoginSignUpScreen({Key? key}) : super(key: key);

  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint(
        'email: ${data.name}, Password: ${data.password}, nama: ${data.additionalSignupData?.values}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  //not used but required
  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      return '';
    });
  }

  @override
  Widget build(BuildContext context) {
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
