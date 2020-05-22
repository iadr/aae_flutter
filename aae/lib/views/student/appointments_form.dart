import 'package:aae/models/dates.dart';
import 'package:aae/models/subject.dart';
import 'package:aae/models/user.dart';
import 'package:aae/providers/server_requests.dart';
import 'package:aae/utils/drawer.dart';
import 'package:aae/views/student/apointment_tutor_list.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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

  List _date;
  int _tutorId;

  bool _search = false;
  int selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Agendar nueva Clase'),
        actions: <Widget>[
          (selected != null)
              ? IconButton(
                  icon: Icon(
                    FontAwesomeIcons.solidSave,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    selected = null;
                    print('$_date, $_tutorId, $_subject');
                    Requests.newAppointment(context, _date, _tutorId, _subject)
                        .then((value) {
                      if (value) {
                        _scaffoldKey.currentState.removeCurrentSnackBar();
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                            'ClASES REGISTRADAS CORRECTAMENTE',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.greenAccent[700],
                        ));
                      } else {
                        _scaffoldKey.currentState.removeCurrentSnackBar();
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                            'OCURRIÓ UN PROBLEMA ...',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.deepOrangeAccent[700],
                        ));
                      }
                    });
                    setState(() {});
                  })
              : IconButton(
                  icon: Icon(
                    FontAwesomeIcons.save,
                    color: Colors.white10,
                  ),
                  onPressed: null),
        ],
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
          // print(sList);

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
              // print(snapshot.data);
              if (_appointmentType == 0) {
                //FLASH
                print('dates.length: ${dates.length}');
                return ListView.builder(
                    itemCount: dates.length,
                    itemBuilder: (context, index) {
                      Tutor tutor = tutors
                          .firstWhere((e) => e.id == dates[index].tutorId);
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(
                            width: 1.8,
                            color: Colors.grey[400],
                          ),
                        ),
                        color: (index == selected)
                            ? Colors.grey[300]
                            : Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                              foregroundColor: Colors.blue,
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                FontAwesomeIcons.clock,
                                size: 36,
                              )),
                          title: Text(
                              dates[index].dbDate + ' ' + dates[index].hour),
                          subtitle: Text(tutor.name),
                          onTap: () {
                            selected = index;
                            _showDialog(dates[index]);
                            setState(() {});
                          },
                        ),
                      );
                    });
              } else {
                //SEGUIMIENTO
                return ListView.builder(
                    itemCount: tutors.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(
                            width: 1.8,
                            color: Colors.grey[400],
                          ),
                        ),
                        child: ListTile(
                          leading: IconButton(
                              color: Colors.orange[700],
                              padding: EdgeInsets.all(0),
                              // visualDensity: VisualDensity(horizontal: 0,vertical: 0),
                              icon: Icon(
                                FontAwesomeIcons.userCircle,
                                size: 36,
                              ),
                              onPressed: () {}),
                          title: Text(tutors[index].name),
                          subtitle: Text(tutors[index].studyIn),
                          trailing: IconButton(
                            onPressed: () {
                              List<Date> tutorDates = dates
                                  .where((element) =>
                                      element.tutorId == tutors[index].id)
                                  .toList();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AppointmentTutorHoursScreen(
                                    dates: tutorDates,
                                    tutorId: tutors[index].id,
                                    subjectId: _subject,
                                  ),
                                ),
                              );
                            },
                            color: Colors.orange[700],
                            icon: Icon(FontAwesomeIcons.chevronRight),
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
            // print(_level);
            value == 'básica' ? isElementary = true : isElementary = false;
            setState(() {
              if (_search) _search = false;
              // subjectNames.clear();
              // subjectIds.clear();
              // _levels[_level]
              //     .forEach((element) => subjectNames.add(element.name));
              // // print(subjectNames);
              // _levels[_level]
              //     .forEach((element) => subjectIds.add(element.id.toString()));
              // print(subjectIds);
            });
            // print(subjectNames);
          },
          requiredIndicator: Text(
            ' *',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
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
            if (_search) _search = false;

            _subject = int.parse(value);
            setState(() {});
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
            // print(value);
            if (value == '1') {
              isFlash = false;
            } else {
              isFlash = true;
            }
            _appointmentType = int.parse(value);
            if (_search) _search = false;

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
            if (_search) _search = false;
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
            // print('app:$_appointmentType\nsubject: $_subject \n');
            // print(DateFormat('yyyy-MM-dd').format(_dateTime));
            _search = true;
            selected=null;
            setState(() {});
          },
        ),
      ],
    );
  }

  void _showDialog(Date date) {
    _date = [
      {'date': date.dbDate, 'hour': date.hour}
    ];
    _tutorId = date.tutorId;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmar clase por favor'),
            content: Text('Estas seguro de que quieres esta clase?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'CERRAR',
                  style: TextStyle(
                    color: Colors.deepOrange[700],
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                  setState(() {});
                  Requests.newAppointment(context, _date, _tutorId, _subject)
                      .then((value) {
                    if (value) {
                      //true
                      _scaffoldKey.currentState.removeCurrentSnackBar();
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                          'ClASES REGISTRADAS CORRECTAMENTE',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.greenAccent[700],
                      ));
                    } else {
                      //false
                      _scaffoldKey.currentState.removeCurrentSnackBar();
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                          'OCURRIÓ UN PROBLEMA ...',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.deepOrangeAccent[700],
                      ));
                    }
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  'CONFIRMAR',
                  style: TextStyle(color: Colors.blue[700]),
                ),
              ),
            ],
          );
        });
  }
}
