import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:animate_navigator_transition_do/animate_navigator_transition_do.dart';
import 'package:pocket_travel_mobile/screens/home_page_after_login.dart';

import 'package:pocket_travel_mobile/services/login_service.dart';

class LoginSignUpScreen extends StatelessWidget {
  const LoginSignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var loginService = LoginService(context);

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
      onLogin: loginService.authUser,
      onSignup: loginService.signupUser,
      onRecoverPassword: loginService.recoverPassword,
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
