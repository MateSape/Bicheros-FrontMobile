import 'package:flutter/material.dart';
import "dart:async";
import 'add_monto_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';

BaseOptions options = new BaseOptions(
  baseUrl: "http:///192.168.100.235:8000/api/",
);

var dio = Dio(options);

class saldo_page extends StatefulWidget {
  @override
  saldo_page_state createState() => new saldo_page_state();
}

class saldo_page_state extends State<saldo_page> {
  var puchito = false;
  var balance;
  var input = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getJsonData();
    puchito = true;
  }

  Future getJsonData() async {
    var response = await dio.get("monto/");

    setState(() {
      balance = response.data;
    });
  }

  Widget buildPage() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          leading: Text(balance[index]["tipo"]),
          title: Text(balance[index]["amount"].toString()),
          trailing: Text(balance[index]["date"]),
        );
      },
      itemCount: balance.length == null ? null : balance.length,
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
