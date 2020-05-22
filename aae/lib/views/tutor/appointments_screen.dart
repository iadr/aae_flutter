import 'package:aae/models/appointment.dart';
import 'package:aae/models/user.dart';
import 'package:aae/providers/server_requests.dart';
import 'package:aae/utils/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key key}) : super(key: key);

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Próximas clases'),
      ),
      drawer: myDrawer(context),
      body: _appointmentList(),
    );
  }

  _appointmentList() {
    final userData = Provider.of<User>(context);
    return FutureBuilder(
        future: (userData.isTutor())
            ? Requests.getTutorAppointments(context)
            : Requests.getStudentAppointments(context),
        builder: (context, AsyncSnapshot<AppointmentsList> ss) {
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
                itemCount: ss.data.appointment.length,
                itemBuilder: (context, index) {
                  Appointment appointment = ss.data.appointment[index];
                  final DateTime date =
                      DateTime.parse(appointment.date + " " + appointment.hour);
                  // DateTime.now().subtract(Duration(minutes: 15));
                  // DateTime.parse("2020-05-08 18:00:00");
                  // print(Jiffy("2020-05-07 17:00","yyyy-MM-dd hh:mm").fromNow());
                  Jiffy.locale('es');

                  return Card(
                    child: ListTile(
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
                          onPressed: () {}),
                      // title: Text(appointment.date +" "+appointment.hour.substring(0,5)),
                      subtitle: Text(date.toString()),
                      title: Text(
                          Jiffy(date.toString(), "yyyy-MM-dd hh:mm").fromNow()),
                      // subtitle: Text(appointment.name),
                    ),
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
