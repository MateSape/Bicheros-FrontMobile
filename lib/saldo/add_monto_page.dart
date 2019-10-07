import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

//wizzard
BaseOptions options = new BaseOptions(
  baseUrl: "http:///192.168.100.235:8000/api/",
);

var dio = Dio(options);

class add_monto_page extends StatefulWidget {
  final token;
  final String baseDir;
  add_monto_page({Key key, this.token, this.baseDir}) : super(key: key);
  @override
  add_monto_page_state createState() => new add_monto_page_state();
}

class add_monto_page_state extends State<add_monto_page> {
  var dio;

  bool type = false;
  var Mdate;
  var amount = TextEditingController();

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
        title: Text("Añadir nuevo ingreso - gasto"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: TextField(
              controller: amount,
              decoration: InputDecoration(
                  hintText: "Monto"
              ),
            ),
          ),
          ListTile(
            title: MaterialButton(
                color: Colors.lightBlue,
                onPressed: () async {
                  final newDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));
                  if (newDate != null && newDate != Mdate) {
                    setState(() {
                      Mdate = newDate;
                    });
                  }
                },
                child: Mdate == null
                    ? Text(
                        "Seleccione una fecha",
                        style: TextStyle(color: Colors.white),
                      )
                    : Text(
                        '${Mdate.day.toString()} / ' +
                            '${Mdate.month.toString()} / ${Mdate.year.toString()}',
                        style: TextStyle(color: Colors.white))),
          ),
          ListTile(
            title: MaterialButton(
              onPressed: () {
                setState(() {
                  type = !type;
                });
              },
              child: type == false
                  ? Text(
                      "Ingreso",
                      style: TextStyle(color: Colors.white),
                    )
                  : Text("Gasto", style: TextStyle(color: Colors.white)),
              color: type == false ? Colors.greenAccent : Colors.redAccent,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dio
              .post("monto/",
                  data: {
                    "date": Mdate.year.toString() +
                        "-" +
                        Mdate.month.toString() +
                        "-" +
                        Mdate.day.toString(),
                    "amount": amount.text,
                    "tipo": type == false ? 0 : 1,
                  },
                  options: Options(headers: {
                    "Authorization":
                        "Token ${widget.token}"
                  }))
              .whenComplete(() => Navigator.pop(context));
        },
        child: Icon(
          Icons.save_alt,
        ),
      ),
    );
  }
}
