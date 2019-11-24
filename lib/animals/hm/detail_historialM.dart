import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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

  var illness = new TextEditingController();
  var date = new TextEditingController();
  var description = new TextEditingController();
  String state;

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
      illness.text = hm["illness"];
      date.text = hm["date"];
      description.text = hm["description"];
      state = hm["state"].toString();
    });
  }

  Widget buildPage() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: TextField(
            controller: illness,
            decoration: InputDecoration(
              hintText: "Enfermedad"
            ),
          ),
        ),
        ListTile(
          title: TextField(
            controller: date,
            decoration: InputDecoration(
                hintText: "Fecha"
            ),
          ),
        ),
        ListTile(
          title: TextField(
            controller: description,
            decoration: InputDecoration(
                hintText: "Descripcion"
            ),
          ),
        ),
        ListTile(
          title: DropdownButton(
            value: state,
            items: estados,
            hint: Text("Estado"),
            onChanged: (value) {
              setState(() {
                state = value;
              });
            },
          ),
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
    Alert(
      context: context,
      title: "-- Borrar Enfermedad --",
      style: AlertStyle(
          titleStyle: TextStyle(color: Colors.white),
          descStyle: TextStyle(color: Colors.white)),
      desc: "Esta seguro que quiere borrar esta enfermedad?",
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
          },
        ),
      ],
    ).show();
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
              "enfermedad": illness.text,
              "fecha": date.text,
              "description": description.text,
              "estado": int.parse(state),
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
