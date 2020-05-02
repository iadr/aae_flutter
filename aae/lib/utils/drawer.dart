import 'package:aae/models/user.dart';
import 'package:aae/views/dashboard.dart';
import 'package:aae/views/tutor/subjects_screen.dart';
import 'package:aae/views/tutor/workable_hours.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

myDrawer(BuildContext context) {
  final user = Provider.of<User>(context);
  final String _photo = "https://randomuser.me/api/portraits/women/12.jpg";
  List<Widget> drawerTiles() {
    List<Widget> children = [
      DrawerHeader(
        child: Container(
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.network(_photo, fit: BoxFit.cover),
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
            title: Text('Agendar Tutoría'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.bookReader),
            title: Text('Mis Tutorías'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          )
        ]);
    } else if (user.isTutor()) {
      children
        ..addAll([
          ListTile(
            leading: Icon(FontAwesomeIcons.bookReader),
            title: Text('Mis Tutorías'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.calendarAlt),
            title: Text('Mi Horario'),
            onTap: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => TutorHoursScreen()));
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.book),
            title: Text('Mis Asignaturas'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SubjectsScreen()));
            },
          )
        ]);
    }
    return children;
  }

  return Drawer(
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: drawerTiles(),
    ),
  );
}
