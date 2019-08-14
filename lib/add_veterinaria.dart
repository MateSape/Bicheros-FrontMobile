import 'package:flutter/material.dart';
import "dart:async";
import 'dart:io';
import 'package:dio/dio.dart';

class AddVeterinariaPage extends StatefulWidget {
  final String token;
  AddVeterinariaPage({Key key, this.token}) : super(key: key);
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
      // 192.168.0.X
      // 172.20.10.X
      // 192.168.100.235
      baseUrl: "http://192.168.100.113:8080/api/",
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
            leading: Text("Nombre: "),
            title: TextField(
              controller: name,
            ),
          ),
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
          color: Colors.white,
        ),
      ),
    );
  }
}
