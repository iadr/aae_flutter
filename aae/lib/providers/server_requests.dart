import 'dart:convert';
import 'dart:io';

import 'package:aae/models/appointment.dart';
import 'package:aae/models/subject.dart';
import 'package:aae/providers/login_state.dart';
import 'package:aae/utils/server_info.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Requests {
  static Future<SubjectsList> getMySubjects(BuildContext context) async {
    final session = Provider.of<LoginState>(context, listen: false);
    // print(session.token);
    // var response = await http.get(ServerInfo.host + '/api/aae/tutors/subjects/new',
    var response = await http.get(ServerInfo.host + '/api/aae/tutors/subjects',
        // var response = await http.get(ServerInfo.host + '/api/aae/subjects',
        headers: {HttpHeaders.authorizationHeader: session.token});
    var jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);
      // print('subsect: ${response.body}');
      return SubjectsList.fromJson(jsonResponse);
    } else {
      print(response.body);
    }
    // setState(() {});
    return null;
  }

  static deleteSubject(BuildContext context, int id) async {
    final session = Provider.of<LoginState>(context, listen: false);
    // print(session.token);
    String subjectInfo = jsonEncode({'subject_id': id});
    var response = await http.put(
        ServerInfo.host + '/api/aae/tutors/subjects/delete',
        // var response = await http.get(ServerInfo.host + '/api/aae/tutors/subjects',
        // var response = await http.get(ServerInfo.host + '/api/aae/subjects',
        headers: {
          HttpHeaders.authorizationHeader: session.token,
          HttpHeaders.contentTypeHeader: "application/json"
        },
        body: subjectInfo);
    // var jsonResponse;
    if (response.statusCode != 200) {
      // jsonResponse = jsonDecode(response.body);
      print(response.statusCode);

      return null;
    } else {
      print(response.body);

      // setState(() {});
      
    }
  }

  static Future<AppointmentsList> getMyAppointments(BuildContext context) async {
    final session = Provider.of<LoginState>(context, listen: false);
    // print(session.token);
    // var response = await http.get(ServerInfo.host + '/api/aae/tutors/subjects/new',
    var response = await http.get(ServerInfo.host + '/api/aae/tutors/appointments',
        // var response = await http.get(ServerInfo.host + '/api/aae/subjects',
        headers: {HttpHeaders.authorizationHeader: session.token});
    var jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);
      // print('appointments: ${response.body}');
      return AppointmentsList.fromJson(jsonResponse);
    } else {
      print(response.body);
    }
    // setState(() {});
    return null;
  }
}



