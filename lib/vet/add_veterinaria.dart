import 'package:flutter/material.dart';
import "dart:async";
import 'dart:io';
import 'package:dio/dio.dart';

class AddVeterinariaPage extends StatefulWidget {
  final String token;
  final String baseDir;

  AddVeterinariaPage({Key key, this.token, this.baseDir}) : super(key: key);
  @override
  AddVeterinariaPageState createState() => new AddVeterinariaPageState();
}

class AddVeterinariaPageState extends State<AddVeterinariaPage> {
  var dio;

  File image;
  var name = new TextEditingController();
  var email = new TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Veterinaria"),
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
              controller: email,
              decoration: InputDecoration(
                  hintText: "email"
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
            "name": name.text,
            "address": address.text,
            "email": email.text,
            "phone": phone.text
          });
          print(formData);
          dio
              .post("veterinaria/",
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
