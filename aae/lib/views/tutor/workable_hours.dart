import 'dart:convert';
import 'dart:io';

import 'package:aae/providers/login_state.dart';
import 'package:aae/utils/server_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_timetable/weekly_timetable.dart';
import 'package:http/http.dart' as http;

List hours = [];

class TutorHoursScreen extends StatefulWidget {
  const TutorHoursScreen({Key key}) : super(key: key);

  @override
  _TutorHoursScreenState createState() => _TutorHoursScreenState();
}

class _TutorHoursScreenState extends State<TutorHoursScreen> {
  @override
  void initState() {
    super.initState();
    fetchHours(context);
  }

  Map<int, List<int>> initialSchedule;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi horario'),
      ),
      body: FutureBuilder(
          future: fetchHours(context),
          builder: (context, AsyncSnapshot<Map> ss) {
            if (ss.hasData) {
              if (ss.data.keys.contains("hours")) {
                initialSchedule = parseToTimeTable(ss.data["hours"]["hours"]);
              } else {
                initialSchedule = {
                  0: [],
                  1: [],
                  2: [],
                  3: [],
                  4: [],
                  5: [],
                };
              }
              return hoursTable(initialSchedule);
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
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FlatButton.icon(
        color: ThemeData().primaryColor,
        icon: Row(
          children: <Widget>[
            Icon(Icons.schedule),
            Icon(Icons.file_upload),
            Icon(Icons.cloud_upload),
          ],
        ),
        label: Text(
          'Actualizar horarios',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onPressed: () {
          updateHours(context);
        },
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: ThemeData().primaryColorDark)),
      ),
    );
  }
}

Future<Map<String, dynamic>> fetchHours(BuildContext context) async {
  final session = Provider.of<LoginState>(context, listen: false);
  var response = await http.get(ServerInfo.host + '/api/aae/tutors/hours',
      headers: {HttpHeaders.authorizationHeader: session.token});
  var jsonResponse;
  if (response.statusCode == 200) {
    jsonResponse = jsonDecode(response.body);
    print('response: ${response.body}');
    Map<String, dynamic> aux = jsonResponse["data"];
    // print((aux.keys.contains("hours")));
    return jsonResponse["data"];
  } else {
    print(response.body);
  }
  // setState(() {});
  return null;
}

updateHours(BuildContext context) async {
  final session = Provider.of<LoginState>(context, listen: false);
  // print(jsonEncode(hours));
  var response = await http.put(ServerInfo.host + '/api/aae/tutors/hours',
      headers: {
        HttpHeaders.authorizationHeader: session.token,
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: jsonEncode({"hours": jsonEncode({"hours":hours})}));
  if (response.statusCode == 200) {
    // jsonResponse = jsonDecode(response.body);
    print('statusCode 200: ${response.body}');
    // return null;
  } else {
    print(response.body);
  }
  // setState(() {});
  return null;
}

hoursTable(Map<int, List<int>> initialSchedule) {
  return Container(
    height: 482, //header + num cells*cell's height
    color: Colors.blueGrey,
    child: Padding(
      padding: EdgeInsets.only(bottom: 0),
      child: WeeklyTimeTable(
        initialSchedule: initialSchedule,
        //  cellColor: Color.fromRGBO(0, 184, 255, 1.0),
        cellSelectedColor: Color.fromRGBO(189, 0, 255, 0.3),
        boarderColor: Color.fromRGBO(0, 30, 255, 1.0),
        locale: 'es',
        onValueChanged: (Map<int, List<int>> selected) {
          // // print(selected);
          hours = [];
          for (int i = 0; i < selected.length; i++) {
            for (int j = 0; j < selected[i].length; j++) {
              hours.add({
                "day": i + 2,
                "hour": WeeklyTimes.times["es"][selected[i][j]]
              });
            }
          }
          print(hours);
          // print(jsonEncode({"hours": hours}));
        },
      ),
    ),
  );
}

Map<int, List<int>> parseToTimeTable(List hours) {
  List<int> mon = [];
  List<int> tue = [];
  List<int> wed = [];
  List<int> thu = [];
  List<int> fri = [];
  List<int> sat = [];

  hours.forEach((item) {
    switch (item["day"]) {
      case 2:
        mon.add(WeeklyTimes.times['es'].indexOf(item["hour"]));
        break;
      case 3:
        tue.add(WeeklyTimes.times['es'].indexOf(item["hour"]));
        break;
      case 4:
        wed.add(WeeklyTimes.times['es'].indexOf(item["hour"]));
        break;
      case 5:
        tue.add(WeeklyTimes.times['es'].indexOf(item["hour"]));
        break;
      case 6:
        fri.add(WeeklyTimes.times['es'].indexOf(item["hour"]));
        break;
      default:
        sat.add(WeeklyTimes.times['es'].indexOf(item["hour"]));
    }
  });
  Map<int, List<int>> result = {
    0: mon,
    1: tue,
    2: wed,
    3: thu,
    4: fri,
    5: sat,
  };
  return result;
}
