import 'package:app_shares/json_user.dart';
import 'package:flutter/material.dart';
import 'json_restful_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

Future<Widget> _navigateAndDisplaySelection() async {
  var prefs = await SharedPreferences.getInstance();
  var user = prefs.getStringList('user');

  var jsonUser =
      user == null ? null : new JsonUser(user: user[0], photo: user[1]);

  return user == null ? LoginWithRestfulApi() : LoginScreen(user: jsonUser);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Google SignIn',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: new FutureBuilder<Widget>(
            future: _navigateAndDisplaySelection(), // a Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return snapshot.data;
                }
              } else {
                return LoginWithRestfulApi();
              }
            }));
  }
}
