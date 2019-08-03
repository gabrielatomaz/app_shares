import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:app_shares/fancy_fab.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'json_user.dart';
import 'fancy_fab.dart';

class LoginWithRestfulApi extends StatefulWidget {
  @override
  _LoginWithRestfulApiState createState() => _LoginWithRestfulApiState();
}

class _LoginWithRestfulApiState extends State<LoginWithRestfulApi> {
  static var uri =
      "http://187.84.232.19:5000/api/usuario/retornarusuarioautenticado/";

  static BaseOptions options = BaseOptions(
      baseUrl: uri,
      responseType: ResponseType.plain,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      validateStatus: (code) {
        if (code >= 200) {
          return true;
        }
        return false;
      });
  static Dio dio = Dio(options);

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<dynamic> _loginUser(String email, String password) async {
    try {
      Options options = Options(
        contentType: ContentType.parse('application/json'),
      );

      var response = await dio.get(email + '/' + password, options: options);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.data);
        return responseJson;
      } else if (response.statusCode == 404) {
        return null;
      } else
        throw Exception('Authentication Error');
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        return null;
      }
    }
  }

  String validatePassword(String value) {
    if (!(value.length < 5) && !value.isNotEmpty) {
      return "A senha deve conter no mínimo 5 caracteres.";
    }
    return null;
  }

  String validateUser(String value) {
    if (!(value.length < 5) && !value.isNotEmpty) {
      return "O usuário deve conter no mínimo 5 caracteres.";
    }
    return null;
  }

  TextStyle style = TextStyle(fontFamily: 'Tahoma', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      height: 155.0,
                      child: Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.contain,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      obscureText: false,
                      style: style,
                      controller: _emailController,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          errorText: validateUser(_emailController.text),
                          hintText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      obscureText: true,
                      style: style,
                      controller: _passwordController,
                      decoration: InputDecoration(
                          hintText: 'Senha',
                          errorText: validatePassword(_passwordController.text),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ),
                  SizedBox(
                    width: 390,
                    height: 48,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      child: Text("Entrar",
                          textAlign: TextAlign.center,
                          style: style.copyWith(color: Colors.white)),
                      elevation: 5.0,
                      color: Color.fromRGBO(49, 107, 90, 1.0),
                      onPressed: () async {
                        setState(() => _isLoading = true);
                        var res = await _loginUser(
                            _emailController.text, _passwordController.text);
                        setState(() => _isLoading = false);

                        JsonUser user = JsonUser.fromJson(res);
                        if (user != null) {
                          Navigator.of(context).push(MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                            return new LoginScreen(
                              user: user,
                            );
                          }));
                        } else {
                          return showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Fechar'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                                title: Text('Ops!'),
                                content: const Text(
                                    'Usuário ou senha incorreto(s)!'),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  LoginScreen({@required this.user});

  final JsonUser user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FancyFab(),
        backgroundColor: Color.fromRGBO(233, 233, 233, 1.0),
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Container(
                  width: 145.0,
                  height: 145.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 4.0,
                      ),
                    ],
                    image: DecorationImage(
                        image: MemoryImage(base64Decode(user.photo)),
                        fit: BoxFit.fill),
                  )),
              Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Bem vindo(a), ${user.user}!",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ))
            ])));
  }
}
