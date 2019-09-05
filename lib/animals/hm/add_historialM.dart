import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class add_historialM_page extends StatefulWidget {
  final String token;
  final String baseDir;
  final int anid;

  add_historialM_page({Key key, this.token, this.baseDir, this.anid})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return add_historialM_page_state();
  }
}

class add_historialM_page_state extends State<add_historialM_page> {
  var dio = Dio();
  var options;
  var hm;

  var enfermedad = new TextEditingController();
  var fecha;
  var descripcion = new TextEditingController();
  String estado;

  List<DropdownMenuItem<String>> estados = [
    DropdownMenuItem(
      child: Text("Curado"),
      value: "0",
    ),
    DropdownMenuItem(
      child: Text("no curado"),
      value: "1",
    )
  ];

  @override
  void initState() {
    BaseOptions options = new BaseOptions(
      baseUrl: widget.baseDir + "/api/",
    );

    dio = Dio(options);
    super.initState();
  }

  Widget buildPage() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: TextField(
            controller: enfermedad,
          ),
          leading: Text("Enfermedad: "),
        ),
        ListTile(
            leading: Text("Fecha: "),
            title: fecha == null
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
                '${fecha.day}' +
                    "/" +
                    '${fecha.month}' +
                    "/" +
                    '${fecha.year}',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.lightBlue,
            )),
        ListTile(
          title: TextField(
            controller: descripcion,
          ),
          leading: Text("Descripcion: "),
        ),
        ListTile(
          title: DropdownButton(
            value: estado,
            items: estados,
            onChanged: (value) {
              setState(() {
                estado = value;
              });
            },
          ),
          leading: Text("Estado: "),
        ),
      ],
    );
  }

  Future getDate() async {
    final newDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (newDate != null && newDate != fecha) {
      setState(() {
        fecha = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add disease"),
      ),
      body: buildPage(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save_alt),
        onPressed: () {
          try {
            print (widget.anid);
            var formData = new FormData.from({
              "animal": widget.anid,
              "enfermedad": enfermedad.text,
              "fecha": '${fecha.year}-${fecha.month}-${fecha.day}',
              "description": descripcion.text,
              "estado": int.parse(estado),
            });
            dio
                .post('historial/',
                    data: formData,
                    options: Options(
                        method: 'PUT',
                        responseType: ResponseType.plain,
                        headers: {"Authorization": "Token ${widget.token}"}))
                .catchError((error) => print(error))
                .whenComplete(() {
              Navigator.pop(context);
            });
          } catch (e) {
            print (e);
            Alert(
                    context: context,
                    title: "Error",
                    desc: "Error, intente nuevamente.")
                .show();
          }
        },
      ),
    );
  }
}
