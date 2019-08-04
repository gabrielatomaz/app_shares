import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:app_shares/fancy_fab.dart';
import 'package:flutter/material.dart';
import 'fancy_fab.dart';
import 'complain_user.dart';
import 'package:http/http.dart' as http;

class Complaiments extends StatefulWidget {
  @override
  _Complaiments createState() => _Complaiments();
}

class _Complaiments extends State<Complaiments> {
  String url = 'http://187.84.232.19:5000/api/denuncia';
  List<ComplainUser> data;

  Future _makeRequestComplains() async{
    return await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
  }

  Future<bool> _complainResult(
      bool banir, int idUsuario, int idDenuncia) async {
    var response = await http.get(
        Uri.encodeFull("${url}/banir/${banir}/${idUsuario}/${idDenuncia}"),
        headers: {"Accept": "application/json"});

    return response.statusCode == 200;
  }

  @override
  initState() {
    _makeRequestComplains().then((resp) {
      setState(() {
        var extractdata = json.decode(resp.body);
        var list = extractdata as List;
        data = list.map((i) => ComplainUser.fromJson(i)).toList();
      });
    });

    super.initState();
  }

  Widget getComplain(ComplainUser user) {
    return new Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
          title: Text('${user.user}', style: TextStyle(fontSize: 27)),
          subtitle: Text('${user.reason}', style: TextStyle(fontSize: 18)),
          leading: CircleAvatar(
              radius: 30,
              backgroundImage: MemoryImage(base64Decode(user.photo)))),
      new ButtonTheme.bar(
          // make buttons use the appropriate styles for cards
          child: new ButtonBar(children: <Widget>[
        IconButton(
            icon: Icon(Icons.check_circle, size: 34.0),
            onPressed: () {
              _complainResult(true, user.idUsuer, user.idComplaiment);
              Navigator.of(context).push(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                return Complaiments();
              }));
            },
            color: Color.fromRGBO(49, 107, 90, 1.0)),
        IconButton(
            icon: Icon(Icons.delete, size: 35.0),
            onPressed: () {
              _complainResult(false, user.idUsuer, user.idComplaiment);
              Navigator.of(context).push(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                return Complaiments();
              }));
            },
            color: Color.fromRGBO(49, 107, 90, 1.0))
      ]))
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FancyFab(),
        backgroundColor: Color.fromRGBO(233, 233, 233, 1.0),
        body: ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, i) {
              return getComplain(data[i]);
            }));
  }
}
