import 'dart:convert';
import 'package:bicheros_frontmobile/detail_page.dart';
import 'package:bicheros_frontmobile/AddAnimalPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url = "http://192.168.0.11:8000/api/animals/";
  List data;

  @override
  void initState() {
    super.initState();
    getJsonData();
  }

  Future getJsonData() async {
    var response = await http.get(Uri.encodeFull(url));

    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      data = convertDataToJson;
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
