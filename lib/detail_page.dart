import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:youtube_player/youtube_player.dart';
import 'package:bicheros_frontmobile/historialM_page.dart';

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
  var gender;
  var placeFounded = new TextEditingController();
  var species = new TextEditingController();
  var temperamento = new TextEditingController();
  var video = new TextEditingController();
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

  Future getImage() async {
    var image2 = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      newImage = image2;
    });
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
      Text("Adoptante: " +
          (cap == null ? " Ninguno." : cap["nameC"] + " " + cap["last_nameC"])),
      Text("Ubicacion actual: " + (vet == null ? " Ninguna." : vet["name"])),
      ica["video"] != null
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
          : Text("Link nulo o no valido"),
      Text("Sexo: ${ica["gender"]}"),
      Text("Especie: ${ica["species"]}"),
      Text("Temperamento: ${ica["temperamento"]}"),
      MaterialButton(
        child: Text("Historial medico"),
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
    ];

    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) => index == 0
          ? ListTile(
              leading: IconButton(
                onPressed: () {
                  if (ica["photo"] != null) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Image.network(ica["photo"]));
                        });
                  }
                  ;
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
      video.text = ica["video"];
      if (ica["cap"] == null) {
        capValue = "9999";
      } else {
        capValue = ica["cap"].toString();
      }
      if (ica["veterinaria"] == null) {
        vetValue = "9999";
      } else {
        vetValue = ica["veterinaria"].toString();
      }
      temperamento.text = ica["temperamento"];
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
        leading: Text("Video"),
        title: TextField(
          controller: video,
        ),
      ),
      ListTile(
        title: DropdownButton<String>(
          hint: Text("Seleccione una opcion"),
          value: capValue,
          items: caps.length == 0 ? null : caps,
          onChanged: (value) {
            setState(() {
              capValue = value;
            });
          },
        ),
        leading: Text("Cap"),
      ),
      ListTile(
        title: DropdownButton<String>(
          hint: Text("Seleccione una opcion"),
          value: vetValue,
          items: vets.length == 0 ? null : vets,
          onChanged: (value) {
            setState(() {
              vetValue = value;
            });
          },
        ),
        leading: Text("Ubicacion actual: "),
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
        leading: Text("Temperamento"),
        title: TextField(
          controller: temperamento,
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
                  if (ica["photo"] != null) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Image(image: NetworkImage(ica["photo"])));
                        });
                  }
                  ;
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
              options:
                  Options(headers: {"Authorization": "Token ${widget.token}"}));
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
                formData = new FormData.from({
                  "name": name.text,
                  "race": race.text,
                  "place_founded": placeFounded.text,
                  "date_founded": dateFounded.text,
                  "species": species.text,
                  "cap": capValue == "9999" ? null : int.parse(capValue),
                  "veterinaria":
                      vetValue == "9999" ? null : int.parse(vetValue),
                  "gender": gender == false ? 0 : 1,
                  "video": video.text,
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
