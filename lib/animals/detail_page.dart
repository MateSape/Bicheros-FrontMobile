import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:dio/dio.dart';
import 'package:youtube_player/youtube_player.dart';
import 'photos/photosPage.dart';
import 'package:bicheros_frontmobile/animals/hm/historialM_page.dart';

class DetailPage extends StatefulWidget {
  final animal;
  final String token;
  final String baseDir;

  DetailPage({Key key, this.animal, this.token, this.baseDir})
      : super(key: key);

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
  List<DropdownMenuItem<String>> caps = [];
  var cap;
  var capValue;
  List<DropdownMenuItem<String>> vets = [];
  var vet;
  var vetValue;
  var dateFounded = new TextEditingController();
  var birthDate = new TextEditingController();
  var gender;
  var placeFounded = new TextEditingController();
  var species = new TextEditingController();
  var temperament = new TextEditingController();
  var video = new TextEditingController();
  var past = new TextEditingController();
  var editMode = false;
  var ica;

  @override
  void initState() {
    super.initState();

    BaseOptions options = new BaseOptions(
      baseUrl: widget.baseDir + "/api/",
    );
    dio = Dio(options);
    getJsonData();
  }

  Future getJsonData() async {
    var response = await dio.get("animals/${widget.animal.toString()}/",
        options: Options(headers: {"Authorization": "Token ${widget.token}"}));

    setState(() {
      ica = response.data;
    });

    if (ica["cap"] != null) {
      getCap();
    }
    getCaps();

    if (ica["veterinaria"] != null) {
      getVet();
    }
    getVets();
  }

  Future getCap() async {
    var response = await dio.get("cap/${ica["cap"].toString()}/",
        options: Options(headers: {"Authorization": "Token ${widget.token}"}));
    setState(() {
      cap = response.data;
    });
  }

  Future getCaps() async {
    var response = await dio.get('cap/',
        options: Options(headers: {"Authorization": "Token ${widget.token}"}));
    setState(() {
      caps.add(DropdownMenuItem(
        child: Text("Ninguno."),
        value: "9999",
      ));
      for (int x = 0; x < response.data.length; x++) {
        caps.add(DropdownMenuItem(
          child: Text(
              response.data[x]["nameC"] + " " + response.data[x]["last_nameC"]),
          value: response.data[x]["id_cap"].toString(),
        ));
      }
    });
  }

  Future getVet() async {
    var response = await dio.get(
        "veterinaria/${ica["veterinaria"].toString()}/",
        options: Options(headers: {"Authorization": "Token ${widget.token}"}));
    setState(() {
      vet = response.data;
    });
  }

  Future getVets() async {
    var response = await dio.get('veterinaria/',
        options: Options(headers: {"Authorization": "Token ${widget.token}"}));
    setState(() {
      vets.add(DropdownMenuItem(
        child: Text("Ninguno."),
        value: "9999",
      ));
      for (int x = 0; x < response.data.length; x++) {
        vets.add(DropdownMenuItem(
          child: Text(response.data[x]["name"]),
          value: response.data[x]["id_veterinaria"].toString(),
        ));
      }
    });
  }

