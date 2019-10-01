import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';

class detail_saldo extends StatefulWidget {
  final token;
  final String baseDir;
  final saldo;

  detail_saldo({Key key, this.saldo, this.token, this.baseDir}) : super(key: key);

  @override
  _DetailSaldoState createState() => _DetailSaldoState();
}

class _DetailSaldoState extends State<detail_saldo> {
  var dio;

  var puchito = false;
  var monto = new TextEditingController();
  var tipo = false;
  var date = new TextEditingController();

  var ica;
  var type = false;

  @override
  void initState() {
    super.initState();

    BaseOptions options = new BaseOptions(
      baseUrl: widget.baseDir+"/api/",
    );
    dio = Dio(options);
  }

  Future getJsonData() async {
    if (puchito == false) {
      var response = await dio.get("monto/${widget.saldo.toString()}/",
          options: Options(headers: {
            "Authorization": "Token ${widget.token}"
          }));

      setState(() {
        ica = response.data;
      });
      monto.text = ica["amount"].toString();
      date.text = ica["date"];
      if (ica["tipo"] == "Gasto") {
        type = true;
      }
    }
  }

  Widget buildDetail() {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Text("Monto"),
          title: TextField(
            controller: monto,
          ),
        ),
        ListTile(
          title: TextField(
            controller: date,
          ),
          leading: Text("Fecha"),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    getJsonData();
    puchito = true;
    return Scaffold(
      appBar: AppBar(
        title: Text("Modificar monto"),
      ),
      body: ica == null
          ? Center(
              child: SpinKitWave(
                color: Colors.white,
                size: 75.0,
              ),
            )
          : buildDetail(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dio
              .put("monto/${ica['id']}/",
                  data: {
                    "date": date.text,
                    "amount": monto.text,
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
          color: Colors.white,
        ),
      ),
    );
  }
}
