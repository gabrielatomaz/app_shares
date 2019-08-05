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
