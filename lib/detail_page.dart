import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DetailPage extends StatefulWidget {
  DetailPage(this.animal);
  final animal;
  @override
  _DetatailPageState createState() => _DetatailPageState(this.animal);
}

class _DetatailPageState extends State<DetailPage> {
  _DetatailPageState(this.animal);
  final animal;
  var ica;

  @override
  void initState() {
    getJsonData();
    super.initState();
  }

  Future getJsonData() async {
    var response = await http.get(Uri.encodeFull(
        "http://10.0.2.2:8000/api/animals/${animal.toString()}/"));

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
      body: ica == null
          ? Center(
              child: SpinKitWave(
                color: Colors.black,
                size: 75.0,
              ),
            )
          : ListView(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(ica["photo"]),
                  ),
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
                  title: Text(
                      "Lugar encontrado: " + ica["place_founded"].toString()),
                ),
                Divider(),
                ListTile(
                  title: Text(
                      "fecha encontrado: " + ica["date_founded"].toString()),
                ),
                Divider(),
                ListTile(
                  title: Text("Raza: " + ica["race"].toString()),
                ),
                Divider(),
                ListTile(
                  title: Text("Sexo: " + ica["gender"].toString()),
                ),
                Divider(),
                ListTile(
                  title: Text("especie: " + ica["species"].toString()),
                ),
                Divider(),
              ],
            ),
    );
  }
}
