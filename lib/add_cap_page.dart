import 'package:flutter/material.dart';
import "dart:async";
import 'dart:io';
import 'package:dio/dio.dart';

class AddCapPage extends StatefulWidget {
  final String token;
  AddCapPage({Key key, this.token}) : super(key: key);
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
      // 192.168.0.X
      // 172.20.10.X
      // 192.168.100.235
      baseUrl: "http://192.168.100.113:8080/api/",
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
            leading: Text("Apellido: "),
            title: TextField(
              controller: surname,
            ),
          ),
          ListTile(
              leading: Text("Fecha de nacimiento: "),
              title: birthDate == null
                  ? MaterialButton(
                      onPressed: () => getDate(),
                      child: Text(
                        "Seleccione una fecha",
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
            leading: Text("email: "),
            title: TextField(
              controller: email,
            ),
          ),
          ListTile(
            leading: Text("Direccion: "),
            title: TextField(
              controller: address,
            ),
          ),
          ListTile(
            leading: Text("Telefono: "),
            title: TextField(
              controller: phone,
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
          color: Colors.white,
        ),
      ),
    );
  }
}
