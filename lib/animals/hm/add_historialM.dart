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

  var illness = new TextEditingController();
  var date;
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
    super.initState();
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
            title: date == null
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
                '${date.day}' +
                    "/" +
                    '${date.month}' +
                    "/" +
                    '${date.year}',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.lightBlue,
            )),
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
             hint: Text("Elija un estado"),
              value: state,
              items: estados,
              onChanged: (value) {
                setState(() {
                  state = value;
                });
              },
            ),
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
    if (newDate != null && newDate != date) {
      setState(() {
        date = newDate;
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
              "illness": illness.text,
              "date": '${date.year}-${date.month}-${date.day}',
              "description": description.text,
              "state": int.parse(state),
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
