import 'package:flutter/material.dart';
import "dart:async";
import "package:http/http.dart" as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        buttonColor: Colors.black
      ),
      home: MyHomePage(title: 'Bicheros App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String url = "http://172.20.10.3:8000/api/animals/";
  List data;

  @override
  void initState() {
    super.initState();
    getJsonData();
  }

  Future getJsonData() async {
    var response = await http.get(Uri.encodeFull(url));

    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      data = convertDataToJson;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bichero's App"),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Animales"),
            ),
            ListTile(
              title: Text("Veterinarias"),
            ),
            ListTile(
              title: Text("Saldo"),
            ),
            ListTile(
              title: Text("Adoptantes"),
            ),
            ListTile(
              title: Text("Donaciones"),
            ),
          ],
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: CircleAvatar(),
              title: Text(data[index]["id_animal"].toString()+" - "+ data[index]["name"]),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getJsonData,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),

      ),
    );
  }
}
