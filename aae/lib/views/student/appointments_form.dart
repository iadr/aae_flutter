import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';

class AppointmentForm extends StatefulWidget {
  AppointmentForm({Key key}) : super(key: key);

  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  bool isFlash = false;
  bool isElementary = true;
  List<String> options = ['Clase Única', 'Clase con Seguimiento (4 clases)'];
  List<String> level = ['básica', 'media'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar nueva Clase'),
      ),
      body: _buildAppointmentForm(),
    );
  }

  Widget _buildAppointmentForm() {
    return CardSettings(
      children: [
        CardSettingsListPicker(
          label: 'Tu nivel',
          options: level,
          initialValue: level[0],
          onChanged: (value) {
            if (value == level[1]) {
              isElementary = false;
            } else {
              isElementary = true;
            }
            // print(isElementary);
            setState(() {});
          },
          requiredIndicator: Text(
            ' *',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        CardSettingsListPicker(
          visible: isElementary,
          label: 'Materia',
          options: [
            'comprensión del medio',
            'lenguaje',
            'matemáticas',
            'inglés',
          ],
          requiredIndicator: Text(
            ' *',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        CardSettingsListPicker(
          visible: !isElementary,
          label: 'Materia',
          options: [
            'Física',
            'Química',
            'Historia, Geografía y Ciencias Sociales',
            'Biología',
            'Inglés',
            'Lenguaje y Comunicación',
            'Matemáticas'
          ],
          requiredIndicator: Text(
            ' *',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        CardSettingsListPicker(
          label: 'Tipo de Clase',

          // autovalidate: true,
          options: options,
          initialValue: options[0],
          onChanged: (value) {
            print(value);
            if (value == options[1]) {
              isFlash = false;
            } else {
              isFlash = true;
            }
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
        ),
        CardSettingsButton(
          label: 'BUSCAR',
          textColor: Colors.white,
          backgroundColor: Colors.lightBlue[700],
          onPressed: () {},
        )
      ],
    );
  }
}
