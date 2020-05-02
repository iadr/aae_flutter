import 'dart:convert';
import 'dart:io';

import 'package:aae/models/subject.dart';
import 'package:aae/providers/login_state.dart';
import 'package:aae/providers/server_requests.dart';
import 'package:aae/utils/drawer.dart';
import 'package:aae/utils/server_info.dart';
import 'package:aae/views/tutor/add_subjects.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({Key key}) : super(key: key);

  @override
  _SubjectsScreenState createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  SubjectsList sList;

  @override
  void initState() {
    super.initState();
    Requests.getMySubjects(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Materias'),
      ),
      drawer: myDrawer(context),
      body: _subjectList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(FontAwesomeIcons.plus),
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AddSubjectsScreen()))
              .then((value) {
            setState(() {});
          });
        },
      ),
    );
  }

  _subjectList() {
    return FutureBuilder(
        future: Requests.getMySubjects(context),
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
                      child: Icon(FontAwesomeIcons.book),
                    ),
                    trailing: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.times,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          this.deleteSubject(context, subject.id);
                        }),
                    title: Text(subject.name),
                    subtitle: Text(subject.level),
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

  deleteSubject(BuildContext context, int id) async {
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

      setState(() {});
    }
  }
}
