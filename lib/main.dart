import 'package:flutter/material.dart';
import "dart:async";
import 'package:dio/dio.dart';
// import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'DetailPage.dart';
import 'AddAnimalPage.dart';

//172.20.10.X:8000
//192.168.0.X:8000
void main() => runApp(MyApp());

BaseOptions options = new BaseOptions(
  baseUrl: "http://192.168.0.7:8000/api/",

);

var dio = Dio(options);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Bicheros App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List data;

  @override
  void initState() {
    super.initState();
    data = null;
    getJsonData();

  }

  Future getJsonData() async {
    var response = await dio.get("animals/");
    setState(() {
      data = null;
      var convertDataToJson = response.data;
      data = convertDataToJson;
      print ("pepe2");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Bichero's App"),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Animales"),
            ),
            ListTile(
              title: Text("Veterinarias"),
            ),
            ListTile(
              title: Text("Saldo"),
            ),
            ListTile(
              title: Text("Adoptantes"),
            ),
            ListTile(
              title: Text("Donaciones"),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: getJsonData,
        child: Container(
          child: ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, int index) {
              return data == null ? SpinKitWave(
                color: Colors.black,
                size: 75.0,
              ) : ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(data[index]["photo"]),
                ),
                title: Text(data[index]["name"]),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(data[index]["id_animal"])));
                },
              );
              },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddAnimalPage())).then((value) {
                        setState(() {
                          getJsonData();
                          initState();
                        });
          });
        },
        tooltip: 'Add',
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
    );
  }
}