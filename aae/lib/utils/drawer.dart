import 'package:aae/models/user.dart';
import 'package:aae/views/dashboard.dart';
import 'package:aae/views/profile_screen.dart';
import 'package:aae/views/student/appointments_form.dart';
import 'package:aae/views/appointments_screen.dart';
import 'package:aae/views/tutor/subjects_screen.dart';
import 'package:aae/views/tutor/workable_hours.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

myDrawer(BuildContext context) {
  final user = Provider.of<User>(context);
  final String _photo = "https://randomuser.me/api/portraits/women/12.jpg";
  List<Widget> drawerTiles() {
    List<Widget> children = [
      DrawerHeader(
        child: FractionallySizedBox(
          heightFactor: 1,
          widthFactor: 1,
          child: Container(
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.network(_photo, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      ),
      ListTile(
        leading: Icon(FontAwesomeIcons.home),
        title: Text('Inicio'),
        onTap: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DashboardScreen()));
        },
      ),
    ];

    if (user.isStudent()) {
      children
        ..addAll([
          ListTile(
            leading: Icon(FontAwesomeIcons.calendarPlus),
            title: Text('Agendar Clase'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AppointmentForm()));
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.bookReader),
            title: Text('Mis Próximas clases'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AppointmentsScreen()));
            },
          )
        ]);
    } else if (user.isTutor()) {
      children
        ..addAll([
          ListTile(
            leading: Icon(FontAwesomeIcons.bookReader),
            title: Text('Mis Próximas Clases'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AppointmentsScreen()));
            },
          ),
          Divider(
          color: Colors.blueAccent[100],
          thickness: 1.5,
        ),
          ListTile(
            leading: Icon(FontAwesomeIcons.calendarAlt),
            title: Text('Configurar Mi Horario'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TutorHoursScreen()));
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.book),
            title: Text('Configurar Mis Asignaturas'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SubjectsScreen()));
            },
          )
        ]);
    }
    children
      ..addAll([
        Divider(
          color: Colors.blueAccent[100],
          thickness: 1.5,
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.cog),
          title: Text('Configurar Perfil'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileScreen()));
          },
        ),
      ]);
    return children;
  }

  return Drawer(
    child: Column(
      // Important: Remove any padding from the ListView.
      // padding: EdgeInsets.zero,
      mainAxisSize: MainAxisSize.max,
      children: drawerTiles(),
    ),
  );
}
