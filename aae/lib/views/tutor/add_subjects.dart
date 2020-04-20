import 'dart:convert';
import 'dart:io';

import 'package:aae/models/subject.dart';
import 'package:aae/providers/login_state.dart';
import 'package:aae/utils/server_info.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddSubjectsScreen extends StatefulWidget {
  AddSubjectsScreen({Key key}) : super(key: key);

  @override
  _AddSubjectsScreenState createState() => _AddSubjectsScreenState();
}

class _AddSubjectsScreenState extends State<AddSubjectsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asociarse a materia'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(FontAwesomeIcons.times),
      ),
      body: _addSubjectsBody(),
    );
  }

  _addSubjectsBody() {
    return FutureBuilder(
        future: _getSubjects(context),
        builder: (context, AsyncSnapshot<SubjectsList> ss) {
          if (ss.hasData) {
            // return ListView.builder(
            //     itemCount: ss.data.subjects.length,
            //     itemBuilder: (context, index) {
            //       Subject subject = ss.data.subjects[index];
            //       return ListTile(
            //         leading: Icon(FontAwesomeIcons.book),
            //         title: Text(subject.name),
            //         subtitle: Text(subject.level),
            //         onTap: () {},
            //       );
            //     });

            return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                      height: 0,
                    ),
                itemCount: ss.data.subjects.length,
                itemBuilder: (context, index) {
                  Subject subject = ss.data.subjects[index];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.grey,
                      child: Icon(FontAwesomeIcons.book)),
                    title: Text(subject.name),
                    subtitle: Text(subject.level),
                    trailing: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.plusCircle,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          _addSubject(context, subject.id);
                        }),
                  );
                });
          } else if (ss.hasError) {
            return Center(
              child: Text(
                'Ocurrió un error, intenta más tarde ...',
                style: TextStyle(
                    color: Colors.red[500],
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Text('Cargando ....')
              ],
            );
          }
        });
  }

  Future<SubjectsList> _getSubjects(BuildContext context) async {
    final session = Provider.of<LoginState>(context, listen: false);
    // print(session.token);
    var response = await http.get(
        ServerInfo.host + '/api/aae/tutors/subjects/new',
        // var response = await http.get(ServerInfo.host + '/api/aae/tutors/subjects',
        // var response = await http.get(ServerInfo.host + '/api/aae/subjects',
        headers: {HttpHeaders.authorizationHeader: session.token});
    var jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);
      // print(response.body);
      return SubjectsList.fromJson(jsonResponse);
    } else {
      print(response.body);
    }
    setState(() {});
  }

  _addSubject(BuildContext context, int subjectId) async {
    final session = Provider.of<LoginState>(context, listen: false);
    // print(session.token);
    String subjectInfo = jsonEncode({'subject_id': subjectId});
    var response = await http.post(
        ServerInfo.host + '/api/aae/tutors/subjects/new',
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
      print(response.statusCode);

      setState(() {});
    }
  }
}
