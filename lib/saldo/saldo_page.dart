import 'package:flutter/material.dart';
import "dart:async";
import 'add_monto_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'detail_saldo.dart';

class saldo_page extends StatefulWidget {
  final String token;
  final String baseDir;
  saldo_page({Key key, this.token, this.baseDir}) : super(key: key);
  @override
  saldo_page_state createState() => new saldo_page_state();
}

class saldo_page_state extends State<saldo_page> {
  var dio;

  double saldo = 0;
  var puchito = false;
  var balance;
  var input = new TextEditingController();

  @override
  void initState() {
    super.initState();
    puchito = true;

    BaseOptions options = new BaseOptions(
      baseUrl: widget.baseDir + "/api/",
    );
    dio = Dio(options);
    getJsonData();
  }

  Future getJsonData() async {
    var response = await dio.get("monto/",
        options: Options(headers: {"Authorization": "Token ${widget.token}"}));
    setState(() {
      balance = response.data;
      saldo = 0;
      for (var x = 0; x < balance.length; x++) {
        if (balance[x]["type"] == "Deposit") {
          saldo += balance[x]["amount"];
        } else {
          saldo -= balance[x]["amount"];
        }
      }
    });
  }

  Widget buildPage() {
    return RefreshIndicator(
      onRefresh: () => getJsonData(),
      child: ListView.builder(
        itemBuilder: (context, index) {
          if (index == 0) {
            return ListTile(
              title: saldo < 0
                  ? Text(
                      "Saldo: ${saldo.toString()}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    )
                  : Text(
                      "Saldo: ${saldo.toString()}",
                      textAlign: TextAlign.center,
                    ),
            );
          } else {
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => detail_saldo(
                      saldo: balance[index - 1]["id"],
                      token: widget.token,
                      baseDir: widget.baseDir,
                    ),
                  ),
                );
              },
              leading: Text(balance[index - 1]["type"]),
              title: balance[index - 1]["type"] == "Expense"
                  ? Text(
                      balance[index - 1]["amount"].toString(),
                      style: TextStyle(color: Colors.red),
                    )
                  : Text(balance[index - 1]["amount"].toString()),
              subtitle: Text(balance[index - 1]["date"]),
              trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    borrar(balance[index -1]["id"]);
                  }),
            );
          }
        },
        itemCount: balance.length == null ? null : balance.length + 1,
      ),
    );
  }

  Future borrar(id) async {
    Alert(
      context: context,
      title: "-- Borrar monto --",
      style: AlertStyle(
          titleStyle: TextStyle(color: Colors.white),
          descStyle: TextStyle(color: Colors.white)),
      desc: "Esta seguro que quiere borrar este monto?",
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
                  .delete("monto/${id}/",
                      options: Options(
                          method: 'PUT',
                          responseType: ResponseType.plain,
                          headers: {"Authorization": "Token ${widget.token}"}))
                  .whenComplete(() {
                Navigator.pop(context);
                getJsonData();
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
        title: Text("Saldo - Ingresos y gastos"),
      ),
      body: balance == null
          ? Center(
              child: SpinKitWave(
                color: Colors.white,
                size: 75.0,
              ),
            )
          : buildPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  add_monto_page(token: widget.token, baseDir: widget.baseDir),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
