import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class DetailPage extends StatefulWidget {
  final animal;
  final String token;

  DetailPage({Key key, this.animal, this.token}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var dio;

  var puchito = false; //trolling
  FormData formData;
  File newImage;
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
    super.initState();

    BaseOptions options = new BaseOptions(
      // 192.168.0.X
      // 172.20.10.X
      // 192.168.100.235
      baseUrl: "http://192.168.100.231:8080/api/",
    );
    dio = Dio(options);
    getJsonData();
  }

  Future getJsonData() async {
    var response = await dio.get("animals/${widget.animal.toString()}/",
        options: Options(headers: {
          "Authorization": "Token ${widget.token}"
        }));

    setState(() {
      ica = response.data;
    });
  }

  Future getImage() async {
    var image2 = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      newImage = image2;
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
              leading: IconButton(
                onPressed: () {
                  if (ica["photo"] != null){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(title: Image.network(ica["photo"]));
                        });
                  };
                },
                icon: CircleAvatar(
                  backgroundImage:
                      ica["photo"] == null ? null : NetworkImage(ica["photo"]),
                ),
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
        title: MaterialButton(
          onPressed: () {
            setState(() {
              gender = !gender;
            });
          },
          child: gender == false
              ? Text(
                  "Macho",
                  style: TextStyle(color: Colors.white),
                )
              : Text("Hembra", style: TextStyle(color: Colors.white)),
          color: gender == false ? Colors.lightBlue : Colors.redAccent,
        ),
      ),
      ListTile(
        leading: Text("Especie"),
        title: TextField(
          controller: species,
        ),
      ),
      ListTile(
        leading: newImage == null
            ? IconButton(
          icon: CircleAvatar(
            backgroundImage:
            ica["photo"] == null ? null : NetworkImage(ica["photo"]),
          ),
          onPressed: () {
            if (ica["photo"] != null){
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Image(image: NetworkImage(ica["photo"])));
                  });
            };
          },
        )
            : IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Image(image: FileImage(newImage)));
                      });
                },
                icon: CircleAvatar(
                  backgroundImage: FileImage(newImage),
                ),
              ),
        title: MaterialButton(
          color: Colors.lightBlue,
          onPressed: () => getImage(),
          child: Icon(
            Icons.image,
            color: Colors.white,
          ),
        ),
      ),
      ListTile(
          title: MaterialButton(
        onPressed: () {
          dio.delete("animals/${widget.animal.toString()}/",
              options: Options(headers: {
                "Authorization":
                    "Token ${widget.token}"
              }));
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
                if (newImage == null) {
                  formData = new FormData.from({
                    "name": name.text,
                    "race": race.text,
                    "place_founded": placeFounded.text,
                    "date_founded": dateFounded.text,
                    "species": species.text,
                    "gender": gender == false ? 0 : 1,
                  });
                } else {
                  formData = new FormData.from({
                    "name": name.text,
                    "race": race.text,
                    "place_founded": placeFounded.text,
                    "date_founded": dateFounded.text,
                    "species": species.text,
                    "gender": gender == false ? 0 : 1,
                    "photo": UploadFileInfo(newImage, newImage.path),
                  });
                }
                dio
                    .put('animals/${widget.animal.toString()}/',
                        data: formData,
                        options: Options(
                            method: 'PUT',
                            responseType: ResponseType.plain,
                            headers: {
                              "Authorization":
                                  "Token ${widget.token}"
                            }))
                    .catchError((error) => print(error));
                Navigator.pop(context);
              },
              child: Icon(Icons.save_alt),
            ),
    );
  }
}
