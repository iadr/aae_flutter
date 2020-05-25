import 'package:aae/models/user.dart';
import 'package:aae/utils/drawer.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isStudent;
  String name;
  String address;
  String studyIn;
  String major;
  String email;
  String password;
  String description;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<User>(context);

    isStudent = userInfo.isStudent();
    name = userInfo.name;
    address = userInfo.address;
    studyIn = userInfo.studyIn;
    major = userInfo.major;
    description = userInfo.description;
    email = userInfo.email;
    password = userInfo.password;

    return Scaffold(
      appBar: AppBar(),
      drawer: myDrawer(context),
      body: profileForm(),
    );
  }

  Form profileForm() {
    return Form(
        key: _formKey,
        child: CardSettings(
          shrinkWrap: true,
          padding: 15.0,
          cardElevation: 50.0,
          children: [
            CardSettingsSection(
              children: <Widget>[
                CardSettingsHeader(
                  label: "Información Personal",
                ),
                CardSettingsText(
                  label: "Nombre",
                  initialValue: name,
                  keyboardType: TextInputType.text,
                  maxLength: 40,
                  autovalidate: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '¿Cuál es tu nombre?';
                    }
                    name = value;
                    return null;
                  },
                  requiredIndicator: Text(
                    ' *',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                CardSettingsText(
                  label: "Estudias en:",
                  maxLength: 40,
                  maxLengthEnforced: true,
                  initialValue: studyIn,
                  keyboardType: TextInputType.text,
                  autovalidate: true,
                  validator: (value) {
                    if (!isStudent && (value == null || value.isEmpty)) {
                      return '¿dónde estudias?';
                    }
                    studyIn = value;
                    return null;
                  },
                  requiredIndicator: (!isStudent)
                      ? Text(
                          ' *',
                          style: TextStyle(color: Colors.redAccent),
                        )
                      : Text(""),
                ),
                CardSettingsText(
                  visible: !isStudent,
                  label: 'Carrera',
                  maxLength: 60,
                  autovalidate: true,
                  initialValue: major,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '¿Cuál es tu carrera?';
                    }
                    major = value;
                    return null;
                  },
                  requiredIndicator: Text(
                    ' *',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                CardSettingsText(
                  label: "Dirección",
                  initialValue: address,
                  keyboardType: TextInputType.text,
                  autovalidate: true,
                  validator: (value) {
                    // if (value == null || value.isEmpty) {
                    //   return 'What\'s your name?';
                    // }
                    address = value;
                    return null;
                  },
                  // requiredIndicator: Text(
                  //   ' *',
                  //   style: TextStyle(color: Colors.redAccent),
                  // ),
                ),
                CardSettingsParagraph(
                  label: "Describete a ti mismo",
                  maxLength: 250,
                  maxLengthEnforced: true,
                  initialValue: description,
                  hintText:
                      "Una breve descripción para que los demás sepan un poco más de ti",
                  keyboardType: TextInputType.text,
                  autovalidate: true,
                  validator: (value) {
                    // if (value == null || value.isEmpty) {

                    //     return 'What\'s your name?';
                    //   }
                    description = value;
                    return null;
                  },
                ),
                CardSettingsHeader(
                  label: "Seguridad",
                ),
                CardSettingsEmail(
                  // icon: Icon(FontAwesomeIcons.envelope),
                  initialValue: email,
                  autovalidate: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'necesitamos que nos digas tu e-mail';
                    }
                    email = value;
                    return null;
                  },
                  requiredIndicator: Text(
                    ' *',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                CardSettingsPassword(
                  label: 'Contraseña',
                  // icon: Icon(FontAwesomeIcons.lock),
                  initialValue: password,
                  autovalidate: true,
                  validator: (value) {
                    if (value.isEmpty || value == null) {
                      return 'No puedes dejar la contraseña en blanco';
                    } else if (value.length < 6)
                      return 'La contraseña debe tener como mínimo 6 caracteres';
                    password = value;
                    return null;
                  },
                  requiredIndicator: Text(
                    ' *',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                CardSettingsHeader(
                    // label: "Actions",
                    ),
                CardSettingsButton(
                  onPressed: () {
                    print("save");
                    if (name != null &&
                        name.trim().isNotEmpty &&
                        email != null &&
                        email.trim().isNotEmpty &&
                        password != null &&
                        password.trim().isNotEmpty) {
                      if (!isStudent) {
                        if (studyIn != null &&
                            studyIn.trim().isNotEmpty &&
                            major != null &&
                            major.trim().isNotEmpty) {
                          print("you pass");
                        } else {
                          print('you lose, study or major isn\'t defined');
                        }
                      } else {
                        print('you pass');
                      }
                    } else {
                      print('you lose, name,email or password is empty');
                    }
                  },
                  label: "ACTUALIZAR PERFIL",
                  backgroundColor: Colors.lightBlue[700],
                  textColor: Colors.white,
                  bottomSpacing: 2,
                ),
                CardSettingsButton(
                  onPressed: () {
                    // print("now you should pop this screen");
                    Navigator.pop(context);
                  },
                  label: "CANCELAR",
                  backgroundColor: Colors.deepOrangeAccent[700],
                  textColor: Colors.white,
                  bottomSpacing: 3,
                ),
              ],
            )
          ],
        ));
  }
}
