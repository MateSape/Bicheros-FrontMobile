import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class detail_historialM_page extends StatefulWidget {
  final String token;
  final String baseDir;
  final int hid;

  detail_historialM_page({Key key, this.token, this.baseDir, this.hid})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return detail_historialM_page_state();
  }
}

class detail_historialM_page_state extends State<detail_historialM_page> {
  var dio = Dio();
  var options;
  var hm;

  var enfermedad = new TextEditingController();
  var fecha = new TextEditingController();
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

    getJsonData();

    super.initState();
  }

  Future getJsonData() async {
    var response = await dio.get("historial/${widget.hid}",
        options: Options(headers: {"Authorization": "Token ${widget.token}"}));

    setState(() {
      hm = response.data;
      enfermedad.text = hm["enfermedad"];
      fecha.text = hm["fecha"];
      descripcion.text = hm["description"];
      estado = hm["estado"].toString();
    });
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
          title: TextField(
            controller: fecha,
          ),
          leading: Text("Fecha: "),
        ),
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
        ListTile(
          title: MaterialButton(
            onPressed: () => delHM(),
            child: Icon(Icons.delete,
            color: Colors.white,),
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Future delHM() async {
    try{
      dio.delete("historial/${widget.hid}/",
          options: Options(
              method: 'PUT',
              responseType: ResponseType.plain,
              headers: {
                "Authorization": "Token ${widget.token}"
              })
      ).whenComplete(() {
        Navigator.pop(context);
      });
    }
    catch(e){
      Alert(
          context: context,
          title: "Error",
          desc: "Error, intente nuevamente.")
          .show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disease"),
      ),
      body: hm == null
          ? Center(
              child: SpinKitWave(
                color: Colors.white,
                size: 75.0,
              ),
            )
          : buildPage(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save_alt),
        onPressed: () {
          try{
            var formData = new FormData.from({
              "enfermedad": enfermedad.text,
              "fecha": fecha.text,
              "description": descripcion.text,
              "estado": int.parse(estado),
            });
            dio
                .put('historial/${widget.hid.toString()}/',
                data: formData,
                options: Options(
                    method: 'PUT',
                    responseType: ResponseType.plain,
                    headers: {
                      "Authorization": "Token ${widget.token}"
                    }))
                .catchError((error) => print(error));
            Navigator.pop(context);
          }
          catch(e) {
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
