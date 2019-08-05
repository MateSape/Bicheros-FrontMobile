import 'package:flutter/material.dart';
import "dart:async";
import 'add_monto_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';

import 'detail_saldo.dart';

class saldo_page extends StatefulWidget {
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
      // 192.168.0.X
      // 172.20.10.X
      // 192.168.100.235
      baseUrl: "http://192.168.100.231:8080/api/",
    );
    dio = Dio(options);
    getJsonData();
  }

  Future getJsonData() async {
    var response = await dio.get("monto/");
    setState(() {
      balance = response.data;
      saldo = 0;
      for(var x = 0; x < balance.length; x++){
        if (balance[x]["tipo"] == "Ingreso"){
          saldo += balance[x]["amount"];
        }
        else{
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
              title: saldo < 0 ? Text("Saldo: ${saldo.toString()}", textAlign: TextAlign.center, style: TextStyle(color: Colors.red),) : Text("Saldo: ${saldo.toString()}", textAlign: TextAlign.center,),
            );
          }else{
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      detail_saldo(saldo: balance[index-1]["id"]),
                ),
              );
            },
            leading: Text(balance[index-1]["tipo"]),
            title: balance[index-1]["tipo"] == "Gasto" ? Text(balance[index-1]["amount"].toString(), style: TextStyle(color: Colors.red),) : Text(balance[index-1]["amount"].toString()),
            subtitle: Text(balance[index-1]["date"]),
            trailing: IconButton(icon: Icon(Icons.delete, color: Colors.redAccent,), onPressed: (){
              dio.delete("monto/${balance[index-1]["id"]}/",);
              getJsonData();
            }),
          );}
        },
        itemCount: balance.length == null ? null : balance.length+1,
      ),
    );
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
                color: Colors.black,
                size: 75.0,
              ),
            )
          : buildPage(),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => add_monto_page(),
          ),
        );
      },
      child: Icon(Icons.add, color: Colors.white,),),
    );
  }
}
