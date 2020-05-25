import 'package:flutter/material.dart';

class TutorList {
  List<Tutor> tutors;

  TutorList({this.tutors});

  TutorList.fromJson(Map<String, dynamic> json) {
    if (json['tutors'] != null) {
      tutors = new List<Tutor>();
      json['tutors'].forEach((v) {
        tutors.add(new Tutor.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tutors != null) {
      data['tutors'] = this.tutors.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tutor {
  int id;
  String name;
  String studyIn;

  Tutor({this.id, this.name, this.studyIn});

  Tutor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    studyIn = json['study_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['study_in'] = this.studyIn;
    return data;
  }
}

class User with ChangeNotifier {
  int _id;
  String _name;
  String _email;
  List<String> _roles;

  String _address;
  String _studyIn;
  String _major;
  String _description;
  String _password;

  User();

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
  String get major => _major;
  set major(String major) {
    _major = major;
    notifyListeners();
  }
  String get description => _description;
  set description(String description) {
    _description = description;
    notifyListeners();
  }

  bool isStudent() {
    return roles.contains('ROLE_STUDENT');
  }

  bool isTutor() {
    return roles.contains('ROLE_TUTOR');
  }

  User.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _address = json['address'];
    _studyIn = json['studyIn'];
    _password = json['password'];
    _roles = json['roles'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['email'] = this._email;
    data['address'] = this._address;
    data['studyIn'] = this._studyIn;
    data['password'] = this._password;
    data['roles'] = this._roles;
    return data;
  }
}
