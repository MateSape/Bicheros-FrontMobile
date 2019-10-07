import 'package:flutter/material.dart';
import "dart:async";
import 'dart:io';
import 'package:dio/dio.dart';

class AddCapPage extends StatefulWidget {
  final String token;
  final String baseDir;

  AddCapPage({Key key, this.token, this.baseDir}) : super(key: key);
  @override
  AddCapPageState createState() => new AddCapPageState();
}

class AddCapPageState extends State<AddCapPage> {
  var dio;

  File image;
  var name = new TextEditingController();
  var surname = new TextEditingController();
  var email = new TextEditingController();
  DateTime birthDate;
  var address = new TextEditingController();
  var phone = new TextEditingController();

  @override
  void initState() {
    super.initState();

    BaseOptions options = new BaseOptions(
      baseUrl: widget.baseDir+"/api/",
    );
    dio = Dio(options);
  }

  Future getDate() async {
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
        title: Text("Agregar Adoptante"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: TextField(
              controller: name,
              decoration: InputDecoration(
                  hintText: "Nombre"
              ),
            ),
          ),
          ListTile(
            title: TextField(
              controller: surname,decoration: InputDecoration(
                hintText: "Apellido"
            ),

            ),
          ),
          ListTile(
              title: birthDate == null
                  ? MaterialButton(
                      onPressed: () => getDate(),
                      child: Text(
                        "fecha de nacimiento",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.lightBlue,
                    )
                  : MaterialButton(
                      onPressed: () => getDate(),
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
              controller: email,
              decoration: InputDecoration(
                hintText: "Email"
            ),

            ),
          ),
          ListTile(
            title: TextField(
              controller: address,
              decoration: InputDecoration(
                hintText: "Direccion"
            ),

            ),
          ),
          ListTile(
            title: TextField(
              controller: phone,
              decoration: InputDecoration(
                  hintText: "Telefono"
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FormData formData = new FormData.from({
            "nameC": name.text,
            "last_nameC": surname.text,
            "date_of_birth": birthDate.year.toString() +
                "-" +
                birthDate.month.toString() +
                "-" +
                birthDate.day.toString(),
            "address": address.text,
            "email": email.text,
            "telefono": phone.text
          });
          print(formData);
          dio
              .post("cap/",
                  data: formData,
                  options: Options(
                      method: 'POST',
                      responseType: ResponseType.plain,
                      headers: {"Authorization": "Token ${widget.token}"}))
              .whenComplete(() => Navigator.pop(context));
        },
        child: Icon(
          Icons.save_alt,
        ),
      ),
    );
  }
}
