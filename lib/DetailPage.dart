import 'package:flutter/material.dart';
import "dart:async";
import 'dart:io';
import "package:http/http.dart" as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

BaseOptions options = new BaseOptions(
  baseUrl: "http://192.168.0.7:8000/api/animals/",
);

var dio = Dio(options);

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
  File image;

  @override
  void initState() {
    getJsonData();
    super.initState();
  }

  Future getJsonData() async {
    var response = await dio.get(animal.toString() + "/");

    setState(() {
      var convertDataToJson = response.data;
      ica = convertDataToJson;
    });
  }

  Future getImage() async {
    var image2 = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = image2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ica == null ? " " : ica["name"],
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              dio.delete(animal.toString() + "/");
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ica == null
          ? Center(
              child: SpinKitWave(
                color: Colors.black,
                size: 75.0,
              ),
            )
          : ListView(
        padding: EdgeInsets.only(top: 25),
              children: <Widget>[
                Divider(),
                ListTile(
                  leading: Image.network(
                    ica["photo"],
                    height: 150.0,
                    width: 95.0,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => {},
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
    );
  }
}
