import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

BaseOptions options = new BaseOptions(
  baseUrl: "http:///192.168.0.21:8000/api/",
);

var dio = Dio(options);

class DetailPage extends StatefulWidget {
  final animal;

  DetailPage({Key key, this.animal}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var puchito = false; //trolling
  File image;
  var name = new TextEditingController();
  var race = new TextEditingController();
  var dateFounded = new TextEditingController();
  var gender;
  var placeFounded = new TextEditingController();
  var species = new TextEditingController();

  var editMode = false;
  var ica;

  @override
  void initState() {
    getJsonData();
    super.initState();
  }

  Future getJsonData() async {
    var response = await dio.get("animals/${widget.animal.toString()}/");

    setState(() {
      ica = response.data;
    });
  }

  Future getImage() async {
    var image2 = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = image2;
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
                backgroundImage:
                    ica["photo"] == null ? null : NetworkImage(ica["photo"]),
              ),
              title: items[index],
            )
          : ListTile(title: items[index]),
      separatorBuilder: (context, index) => Divider(),
    );
  }

  Widget _changeScreen() {
    if (puchito == false) {
      puchito = true;
      name.text = ica["name"];
      placeFounded.text = ica["place_founded"];
      dateFounded.text = ica["date_founded"];
      race.text = ica["race"];
      gender = ica["gender"] == "Masculino" ? false : true;
      species.text = ica["species"];
    }
    return editMode == false ? _renderAnimalDetail() : _renderAnimalEdit();
  }

  Widget _renderAnimalEdit() {
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
          controller: dateFounded,
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
        title: Row(
          children: <Widget>[
            MaterialButton(
              onPressed: () {
                setState(() {
                  gender = !gender;
                });
              },
              child: gender == false
                  ? Text(
                      "Masculino",
                      style: TextStyle(color: Colors.white),
                    )
                  : Text("Femenino", style: TextStyle(color: Colors.white)),
              color: gender == false ? Colors.lightBlue : Colors.redAccent,
            ),
          ],
        ),
      ),
      ListTile(
        leading: Text("Especie"),
        title: TextField(
          controller: species,
        ),
      ),
      ListTile(
        leading: MaterialButton(
          color: Colors.lightBlue,
          onPressed: () => getImage(),
          child: Icon(
            Icons.image,
            color: Colors.white,
          ),
        ),
        title: image == null
            ? Text('No image selected.')
            : Text(
                image.path,
                textAlign: TextAlign.end,
              ),
      ),
      ListTile(
          title: MaterialButton(
        onPressed: () {
          dio.delete("animals/${widget.animal.toString()}/");
          Navigator.pop(context);
        },
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      )),
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
            icon: Icon(
              editMode == false ? Icons.mode_edit : Icons.remove_red_eye,
              color: Colors.white,
            ),
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
          : _changeScreen(),
      floatingActionButton: editMode == false
          ? null
          : FloatingActionButton(
              onPressed: () {
                FormData formData = new FormData.from({
                  "name": name.text,
                  "race": race.text,
                  "place_founded": placeFounded.text,
                  "date_founded": dateFounded.text,
                  "species": species.text,
                  "gender": gender == false ? 0 : 1,
                  "photo":
                      image == null ? null : UploadFileInfo(image, image.path),
                });
                dio
                    .put('animals/${widget.animal.toString()}/',
                        data: formData,
                        options: Options(
                            method: 'PUT', responseType: ResponseType.plain))
                    .catchError((error) => print(error));
                Navigator.pop(context);
              },
              child: Icon(Icons.save_alt),
            ),
    );
  }
}
