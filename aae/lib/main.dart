// import 'package:aae/views/flutter_lo gin.dart';
import 'package:aae/models/user.dart';
import 'package:aae/providers/login_state.dart';
import 'package:aae/views/dashboard.dart';
import 'package:aae/views/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginState()),
        ChangeNotifierProvider(create: (context) => User())
      ],
      child: MaterialApp(
        title: 'aae',
        // theme: ThemeData.dark(),
        // home: LoginPage(),
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) {
            var state = Provider.of<LoginState>(context);
            if (state.isLoggedIn()) {
              return DashboardScreen();
            } else {
              return LoginPage();
              // return LoginScreen();
            }
          },
        },
      ),
    );
  }
}
