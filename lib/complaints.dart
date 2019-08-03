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

  Future<String> makeRequestComplains() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    var extractdata = json.decode(response.body);
    var list = extractdata as List;
    data = list.map((i) => ComplainUser.fromJson(i)).toList();
  }

  @override
  initState() {
    this.makeRequestComplains();
    super.initState();
  }

 Widget getComplain(ComplainUser user) {
    return
      new Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('${user.user}'),
              subtitle: Text('${user.reason}'),
              leading: CircleAvatar(
                      backgroundImage: MemoryImage(base64Decode(user.photo)))
            ),
            new ButtonTheme.bar( // make buttons use the appropriate styles for cards
              child: new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: const Text('Thumb up'),
                    onPressed: () { /* ... */ },
                  ),
                  new FlatButton(
                    child: const Text('Thumb down'),
                    onPressed: () { /* ... */ },
                  )]))]));
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
