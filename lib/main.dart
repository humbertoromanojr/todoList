import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _todoController = TextEditingController();

  List _todoList = [];

  @override
  void initState() {
    super.initState();

    _readData().then((data) => {
      setState(() {
        _todoList = json.decode(data);
      })
    });
  }

  void _addTodo() {
    setState(() {
      Map<String, dynamic> newTodo = Map();
      newTodo["title"] = _todoController.text;
      _todoController.text = ""; //clean textField
      newTodo["ok"] = false;
      _todoList.add(newTodo); // add newTodo
      _saveData(); // save todoList
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Todo List"),
          backgroundColor: Colors.indigo,
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(17.0, 5.0, 7.0, 5.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: _todoController,
                      decoration: InputDecoration(
                          labelText: "New Task",
                          labelStyle: TextStyle(color: Colors.indigo)),
                    )),
                    RaisedButton(
                      color: Colors.indigo,
                      child: Text("ADD"),
                      textColor: Colors.white,
                      onPressed: _addTodo,
                    )
                  ],
                )),
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  itemCount: _todoList.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(_todoList[index]["title"]),
                      value: _todoList[index]["ok"],
                      secondary: CircleAvatar(
                          child: Icon(_todoList[index]["ok"]
                              ? Icons.check
                              : Icons.error),),
                      onChanged: (c){
                        setState(() {
                          _todoList[index]["ok"] = c;
                          _saveData();
                        });
                      },
                    );
                  }),
            )
          ],
        ));
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    //convert in JSON
    String data = json.encode(_todoList);

    //get file JSON
    final file = await _getFile();

    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
