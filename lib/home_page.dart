import 'dart:convert';
import 'package:bicheros_frontmobile/detail_page.dart';
import 'package:bicheros_frontmobile/AddAnimalPage.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

// 192.168.0.X
// 172.20.10.X
BaseOptions options = new BaseOptions(
  baseUrl: "http://172.20.10.3:8000/api/",

);

var dio = Dio(options);

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data;

  @override
  void initState() {
    super.initState();
    getJsonData();
  }

  Future getJsonData() async {
    var response = await dio.get('animals/');
    setState(() {
      data = response.data;
    });
  }

  Widget _renderAnimalList() {
    return ListView.builder(

      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(data[index]["photo"]),
          ),
          title: Text(
              '${data[index]["id_animal"].toString()} - ${data[index]["name"]}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailPage(animal: data[index]["id_animal"]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _renderDrawerItems() {
    List items = [
      "Animales",
      "Veterinarias",
      "Saldo",
      "Adoptantes",
      "Donaciones"
    ];

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bichero's App"),
      ),
      drawer: Drawer(child: _renderDrawerItems()),
      body: RefreshIndicator(
        onRefresh: getJsonData,
        child: Container(child: _renderAnimalList()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddAnimalPage(),
            ),
          );
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
