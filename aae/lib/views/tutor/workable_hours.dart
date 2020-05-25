import 'dart:convert';
import 'dart:io';

import 'package:aae/providers/login_state.dart';
import 'package:aae/providers/server_requests.dart';
import 'package:aae/utils/server_info.dart';
import 'package:card_settings/card_settings.dart';
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
  Map<int, List<int>> initialSchedule;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Requests.fetchHours(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Mis horas trabajables'),
      ),
      body: Column(
        children: <Widget>[
          displayHours(context),
          CardSettings(
            cardElevation: 1,
            shrinkWrap: true,
            children: [
              CardSettingsSection(
                children: <Widget>[
                  CardSettingsButton(
                    onPressed: () {
                      Requests.updateWorkableHours(context, hours)
                          .then((value) {
                        String _result;
                        Color _color;
                        if (value) {
                          _result = 'HORAS ACTUALIZADAS CORREACTAMENTE';
                          _color = Colors.greenAccent[700];
                        } else {
                          _result =
                              'HUBO UN PROBLEMA, INTENTA OTRA VEZ POR FAVOR';
                          _color = Colors.deepOrangeAccent[700];
                        }
                        _scaffoldKey.currentState
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              backgroundColor: _color,
                              content: Text(
                                _result,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                      });
                    },
                    label: 'ACTUALIZAR HORAS',
                    bottomSpacing: 4,
                    backgroundColor: Colors.blueAccent[700],
                    textColor: Colors.white,
                  )
                ],
              )
            ],
          )
        ],
      ),
      // floatingActionButton: FlatButton.icon(
      //   color: ThemeData().primaryColor,
      //   icon: Row(
      //     children: <Widget>[
      //       Icon(Icons.schedule),
      //       Icon(Icons.file_upload),
      //       Icon(Icons.cloud_upload),
      //     ],
      //   ),
      //   label: Text(
      //     'Actualizar horarios',
      //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      //   ),
      //   onPressed: () {
      //     updateWorkableHours(context);
      //   },
      //   shape: RoundedRectangleBorder(
      //       borderRadius: new BorderRadius.circular(18.0),
      //       side: BorderSide(color: ThemeData().primaryColorDark)),
      // ),
    );
  }

  FutureBuilder<Map<String, dynamic>> displayHours(BuildContext context) {
    return FutureBuilder(
        future: Requests.fetchHours(context),
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
        });
  }
}

hoursTable(Map<int, List<int>> initialSchedule) {
  return Container(
    height: 482, //header + num cells*cell's height
    color: Colors.blueGrey,
    child: Padding(
      padding: EdgeInsets.only(bottom: 0),
      child: WeeklyTimeTable(
        initialSchedule: initialSchedule,
        cellColor: Colors.grey[100],
        cellSelectedColor: Color.fromRGBO(255, 137, 0, 0.8),
        boarderColor: Color.fromRGBO(0, 30, 255, 1.0),
        locale: 'es',
        onValueChanged: (Map<int, List<int>> selected) {
          // // print(selected);
          hours = [];
          for (int i = 0; i < selected.length; i++) {
            for (int j = 0; j < selected[i].length; j++) {
              hours.add({
                "day": (i + 2),
                "hour": WeeklyTimes.times["es"][selected[i][j]]
              });
            }
          }
          // print(hours);
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