  Widget _renderAnimalDetail() {
    List<Widget> items = [
      Text(
        ica["name"] == null ? "*****" : ica["name"],
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
          "Lugar encontrado: ${ica["place_founded"] == null ? "*****" : ica["place_founded"]}"),
      Text(
          "Fecha encontrado: ${ica["date_founded"] == null ? "*****" : ica["date_founded"]}"),
      Text(
          "Fecha de nacimiento: ${ica["date_of_birth"] == null ? "*****" : ica["date_of_birth"]}"),
      Text("Raza: ${ica["race"] == null ? "*****" : ica["race"]}"),
      Text("Adoptante: " +
          (cap == null ? " Ninguno." : cap["nameC"] + " " + cap["last_nameC"])),
      Text("Ubicado en: " + (vet == null ? " Ninguna." : vet["name"])),
      ica["video"] != null
          ? ica["video"] != ""
              ? ListTile(
                  leading: Text("Video"),
                  title: YoutubePlayer(
                    width: 225,
                    autoPlay: false,
                    context: context,
                    source: ica["video"],
                    quality: YoutubeQuality.LOWEST,
                    // callbackController is (optional).
                    // use it to control player on your own.
                    callbackController: (controller) {
                      var _videoController = controller;
                    },
                  ),
                )
              : Text("Link nulo o no valido")
          : Text("Link nulo o no valido"),
      Text("Sexo: ${ica["sex"] == null ? "*****" : ica["sex"]}"),
      Text("Especie: ${ica["species"] == null ? "*****" : ica["species"]}"),
      Text(
          "Temperamento: ${ica["temperament"] == null ? "*****" : ica["temperament"]}"),
      Text("Historia: ${ica["history"] == null ? "*****" : ica["history"]}"),
      MaterialButton(
        child: Text(
          "Historial medico",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => historialMPage(
                token: widget.token,
                baseDir: widget.baseDir,
                anid: ica["id_animal"],
              ),
            ),
          );
        },
      ),
      MaterialButton(
        child: Text(
          "Fotos",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => photosPage(
                token: widget.token,
                baseDir: widget.baseDir,
                anid: ica["id_animal"],
              ),
            ),
          );
        },
      ),
    ];

    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) => index == 0
          ? ListTile(
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
      birthDate.text = ica["date_of_birth"];
      race.text = ica["race"];
      gender = ica["sex"] == "Macho" ? false : true;
      species.text = ica["species"];
      video.text = ica["video"] == "" ? null : ica["video"];
      if (ica["cap"] == null) {
        capValue = "9999";
      } else {
        capValue = ica["cap"].toString();
      }
      if (ica["veterinary"] == null) {
        vetValue = "9999";
      } else {
        vetValue = ica["veterinary"].toString();
      }
      temperament.text = ica["temperament"];
      past.text = ica["history"];
    }
    return editMode == false ? _renderAnimalDetail() : _renderAnimalEdit();
  }

  Widget _renderAnimalEdit() {
    List<Widget> items = [
      ListTile(
        title: TextField(
          decoration: InputDecoration(hintText: "Nombre"),
          controller: name,
        ),
      ),
      ListTile(
        title: TextField(
          decoration: InputDecoration(hintText: "Lugar encontrado"),
          controller: placeFounded,
        ),
      ),
      ListTile(
        title: TextField(
          decoration: InputDecoration(hintText: "Fecha encontrado"),
          controller: dateFounded,
        ),
      ),
      ListTile(
        title: TextField(
          decoration: InputDecoration(hintText: "Fecha de nacimiento"),
          controller: birthDate,
        ),
      ),
      ListTile(
        title: TextField(
          decoration: InputDecoration(hintText: "raza"),
          controller: race,
        ),
      ),
      ListTile(
        title: TextField(
          decoration: InputDecoration(hintText: "video"),
          controller: video,
        ),
      ),
      ListTile(
        title: DropdownButton<String>(
          hint: Text("Seleccione un adoptante"),
          value: capValue,
          items: caps.length == 0 ? null : caps,
          onChanged: (value) {
            setState(() {
              capValue = value;
            });
          },
        ),
      ),
      ListTile(
        title: DropdownButton<String>(
          hint: Text("Seleccione una veterinaria"),
          value: vetValue,
          items: vets.length == 0 ? null : vets,
          onChanged: (value) {
            setState(() {
              vetValue = value;
            });
          },
        ),
      ),
      ListTile(
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
        title: TextField(
          decoration: InputDecoration(hintText: "Especie"),
          controller: species,
        ),
      ),
      ListTile(
        title: TextField(
          decoration: InputDecoration(hintText: "Temperamento"),
          controller: temperament,
        ),
      ),
      ListTile(
        title: TextField(
          decoration: InputDecoration(hintText: "Historia"),
          controller: past,
        ),
      ),
      ListTile(
          title: MaterialButton(
        onPressed: () {
          Alert(
            context: context,
            title: "-- Borrar Foto --",
            style: AlertStyle(
                titleStyle: TextStyle(color: Colors.white),
                descStyle: TextStyle(color: Colors.white)),
            desc: "Esta seguro que quiere borrar esta foto?",
            buttons: <DialogButton>[
              DialogButton(
                child: Text(
                  "No, todavia no",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              DialogButton(
                child: Text(
                  "Si, estoy seguro",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
                onPressed: () {
                  dio.delete("animals/${widget.animal.toString()}/",
                      options: Options(
                          headers: {"Authorization": "Token ${widget.token}"}));
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ).show();
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
                color: Colors.white,
                size: 75.0,
              ),
            )
          : _changeScreen(),
      floatingActionButton: editMode == false
          ? null
          : FloatingActionButton(
              onPressed: () {
                print(video.text);
                formData = new FormData.from({
                  "name": name.text,
                  "race": race.text,
                  "place_founded": placeFounded.text,
                  "date_founded": dateFounded.text,
                  "date_of_birth": birthDate.text,
                  "species": species.text,
                  "cap": capValue == "9999" ? null : int.parse(capValue),
                  "veterinaria":
                      vetValue == "9999" ? null : int.parse(vetValue),
                  "gender": gender == false ? 0 : 1,
                  "video": video.text == " " ? null : video.text,
                  "temperament": temperament.text,
                  "historia": past.text
                });
                dio
                    .put('animals/${widget.animal.toString()}/',
                        data: formData,
                        options: Options(
                            method: 'PUT',
                            responseType: ResponseType.plain,
                            headers: {
                              "Authorization": "Token ${widget.token}"
                            }))
                    .catchError((error) => print(error));
                Navigator.pop(context);
              },
              child: Icon(Icons.save_alt),
            ),
    );
  }
}
