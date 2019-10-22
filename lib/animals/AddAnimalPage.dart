import 'package:flutter/material.dart';
import "dart:async";
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
  var past = new TextEditingController();
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
            title: TextField(
              decoration: InputDecoration(
                hintText: "Nombre"
              ),
              controller: name,
            ),
          ),
          ListTile(
            title: TextField(
              decoration: InputDecoration(
                  hintText: "Lugar Encontrado"
              ),
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
            title: TextField(
              decoration: InputDecoration(
                  hintText: "Raza"
              ),
              controller: race,
            ),
          ),
          ListTile(
            title: TextField(
              decoration: InputDecoration(
                  hintText: "Video"
              ),
              controller: video,
            ),
          ),
          ListTile(
            title: DropdownButton<String>(
              hint: Text("Seleccione un adoptante"),
              value: dropdownValue,
              items: caps.length == 0 ? null : caps,
              onChanged: (value) {
                setState(() {
                  dropdownValue = value;
                });
              },
            ),
          ),
          ListTile(
            title: DropdownButton<String>(
              hint: Text("Seleccione una veterinaria"),
              value: dropdownValue2,
              items: vets.length == 0 ? null : vets,
              onChanged: (value) {
                setState(() {
                  dropdownValue2 = value;
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
              )),
          ListTile(
            title: TextField(
              decoration: InputDecoration(
                  hintText: "Especie"
              ),
              controller: species,
            ),
          ),
          ListTile(
            title: TextField(
              decoration: InputDecoration(
                  hintText: "Temperamento"
              ),
              controller: temperamento,
            ),
          ),
          ListTile(
            title: TextField(
              decoration: InputDecoration(
                  hintText: "Historia"
              ),
              controller: past,
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
              "historia": past.text,
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
        ),
      ),
    );
  }
}
