import 'dart:convert';
import 'package:bicheros_frontmobile/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url = "http://10.0.2.2:8000/api/animals/";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        child: Container(child: _renderAnimalList()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
