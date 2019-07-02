import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';

BaseOptions options = new BaseOptions(
  baseUrl: "http://172.20.10.3:8000/api/",
);

var dio = Dio(options);

class DetailPage extends StatefulWidget {
  final animal;

  DetailPage({Key key, this.animal}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var name = new TextEditingController();
  var race = new TextEditingController();
  DateTime dateFounded;
  var placeFounded = new TextEditingController();
  var species = new TextEditingController();
  var gender = new TextEditingController();

  var editMode = false;
  var ica;

  @override
  void initState() {
    getJsonData();
    super.initState();
  }

  Future getJsonData() async {
    var response = await dio.get(
        "animals/${widget.animal.toString()}/");

    setState(() {
      ica = response.data;
    });
  }

  Widget _renderAnimalDetail() {
    List<Widget> items = [
      Text(
        ica["name"],
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text("Lugar encontrado: ${ica["place_founded"]}"),
      Text("Fecha encontrado: ${ica["date_founded"]}"),
      Text("Raza: ${ica["race"]}"),
      Text("Sexo: ${ica["gender"]}"),
      Text("Especie: ${ica["species"]}"),
    ];

    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) => index == 0
          ? ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(ica["photo"]),
              ),
              title: items[index],
            )
          : ListTile(title: items[index]),
      separatorBuilder: (context, index) => Divider(),
    );
  }

  Widget _renderAnimalEdit () {
    name.text = ica["name"];
    placeFounded.text = ica["place_founded"];
    //dateFounded = ica["date_founded"];
    race.text = ica["race"];
    gender.text = ica["gender"];
    species.text = ica["species"];
    List<Widget> items = [
      ListTile(
        leading: Text("nombre"),
        title: TextField(
          controller: name,
        ),
      ),
      ListTile(
        leading: Text("Lugar encontrado"),
        title: TextField(
          controller: placeFounded,
        ),
      ),
      ListTile(
        leading: Text("fecha encontrado"),
        title: TextField(
        ),
      ),
      ListTile(
        leading: Text("Raza"),
        title: TextField(
          controller: race,
        ),
      ),
      ListTile(
        leading: Text("sexo"),
        title: TextField(
          controller: gender,
        ),
      ),
      ListTile(
        leading: Text("Especie"),
        title: TextField(
          controller: species,
        ),
      ),
    ];
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) => items[index],
      separatorBuilder: (context, index) => Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Informacion detallada animal",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                this.editMode = !this.editMode;
              });
            },
            icon: Icon(editMode == false ? Icons.mode_edit : Icons.remove_red_eye,
            color: Colors.white,),
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
          : editMode == false ? _renderAnimalDetail() : _renderAnimalEdit(),
    floatingActionButton: editMode == false ? null : FloatingActionButton(
        onPressed: () {
          dio.put('animals/${widget.animal.toString()}/',
              data:{
              "name": name.text,
              "race": race.text,
              "place_founded": placeFounded.text,
              "species": species.text,
              "gender": 1,
              });
        },
        child: Icon(Icons.save_alt),),
    );
  }
}
