import 'package:flutter/material.dart';
import "dart:async";
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddAnimalPage extends StatefulWidget {
  final String token;
  final String baseDir;
  AddAnimalPage({Key key, this.token, this.baseDir}) : super(key: key);
  @override
  AddAnimalPageState createState() => new AddAnimalPageState();
}

class AddAnimalPageState extends State<AddAnimalPage> {
  var dio;

  File image;
  var name = new TextEditingController();
  var race = new TextEditingController();
  DateTime dateFounded;
  var placeFounded = new TextEditingController();
  var species = new TextEditingController();
  var gender = false;
  var dropdownValue;
  var dropdownValue2;
  var temperamento = new TextEditingController();
  var video = new TextEditingController();
  DateTime birthDate;

  var dropdownButton;
  List<DropdownMenuItem<String>> caps = [];
  List<DropdownMenuItem<String>> vets = [];

  @override
  void initState() {
    BaseOptions options = new BaseOptions(
      baseUrl: widget.baseDir + "/api/",
    );
    dio = Dio(options);
    getCaps();
    getVets();
    super.initState();
  }

  Future getImage() async {
    var image2 = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = image2;
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

  Future getDateFounded() async {
    final newDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (newDate != null && newDate != dateFounded) {
      setState(() {
        dateFounded = newDate;
      });
    }
  }
  Future getBirthDate() async {
    final newDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (newDate != null && newDate != birthDate) {
      setState(() {
        birthDate = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Animal"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Text("Nombre: "),
            title: TextField(
              controller: name,
            ),
          ),
          ListTile(
            leading: Text("Lugar Encontrado: "),
            title: TextField(
              controller: placeFounded,
            ),
          ),
          ListTile(
              leading: Text("Fecha Encontrado: "),
              title: dateFounded == null
                  ? MaterialButton(
                      onPressed: () => getDateFounded(),
                      child: Text(
                        "Seleccione una fecha",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.lightBlue,
                    )
                  : MaterialButton(
                      onPressed: () => getDateFounded(),
                      child: Text(
                        '${dateFounded.day}' +
                            "/" +
                            '${dateFounded.month}' +
                            "/" +
                            '${dateFounded.year}',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.lightBlue,
                    )),
          ListTile(
              leading: Text("Fecha de nacimiento: "),
              title: birthDate == null
                  ? MaterialButton(
                onPressed: () => getBirthDate(),
                child: Text(
                  "Seleccione una fecha",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.lightBlue,
              )
                  : MaterialButton(
                onPressed: () => getBirthDate(),
                child: Text(
                  '${birthDate.day}' +
                      "/" +
                      '${birthDate.month}' +
                      "/" +
                      '${birthDate.year}',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.lightBlue,
              )),
          ListTile(
            leading: image == null
                ? CircleAvatar(
                    child: Text("N"),
                  )
                : IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: Image(image: FileImage(image)));
                          });
                    },
                    icon: CircleAvatar(
                      backgroundImage: FileImage(image),
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
            leading: Text("Raza: "),
            title: TextField(
              controller: race,
            ),
          ),
          ListTile(
            leading: Text("Video: "),
            title: TextField(
              controller: video,
            ),
          ),
          ListTile(
            title: DropdownButton<String>(
              hint: Text("Seleccione una opcion"),
              value: dropdownValue,
              items: caps.length == 0 ? null : caps,
              onChanged: (value) {
                setState(() {
                  dropdownValue = value;
                });
              },
            ),
            leading: Text("Cap"),
          ),
          ListTile(
            title: DropdownButton<String>(
              hint: Text("Seleccione una opcion"),
              value: dropdownValue2,
              items: vets.length == 0 ? null : vets,
              onChanged: (value) {
                setState(() {
                  dropdownValue2 = value;
                });
              },
            ),
            leading: Text("Ubicacion actual: "),
          ),
          ListTile(
              leading: Text("Sexo: "),
              title: MaterialButton(
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
              )),
          ListTile(
            leading: Text("Especie: "),
            title: TextField(
              controller: species,
            ),
          ),
          ListTile(
            leading: Text("Temperamento: "),
            title: TextField(
              controller: temperamento,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          try {
            FormData formData = new FormData.from({
              "name": name.text,
              "race": race.text,
              "temperamento": temperamento.text,
              "date_founded": dateFounded.year.toString() +
                  "-" +
                  dateFounded.month.toString() +
                  "-" +
                  dateFounded.day.toString(),
              "place_founded": placeFounded.text,
              "cap": dropdownValue == "9999" ? null : int.parse(dropdownValue),
              "veterinaria":
                  dropdownValue2 == "9999" ? null : int.parse(dropdownValue2),
              //"photo": image == null ? null : UploadFileInfo(image, image.path),
              "species": species.text,
              "gender": gender == false ? 0 : 1,
              "date_of_birth": birthDate.year.toString() +
                  "-" +
                  birthDate.month.toString() +
                  "-" +
                  birthDate.day.toString(),
              "video": video.text == "" ? null : video.text
            });
            dio.post("animals/",
                data: formData,
                options: Options(
                    method: 'POST',
                    responseType: ResponseType.plain,
                    headers: {"Authorization": "Token ${widget.token}"}));
            Navigator.pop(context);
          } catch (e) {
            Alert(context: context, title: "Error", desc: "Intente de nuevo")
                .show();
          }
        },
        child: Icon(
          Icons.save_alt,
          color: Colors.white,
        ),
      ),
    );
  }
}
