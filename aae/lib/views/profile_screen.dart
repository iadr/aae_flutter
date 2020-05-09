import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isStudent = false;
  String name;
  String address;
  String studyIn;
  String major;
  String email;
  String password;
  String description = "http://www.codyleet.com/spheria";
  // String description;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
          key: _formKey,
          child: CardSettings(
            shrinkWrap: true,
            padding: 15.0,
            cardElevation: 50.0,
            children: [
              CardSettingsHeader(
                label: "My Profile",
              ),
              CardSettingsText(
                label: "Name",
                initialValue: "My Name",
                keyboardType: TextInputType.text,
                maxLength: 40,
                autovalidate: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'What\'s your name?';
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
                label: "Study In",
                maxLength: 40,
                maxLengthEnforced: true,
                // initialValue: "My Name",
                keyboardType: TextInputType.text,
                autovalidate: true,
                validator: (value) {
                  if (!isStudent && (value == null || value.isEmpty)) {
                    return 'What\'s your study house?';
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
                label: 'Major',
                maxLength: 60,
                autovalidate: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'What\'s your major?';
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
                label: "Address",
                initialValue: "My Address",
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
                label: "About Yourself",
                maxLength: 250,
                maxLengthEnforced: true,
                initialValue: (description == null || description.isEmpty)
                    ? ""
                    : description,
                hintText: "holas",
                keyboardType: TextInputType.text,
                autovalidate: true,
                validator: (value) {
                  // if (value == null || value.isEmpty) {

                  //     return 'What\'s your name?';
                  //   }
                  description = value;
                  return null;
                },
                // requiredIndicator: Text(
                //   ' *',
                //   style: TextStyle(color: Colors.redAccent),
                // ),
              ),
              CardSettingsHeader(
                label: "Security",
              ),
              CardSettingsEmail(
                icon: Icon(FontAwesomeIcons.envelope),
                initialValue: "My Email",
                autovalidate: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'What\'s your email?';
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
                icon: Icon(FontAwesomeIcons.lock),
                initialValue: "My Password",
                autovalidate: true,
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return 'What\'s your email?';
                  }
                  password = value;
                  return null;
                },
                requiredIndicator: Text(
                  ' *',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
              CardSettingsHeader(
                label: "Actions",
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
                label: "SAVE",
                backgroundColor: Colors.lightBlue[700],
                textColor: Colors.white,
                bottomSpacing: 2,
              ),
              CardSettingsButton(
                onPressed: () {
                  print("now you should pop this screen");
                },
                label: "CANCEL",
                backgroundColor: Colors.deepOrangeAccent[700],
                textColor: Colors.white,
              ),
            ],
          )),
    );
  }
}
