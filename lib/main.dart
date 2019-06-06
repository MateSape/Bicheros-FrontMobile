import 'package:flutter/material.dart';
import "dart:async";
import "package:http/http.dart" as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  final String url = "http://192.168.0.8:8000/api/animals/";
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
      body: RefreshIndicator(
        onRefresh: getJsonData,

        child: Container(
          child: ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage(data[index]["photo"]),),
                title: Text(data[index]["id_animal"].toString()+" - "+ data[index]["name"]),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(data[index]["id_animal"])));
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Add',
        child: Icon(Icons.add),

      ),
    );
  }
}


class DetailPage extends StatefulWidget {
  DetailPage(this.animal);
  final animal;
  @override
  DetailPageState createState() => new DetailPageState(this.animal);
}

class DetailPageState extends State<DetailPage> {
  DetailPageState(this.animal);
  final animal;
  var ica;


  @override
  void initState() {
    getJsonData();
    super.initState();
  }

  Future getJsonData() async {
    var response = await http.get(Uri.encodeFull("http://192.168.0.8:8000/api/animals/"+animal.toString()+"/"));

    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      ica = convertDataToJson;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Informacion detallada animal",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.black,
      ),
      body: ica== null ? Center(
        child: SpinKitWave(
          color: Colors.black,
          size: 75.0,
        ),
      ) : ListView(
        children: <Widget>[
          ListTile(
            leading:
            CircleAvatar(backgroundImage: NetworkImage(ica["photo"]),),
            title: Text(
              ica["name"],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(),
          ListTile(
            title: Text("Lugar encontrado: "+ ica["place_founded"].toString()),
          ),
          Divider(),
          ListTile(
            title: Text("fecha encontrado: "+ ica["date_founded"].toString()),
          ),
          Divider(),
          ListTile(
            title: Text("Raza: " +ica["race"].toString()),
          ),
          Divider(),
          ListTile(
            title: Text("Sexo: "+ ica["gender"].toString()),
          ),
          Divider(),
          ListTile(
            title: Text("especie: " +ica["species"].toString()),
          ),
          Divider(),
        ],
      ),
    );
  }
}