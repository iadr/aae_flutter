import 'dart:convert';
import 'dart:io';

import 'package:aae/models/subject.dart';
import 'package:aae/providers/login_state.dart';
import 'package:aae/utils/drawer.dart';
import 'package:aae/utils/server_info.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _search = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Noticias'),
      ),
      drawer: myDrawer(context),
      body: _body(),
    );
  }

  Future<SubjectsList> getSubjects(BuildContext context) async {
    final session = Provider.of<LoginState>(context, listen: false);
    // print(session.token);
    // var response = await http.get(ServerInfo.host + '/api/aae/tutors/subjects/new',
    var response = await http.get(ServerInfo.host + '/api/aae/subjects',
        headers: {HttpHeaders.authorizationHeader: session.token});
    var jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);
      // print('dashboard: ${response.body}');
      return SubjectsList.fromJson(jsonResponse);
    } else {
      print(response.body);
    }
    setState(() {});
    return null;
  }

  _body() {
    return Column(
        children: <Widget>[
          MaterialButton(
            onPressed: () {
              setState(() {
                _search = true;
              });
            },
            child: Text('Show available subjects'),
          ),
          (!_search)
              ? Container()
              : Expanded(
                  child:
                      // ListView.builder(
                      //   itemCount: sList.subjects.length,
                      //   itemBuilder: (BuildContext context, int index) {
                      //     Subject subject = sList.subjects[index];
                      //     return ListTile(
                      //       leading: CircleAvatar(
                      //         child: Icon(FontAwesomeIcons.bookOpen),
                      //       ),
                      //       title: Text(subject.name),
                      //       subtitle: Text(subject.level),
                      //     );
                      //   },
                      // ),
                      FutureBuilder(
                          future: getSubjects(context),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              SubjectsList sList = snapshot.data;
                              return ListView.builder(
                                  itemCount: sList.subjects.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                          child:
                                              Icon(FontAwesomeIcons.bookOpen)),
                                      title: Text(sList.subjects[index].name),
                                      subtitle: Text(sList.subjects[index].level),
                                    );
                                  });
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Icon(Icons.error_outline),
                              );
                            } else {
                              return Column(
                                children: <Widget>[
                                  SizedBox(
                                    child: CircularProgressIndicator(),
                                    width: 60,
                                    height: 60,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Text('Awaiting result...'),
                                  )
                                ],
                              );
                            }
                          }),
                ),
        ],
      );
  }
}
