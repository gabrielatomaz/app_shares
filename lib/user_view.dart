import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:app_shares/fancy_fab.dart';
import 'package:flutter/material.dart';
import 'fancy_fab.dart';
import 'user.dart';
import 'package:http/http.dart' as http;

class UserView extends StatefulWidget {
  @override
  _UserView createState() => _UserView();
}

class _UserView extends State<UserView> {
  String url = 'http://187.84.232.19:5000/api/usuario';
  List<User> data;
  bool _isLoading = false;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentRole;

  Future _makeRequestUsers() async {
    return await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
  }

  @override
  initState() {
    _isLoading = true;
    _dropDownMenuItems = getDropDownMenuItems();
    _makeRequestUsers().then((resp) {
      setState(() {
        var extractdata = json.decode(resp.body);
        var list = extractdata as List;
        data = list.map((i) => User.fromJson(i)).toList();
        _isLoading = false;
      });
    });

    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    var roles = ["Administrador", "Moderador", "Usuario"];
    for (String role in roles) {
      items.add(new DropdownMenuItem(value: role, child: new Text(role)));
    }

    return items;
  }

  Widget getUser(User user) {
    return Container(
        child: Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
          title: Text('${user.name} (${user.user})',
              style: TextStyle(fontSize: 23)),
              leading: CircleAvatar(
              radius: 30,
              backgroundImage: MemoryImage(base64Decode(user.photo)))),
          ButtonTheme.bar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
          child: new DropdownButton(
            value: user.role,
            items: _dropDownMenuItems,
            onChanged: changedDropDownItem,
            style: Theme.of(context).textTheme.title,
          )
      ),
        IconButton(
            icon: Icon(Icons.delete, size: 29.0),
            onPressed: () {},
            color: Color.fromRGBO(49, 107, 90, 1.0)),
        ]))
    ])));
  }

  void changedDropDownItem(String selectedRole) {
    setState(() {
      _currentRole = selectedRole;
    });
  }

  Widget doesntHaveComplain() {
    return Padding(
        padding: EdgeInsets.all(18.0),
        child: Center(
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
                          child:Text("Lista de usuários", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))));

                      i -= 1;

                      return getUser(data[i]);
                    }));
  }
}
