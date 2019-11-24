import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DetailCapPage extends StatefulWidget {
  final cap;
  final String token;
  final String baseDir;

  DetailCapPage({Key key, this.cap, this.token, this.baseDir})
      : super(key: key);

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
      baseUrl: widget.baseDir + "/api/",
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
      Text("Telefono: ${data["phone"]}"),
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
        title: TextField(
          controller: name,
          decoration: InputDecoration(hintText: "Nombre"),
        ),
      ),
      ListTile(
        title: TextField(
          controller: surname,
          decoration: InputDecoration(hintText: "Apellido"),
        ),
      ),
      ListTile(
        title: TextField(
          controller: address,
          decoration: InputDecoration(hintText: "Direccion"),
        ),
      ),
      ListTile(
        title: TextField(
          controller: birthdate,
          decoration: InputDecoration(hintText: "Fecha de nacimiento"),
        ),
      ),
      ListTile(
        title: TextField(
          controller: email,
          decoration: InputDecoration(hintText: "Email"),
        ),
      ),
      ListTile(
        title: TextField(
          controller: phone,
          decoration: InputDecoration(hintText: "Telefono"),
        ),
      ),
      ListTile(
          title: MaterialButton(
        onPressed: () {
          borrar();
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

  Future borrar() async {
    Alert(
      context: context,
      title: "-- Borrar Adoptante --",
      style: AlertStyle(
          titleStyle: TextStyle(color: Colors.white),
          descStyle: TextStyle(color: Colors.white)),
      desc: "Esta seguro que quiere borrar este adoptante?",
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
            try {
              dio
                  .delete("cap/${widget.cap}/",
                      options: Options(
                          method: 'PUT',
                          responseType: ResponseType.plain,
                          headers: {"Authorization": "Token ${widget.token}"}))
                  .whenComplete(() {
                Navigator.pop(context);
                Navigator.pop(context);
              });
            } catch (e) {
              Alert(
                      context: context,
                      title: "Error",
                      desc: "Error, intente nuevamente.")
                  .show();
            }
          },
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Informacion detallada Adoptante",
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
                color: Colors.white,
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
                  "phone": phone.text,
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
