import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class DetailCapPage extends StatefulWidget {
  final cap;
  final String token;

  DetailCapPage({Key key, this.cap, this.token}) : super(key: key);

  @override
  _DetailCapPageState createState() => _DetailCapPageState();
}

class _DetailCapPageState extends State<DetailCapPage> {
  var dio;

  var puchito = false; //trolling
  FormData formData;
  var name = new TextEditingController();
  var surname = new TextEditingController();
  var birthdate = new TextEditingController();
  var address = new TextEditingController();
  var phone = new TextEditingController();
  var email = new TextEditingController();
  var editMode = false;
  var data;

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
    var response = await dio.get("cap/${widget.cap.toString()}/",
        options: Options(headers: {"Authorization": "Token ${widget.token}"}));

    setState(() {
      data = response.data;
    });
  }

  Widget _renderAnimalDetail() {
    List<Widget> items = [
      Text(
        data["nameC"] + " " + data["last_nameC"],
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text("Direccion: ${data["address"]}"),
      Text("Fecha de nacimiento: ${data["date_of_birth"]}"),
      Text("email: ${data["email"]}"),
      Text("Telefono: ${data["telefono"]}"),
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
      name.text = data["nameC"];
      surname.text = data["last_nameC"];
      address.text = data["address"];
      birthdate.text = data["date_of_birth"];
      email.text = data["email"];
      phone.text = data["telefono"];
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
        leading: Text("apellido"),
        title: TextField(
          controller: surname,
        ),
      ),
      ListTile(
        leading: Text("Direccion"),
        title: TextField(
          controller: address,
        ),
      ),
      ListTile(
        leading: Text("fecha de nacimiento"),
        title: TextField(
          controller: birthdate,
        ),
      ),
      ListTile(
        leading: Text("email"),
        title: TextField(
          controller: email,
        ),
      ),
      ListTile(
        leading: Text("telefono"),
        title: TextField(
          controller: phone,
        ),
      ),
      ListTile(
          title: MaterialButton(
        onPressed: () {
          dio.delete("cap/${widget.cap.toString()}/",
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
      body: data == null
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
                  "nameC": name.text,
                  "last_nameC": surname.text,
                  "address": address.text,
                  "date_of_birth": birthdate.text,
                  "telefono": phone.text,
                  "email": email.text,
                });

                dio
                    .put('cap/${widget.cap.toString()}/',
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
