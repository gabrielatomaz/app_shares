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
  bool _isLoading = false;

  Future _makeRequestComplains() async {
    return await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
  }

  Future<bool> _complainResult(
      bool banir, int idUsuario, int idDenuncia) async {
    var response = await http.get(
        Uri.encodeFull("$url/banir/$banir/$idUsuario/$idDenuncia"),
        headers: {"Accept": "application/json"});

    return response.statusCode == 200;
  }

  @override
  initState() {
    _isLoading = true;
    _makeRequestComplains().then((resp) {
      setState(() {
        var extractdata = json.decode(resp.body);
        var list = extractdata as List;
        data = list.map((i) => ComplainUser.fromJson(i)).toList();
        _isLoading = false;
      });
    });

    super.initState();
  }

  Widget getComplain(ComplainUser user) {
    return Container(
      child: Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
          title: Text('${user.user}', style: TextStyle(fontSize: 24)),
          subtitle: Text('${user.reason}', style: TextStyle(fontSize: 18)),
          leading: CircleAvatar(
              radius: 30,
              backgroundImage: MemoryImage(base64Decode(user.photo)))),
      new ButtonTheme.bar(
          child: new ButtonBar(children: <Widget>[
        IconButton(
            icon: Icon(Icons.check_circle, size: 28.0),
            onPressed: () {
              _complainResult(true, user.idUsuer, user.idComplaiment);
              Navigator.of(context).push(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                return Complaiments();
              }));
            },
            color: Color.fromRGBO(49, 107, 90, 1.0)),
        IconButton(
            icon: Icon(Icons.delete, size: 29.0),
            onPressed: () {
              _complainResult(false, user.idUsuer, user.idComplaiment);
              Navigator.of(context).push(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                return Complaiments();
              }));
            },
            color: Color.fromRGBO(49, 107, 90, 1.0))
      ]))
    ])));
  }

  Widget doesntHaveComplain() {
    return Padding( padding: EdgeInsets.all(18.0),child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Container(
          child: Column(children: <Widget>[
        Icon(
          Icons.speaker_notes_off,
          color: Color.fromRGBO(49, 107, 90, 1.0),
          size: 50.0,
        ),
        Align(
            alignment: Alignment.center,
            child: Text(
              "Ooops! Parece que não há nenhuma denuncia no momento!",
              style: TextStyle(
                  fontSize: 23,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ))
      ]))
    ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FancyFab(),
        backgroundColor: Color.fromRGBO(233, 233, 233, 1.0),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : (data.length == 0)
                ? doesntHaveComplain()
                : ListView.builder(
                    itemCount: data == null ? 1 : data.length + 1,
                    itemBuilder: (BuildContext context, i) {
                      if(i == 0)
                        return Center(child:Padding(
                          padding: EdgeInsets.all(10.0),
                          child:Text("Lista de denuncias", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))));

                      i -= 1;

                      return getComplain(data[i]);
                    }));
  }
}
