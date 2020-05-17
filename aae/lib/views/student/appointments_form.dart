import 'package:aae/models/dates.dart';
import 'package:aae/models/subject.dart';
import 'package:aae/models/user.dart';
import 'package:aae/providers/server_requests.dart';
import 'package:aae/utils/drawer.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import "package:collection/collection.dart";

class AppointmentForm extends StatefulWidget {
  AppointmentForm({Key key}) : super(key: key);

  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  bool isFlash = true;
  bool isElementary = true;
  List<String> options = ['Clase Única', 'Clase con Seguimiento (4 clases)'];
  var _levels;
  List<String> levels = [];
  List<String> subjectNames = [];
  List<String> subjectIds = [];
  Map<String, dynamic> sList = {};

  String _level;
  int _appointmentType = 0;
  int _subject;
  DateTime _dateTime = DateTime.now();

  bool _search = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar nueva Clase'),
      ),
      drawer: myDrawer(context),
      body: _buildAppointmentForm(),
    );
  }

  Widget _buildAppointmentForm() {
    return FutureBuilder(
      future: Requests.getAvailableSubjects(context),
      builder: (context, AsyncSnapshot<SubjectsList> ss) {
        // print(ss.connectionState);

        if (ss.hasData) {
          // print(ss.data.subjects);
          var _levels = groupBy(ss.data.subjects, (obj) => obj.level);
          // print(_levels);
          List<String> aux = [];
          _levels.entries.forEach((element) => aux.add(element.key));
          levels = aux;
          // _levels[levels[0]]
          //     .forEach((element) => subjectNames.add(element.name));
          // _levels[levels[0]]
          //     .forEach((element) => subjectIds.add(element.id.toString()));
          for (var item in levels) {
            List<String> _names = [];
            List<String> _ids = [];
            _levels[item].forEach((e) {
              _names.add(e.name);
              _ids.add(e.id.toString());
            });
            sList.addAll({
              item: {'names': _names, 'ids': _ids}
            });
          }
          print(sList);

          // if (levels[0]=='básica') {
          //   isElementary=true;
          // } else {
          //   isElementary=false;
          // }

          return Column(
            children: <Widget>[
              _appointmentForm(),
              SizedBox(
                height: 16,
              ),
              (!_search) ? Container() : displayTutorList(),
            ],
          );
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
      },
    );
  }

  Expanded displayTutorList() {
    return Expanded(
      child: FutureBuilder(
          future: Requests.getTutorList(context, _appointmentType, _subject,
              DateFormat('yyyy-MM-dd').format(_dateTime)),
          builder: (context, AsyncSnapshot<Map> snapshot) {
            if (snapshot.hasData) {
              List<Tutor> tutors = snapshot.data['tutors'];
              List<Date> dates = snapshot.data['dates'];
              print(snapshot.data);
              if (_appointmentType == 0) {
                return ListView.builder(
                    itemCount: dates.length,
                    itemBuilder: (context, index) {
                      Tutor tutor = tutors
                          .firstWhere((e) => e.id == dates[index].tutorId);
                      return Card(
                        elevation: 10,
                        borderOnForeground: true,
                        shadowColor: Colors.blueGrey[300],
                        child: ListTile(
                          // leading: CircleAvatar(child: Icon(FontAwesomeIcons.bookOpen)),
                          title: Text(
                              dates[index].dbDate + ' ' + dates[index].hour),
                          subtitle: Text(tutor.name),
                        ),
                      );
                    });
              } else {
                return ListView.builder(
                    itemCount: tutors.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 10,
                        borderOnForeground: true,
                        shadowColor: Colors.blueAccent,
                        child: ListTile(
                          leading: CircleAvatar(
                              foregroundColor: Colors.orangeAccent,
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                FontAwesomeIcons.userCircle,
                                size: 36,
                              )),
                          title: Text(tutors[index].name),
                          subtitle: Text(tutors[index].studyIn),
                          trailing: Wrap(
                            children: <Widget>[
                              IconButton(
                                  tooltip: 'ver horas disponibles',
                                  icon: Icon(FontAwesomeIcons.chevronRight),
                                  onPressed: null),
                            ],
                          ),
                        ),
                      );
                    });
              }
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
    );
  }

  _appointmentForm() {
    return CardSettings(
      shrinkWrap: true,
      showMaterialonIOS: true,
      children: [
        CardSettingsListPicker(
          label: 'Tu nivel',
          options: levels,
          initialValue: levels[0],
          onChanged: (value) {
            _level = value;
            print(_level);
            value == 'básica' ? isElementary = true : isElementary = false;
            setState(() {
              subjectNames.clear();
              subjectIds.clear();
              _levels[_level]
                  .forEach((element) => subjectNames.add(element.name));
              print(subjectNames);
              _levels[_level]
                  .forEach((element) => subjectIds.add(element.id.toString()));
              // print(subjectIds);
            });
            print(subjectNames);
          },
          requiredIndicator: Text(
            ' *',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        // CardSettingsListPicker(
        //   visible: isElementary,
        //   label: 'Materia',
        //   options: subjectNames,
        //   autovalidate: true,
        //   values: subjectIds,
        //   validator: (value) {
        //     if (value == null || value.isEmpty) {
        //       return "por favor selecciona una materia";
        //     }
        //     return null;
        //   },
        //   onChanged: (value) {
        //     print(subjectNames);
        //     print(subjectIds);
        //     // print(value);
        //     _subject = int.parse(value);
        //   },
        //   requiredIndicator: Text(
        //     ' *',
        //     style: TextStyle(color: Colors.redAccent),
        //   ),
        // ),
        CardSettingsListPicker(
          // visible: !isElementary,
          label: 'Materia',
          options:
              isElementary ? sList['básica']['names'] : sList['media']['names'],
          autovalidate: true,
          values: isElementary ? sList['básica']['ids'] : sList['media']['ids'],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "por favor selecciona una materia";
            }
            return null;
          },
          onChanged: (value) {
            print(value);
            _subject = int.parse(value);
          },
          requiredIndicator: Text(
            ' *',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        CardSettingsListPicker(
          label: 'Tipo de Clase',
          autovalidate: true,
          onSaved: (value) {
            _appointmentType = int.parse(value);
          },
          options: options,
          values: ['0', '1'],
          initialValue: '0',
          onChanged: (value) {
            print(value);
            if (value == '1') {
              isFlash = false;
            } else {
              isFlash = true;
            }
            _appointmentType = int.parse(value);
            setState(() {});
          },
          contentAlign: TextAlign.left,
          requiredIndicator: Text(
            ' *',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        CardSettingsDatePicker(
          label: 'Fecha',
          // justDate: true,
          requiredIndicator: Text(
            ' *',
            style: TextStyle(color: Colors.redAccent),
          ),
          initialValue: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 45)),
          onChanged: (value) {
            setState(() {
              _dateTime = value;
            });
          },
        ),
        CardSettingsButton(
          // visible: isFlash,
          bottomSpacing: 4,
          label: 'BUSCAR',
          textColor: Colors.white,
          backgroundColor: Colors.lightBlue[700],
          onPressed: () {
            print('app:$_appointmentType\nsubject: $_subject \n');
            print(DateFormat('yyyy-MM-dd').format(_dateTime));
            _search = true;
            setState(() {});
          },
        ),
      ],
    );
  }
}
