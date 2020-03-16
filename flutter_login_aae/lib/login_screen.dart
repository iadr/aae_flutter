import 'dart:convert';

import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_login_aae/Models/serverInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'custom_route.dart';
import 'dashboard_screen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      // if (!mockUsers.containsKey(data.name)) {
      //   return 'Username not exists';
      // }
      // if (mockUsers[data.name] != data.password) {
      //   return 'Password does not match';
      // }
      // return null;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map query = {'_username': data.name, '_password': data.password};
      var jsonResponse;

      var response =
          await http.post("${ServerInfo.host}/api/login_check", body: query);

      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        if (jsonResponse != null) {
          sharedPreferences.setString("token", jsonResponse['token']);
          sharedPreferences.setBool("loggedIn", true);
          return null;
        }
      } else {
        print(response.statusCode);
        print(response.body);
      }
      return "Ocurrió un problema, intenta mas tarde";
    });
  }

  Future<String> _signupUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      Map query = {'_email': data.name, '_password': data.password};

      var response =
          await http.post("${ServerInfo.host}/api/register", body: query);

      if (response.statusCode == 200) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        query = {'_username': data.name, '_password': data.password};
        var jsonResponse;

        response =
            await http.post("${ServerInfo.host}/api/login_check", body: query);

        if (response.statusCode == 200) {
          jsonResponse = json.decode(response.body);
          if (jsonResponse != null) {
            sharedPreferences.setString("token", jsonResponse['token']);
            sharedPreferences.setBool("loggedIn", true);
            return null;
          }
        } else {
          print(response.statusCode);
          print(response.body);
        }
      }
      return "Ocurrió un problema, intenta de nuevo";
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      // if (!mockUsers.containsKey(name)) {
      //   return 'Username not exists';
      // }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final inputBorder = BorderRadius.vertical(
    //   bottom: Radius.circular(10.0),
    //   top: Radius.circular(20.0),
    // );

    return FlutterLogin(
      title: Constants.appName,
      logo: 'assets/images/logo.png',
      logoTag: Constants.logoTag,
      titleTag: Constants.titleTag,
      messages: LoginMessages(
        //   usernameHint: 'Username',
        //   passwordHint: 'Pass',
        //   confirmPasswordHint: 'Confirm',
        //   loginButton: 'LOG IN',
        //   signupButton: 'REGISTER',
        //   forgotPasswordButton: 'Forgot huh?',
        //   recoverPasswordButton: 'HELP ME',
        //   goBackButton: 'GO BACK',
        confirmPasswordError: 'Not match!',
        //   recoverPasswordIntro: 'Don\'t feel bad. Happens all the time.',
        //   recoverPasswordDescription: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
        //   recoverPasswordSuccess: 'Password rescued successfully',
      ),
      theme: LoginTheme(
        primaryColor: Colors.teal,
        accentColor: Theme.of(context).accentColor,
        errorColor: Colors.deepOrange,
        pageColorLight: Colors.indigo.shade300,
        pageColorDark: Colors.indigo.shade500,
        titleStyle: TextStyle(
          color: Colors.greenAccent,
          fontFamily: 'Quicksand',
          letterSpacing: 4,
        ),
        //   // beforeHeroFontSize: 50,
        //   // afterHeroFontSize: 20,
        //   bodyStyle: TextStyle(
        //     fontStyle: FontStyle.italic,
        //     decoration: TextDecoration.underline,
        //   ),
        //   textFieldStyle: TextStyle(
        //     color: Colors.orange,
        //     shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
        //   ),
        //   buttonStyle: TextStyle(
        //     fontWeight: FontWeight.w800,
        //     color: Colors.yellow,
        //   ),
        //   cardTheme: CardTheme(
        //     color: Colors.yellow.shade100,
        //     elevation: 5,
        //     margin: EdgeInsets.only(top: 15),
        //     shape: ContinuousRectangleBorder(
        //         borderRadius: BorderRadius.circular(100.0)),
        //   ),
        //   inputTheme: InputDecorationTheme(
        //     filled: true,
        //     fillColor: Colors.purple.withOpacity(.1),
        //     contentPadding: EdgeInsets.zero,
        //     errorStyle: TextStyle(
        //       backgroundColor: Colors.orange,
        //       color: Colors.white,
        //     ),
        //     labelStyle: TextStyle(fontSize: 12),
        //     enabledBorder: UnderlineInputBorder(
        //       borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
        //       borderRadius: inputBorder,
        //     ),
        //     focusedBorder: UnderlineInputBorder(
        //       borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
        //       borderRadius: inputBorder,
        //     ),
        //     errorBorder: UnderlineInputBorder(
        //       borderSide: BorderSide(color: Colors.red.shade700, width: 7),
        //       borderRadius: inputBorder,
        //     ),
        //     focusedErrorBorder: UnderlineInputBorder(
        //       borderSide: BorderSide(color: Colors.red.shade400, width: 8),
        //       borderRadius: inputBorder,
        //     ),
        //     disabledBorder: UnderlineInputBorder(
        //       borderSide: BorderSide(color: Colors.grey, width: 5),
        //       borderRadius: inputBorder,
        //     ),
        //   ),
        buttonTheme: LoginButtonTheme(
          splashColor: Colors.indigo.shade100,
          backgroundColor: Colors.indigo.shade500,
          highlightColor: Colors.indigo.shade300,
          // splashColor: Colors.purple,
          // backgroundColor: Colors.pinkAccent,
          // highlightColor: Colors.lightGreen,
          elevation: 9.0,
          highlightElevation: 6.0,
          // shape: BeveledRectangleBorder(
          //   borderRadius: BorderRadius.circular(10),
          // ),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          // shape: CircleBorder(side: BorderSide(color: Colors.green)),
          // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
        ),
      ),
      emailValidator: (value) {
        if (!value.contains('@') || !value.endsWith('.com')) {
          return "Email must contain '@' and end with '.com'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty) {
          return 'Password is empty';
        }
        return null;
      },
      onLogin: (loginData) {
        print('Login info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _loginUser(loginData);
      },
      onSignup: (loginData) {
        print('Signup info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _signupUser(loginData);
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => DashboardScreen(),
        ));
      },
      onRecoverPassword: (name) {
        print('Recover password info');
        print('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
      // showDebugButtons: true,
    );
  }
}
