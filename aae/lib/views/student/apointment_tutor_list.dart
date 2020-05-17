import 'package:aae/models/user.dart';
import 'package:aae/providers/server_requests.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppointmentTutorListScreen extends StatefulWidget {
  AppointmentTutorListScreen({Key key}) : super(key: key);

  @override
  _AppointmentTutorListScreenState createState() =>
      _AppointmentTutorListScreenState();
}

class _AppointmentTutorListScreenState
    extends State<AppointmentTutorListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _tutorList(),
    );
  }

  @override
  void initState() {
    super.initState();
    Requests.getTutorList(context,0,0,"qw"); // TODO: COOREGIR LLAMADA AL METODO
  }

  _tutorList() {
    return FutureBuilder(
        future: Requests.getTutorList(context,0,0,"wq"), //TODO: CORREGIR LLAMADA AL METODO
        builder: (context, ss) {
          if (ss.hasData) {
            return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                      height: 0,
                    ),
                itemCount: ss.data.tutors.length,
                itemBuilder: (context, index) {
                  Tutor tutor = ss.data.tutors[index];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.grey,
                      child: Icon(FontAwesomeIcons.book)),
                    title: Text(tutor.name),
                    subtitle: Text(tutor.studyIn),
                    trailing: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.plusCircle,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          // _addSubject(context, tutor.id);
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
}
