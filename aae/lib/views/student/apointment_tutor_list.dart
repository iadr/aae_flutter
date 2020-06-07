import 'package:aae/models/dates.dart';
// import 'package:aae/models/user.dart';
import 'package:aae/providers/server_requests.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import "package:collection/collection.dart";
import 'package:intl/intl.dart';

final Map<DateTime, List> _holidays = {
  // DateTime(2020, 1, 1): ['Año Nuevo'],
  // DateTime(2020, 5, 1): ['Día del trabajador'],
  // DateTime(2020, 5, 21): ['Combate Naval de Iquique'],
  // DateTime(2020, 9, 18): ['Primera Junta de Gobierno'],
  // DateTime(2020, 9, 19): ['Glorias Militares'],
  // DateTime(2020, 12, 25): ['Navidad'],
};

class AppointmentTutorHoursScreen extends StatefulWidget {
  final List<Date> dates;
  final int tutorId;
  final int subjectId;
  AppointmentTutorHoursScreen(
      {Key key,
      @required this.dates,
      @required this.tutorId,
      @required this.subjectId})
      : super(key: key);

  @override
  _AppointmentTutorHoursScreenState createState() =>
      _AppointmentTutorHoursScreenState();
}

class _AppointmentTutorHoursScreenState
    extends State<AppointmentTutorHoursScreen> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  final Set<Date> _saved = Set<Date>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    // widget.dates.map((e) => null)
    var newMap = groupBy(widget.dates, (obj) => DateTime.parse(obj.dbDate));
    // print(newMap);
    _events = newMap;
    print(_events);

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  Widget loadingView() => Center(
        child: SimpleDialog(backgroundColor: Colors.black54, children: <Widget>[
          CircularProgressIndicator(
            backgroundColor: Colors.deepOrange[700],
          ),
          SizedBox(
            height: 8,
          ),
          Text('Cargando')
        ]),
      );

  // View to empty data message
  Widget responseView(String msg) => Center(
        child: Text(
          msg,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      );

  @override
  Widget build(BuildContext context) {
    _tutorHours() {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          StreamBuilder<Object>(
              stream: null,
              builder: (context, snapshot) {
                return _buildTableCalendarWithBuilders();
              }),
          // const SizedBox(height: 8.0),
          // _buildButtons(),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ],
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(' ${_saved.length} clases seleccionadas'),
        actions: <Widget>[
          (_saved.length == 4)
              ? IconButton(
                  icon: Icon(
                    FontAwesomeIcons.solidSave,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    List _appointmentDates = [];
                    _saved.forEach((element) {
                      // print(element.dbDate + ' ' + element.hour);
                      _appointmentDates
                          .add({'date': element.dbDate, 'hour': element.hour});
                    });
                    // print(_appointmentDates);
                    // print('tutor: ${widget.tutorId}\nsubject: ${widget.subjectId}');

                    Requests.newAppointment(context, _appointmentDates,
                            widget.tutorId, widget.subjectId)
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
                  })
              : IconButton(
                  icon: Icon(
                    FontAwesomeIcons.save,
                    color: Colors.white10,
                  ),
                  onPressed: null),
        ],
      ),
      body: _tutorHours(),
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'es_ES',
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.twoWeeks: '',
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        weekdayStyle: TextStyle()
            .copyWith(color: Colors.black54, fontWeight: FontWeight.bold),
        weekendStyle: TextStyle()
            .copyWith(color: Colors.blue[800], fontWeight: FontWeight.bold),
        holidayStyle: TextStyle().copyWith(
            color: Colors.deepOrange[800], fontWeight: FontWeight.bold),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle()
            .copyWith(color: Colors.blue[600], fontWeight: FontWeight.bold),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents.map((event) {
        final bool alreadySaved = _saved.contains(event);
        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.8),
            borderRadius: BorderRadius.circular(12.0),
            color: alreadySaved ? Colors.grey[300] : Colors.white,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.orange[700],
              child: Icon(FontAwesomeIcons.clock),
            ),
            // selected: isSelected,
            title: Text(
              event.hour.substring(0, 5) + ' hrs.',
              style: TextStyle(
                  fontWeight:
                      alreadySaved ? FontWeight.bold : FontWeight.normal),
            ),
            subtitle: Text(
              DateFormat("dd 'de' MMMM", 'es')
                  .format(DateTime.parse(event.dbDate)),
              style: TextStyle(
                  fontWeight:
                      alreadySaved ? FontWeight.bold : FontWeight.normal),
            ),
            // trailing: Text(event["hour"].toString().substring(0, 5)),
            // selected: alreadySaved,
            onTap: () {
              print('${event.dbDate} ${event.hour} tapped!\n');
              setState(() {
                if (alreadySaved) {
                  _saved.remove(event);
                } else {
                  if (_saved.length < 4) {
                    _saved.add(event);
                    if (_saved.length == 4) _showDialog();
                  } else {
                    print('ya has seleccionado tus 4 clases');
                    _scaffoldKey.currentState.removeCurrentSnackBar();
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                        'YA HAS SELECCIONADO TUS 4 CLASES',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.deepOrangeAccent[700],
                    ));
                  }
                }
              });
              // loadJson();
              // groupData();
            },
          ),
        );
      }).toList(),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          List _appointmentDates = [];

          return AlertDialog(
            elevation: 25,
            title: Text('Clases seleccionadas'),
            content: Text(
                'Has escogido tus 4 clases, ¿deseas completar el registro?'),
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
                  _saved.forEach((e) {
                    _appointmentDates.add({"date": e.dbDate, "hour": e.hour});
                  });
                  print(_appointmentDates);
                  Requests.newAppointment(context, _appointmentDates,
                            widget.tutorId, widget.subjectId)
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
                      Navigator.pop(context); // TODO: revisar y hacer el pop hacia la screen anterior
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
