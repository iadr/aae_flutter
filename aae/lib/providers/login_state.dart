import 'dart:convert';

import 'package:aae/models/user.dart';
import 'package:aae/utils/server_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginState with ChangeNotifier {

  String _token;
  bool _loggedIn = false;
  bool _loading = false;

  String get text => null;

  isLoading() =>_loading;
  isLoggedIn() => _loggedIn;
  set token(String token) {
    this._token = token;
    notifyListeners();
  }

  get token => _token;
  
  
  void login(String email, String password,BuildContext context) async {
    _loading = true;
    notifyListeners();
    bool res = await signIn(email, password,context);
    _loading = false;
    if (res) {
      _loggedIn = true;
    } else {
      _loggedIn = false;
    }
    print('logged in: $_loggedIn');
    notifyListeners();
  }

  void logOut() async {
    //signOut();
    _loggedIn = false;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password,BuildContext context) async {
    
    final user=Provider.of<User>(context,listen: false);
    
    print('email: $email\npassword: $password');
    Map userData = {'_username': email, '_password': password};
    var jsonResponse;

    var response =
        await http.post(ServerInfo.host + "/api/login_check", body: userData);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      // print(jsonResponse);
      _token = "Bearer " + jsonResponse["token"];
      jsonResponse=jsonResponse['data'];
      user.password=password;
      user.email=email;
      user.name=jsonResponse['name'];
      user.id=jsonResponse['id'];
      user.roles=jsonResponse['roles'].cast<String>();
      print('name: ${user.name}');
      print('name: ${jsonResponse["name"]}');
      print('roles: ${user.roles}');
      print('is tutor?: ${user.isTutor()}');
      print('is student?: ${user.isStudent()}');

      return true;
    } else {
      return false;
    }
  }

  Future<bool> signUp(
      String name, String email, String password, String passwordConfirm) async {
        return true;
      }
}
