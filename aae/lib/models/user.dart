import 'package:flutter/material.dart';

class User with ChangeNotifier {
  int _id;
  String _name;
  String _email;
  List<String> _roles;

  String _address;
  String _studyIn;
  String _password;

  int get id => _id;
  set id(int id) {
    _id = id;
    notifyListeners();
  }

  String get email => _email;
  set email(String email) {
    _email = email;
    notifyListeners();
  }

  String get password => _password;
  set password(String password) {
    _password = password;
    notifyListeners();
  }

  String get name => _name;
  set name(String name) {
    _name = name;
    notifyListeners();
  }

  List<String> get roles => _roles;
  set roles(List<String> roles) {
    _roles = roles;
    notifyListeners();
  }

  String get address => _address;
  set address(String address) {
    _address = address;
    notifyListeners();
  }

  String get studyIn => _studyIn;
  set studyIn(String studyIn) {
    _studyIn = studyIn;
    notifyListeners();
  }

  bool isStudent(){
    return roles.contains('ROLE_STUDENT');
  }
  
  bool isTutor(){
    return roles.contains('ROLE_TUTOR');
  }
}
