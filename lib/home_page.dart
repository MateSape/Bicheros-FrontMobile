import 'dart:convert';
import 'package:bicheros_frontmobile/detail_page.dart';
import 'package:bicheros_frontmobile/AddAnimalPage.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
// capitalinas
BaseOptions options = new BaseOptions(
  // 192.168.0.X
  // 172.20.10.X
  // 192.168.100.XX
  baseUrl: "http://192.168.0.21:8000/api/",

);

var dio = Dio(options);

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _filter = new TextEditingController(text: "");
  Icon _searchIcon = new Icon(Icons.search, color: Colors.white,);
  Widget _appBarTitle = new Text( "Bichero's App");
  List data;

  @override
  void initState() {
    super.initState();
    getJsonData();
  }


  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        _filter.addListener(() {
          getJsonData();
        });
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              hintText: 'Buscar...',
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search Example');
        _filter.clear();
      }
    });
  }

  Future getJsonData() async {

    var response = await dio.get('animals/?search=${_filter.text}');
    setState(() {
      data = response.data;
    });
  }

  Widget _renderAnimalList() {
    //getJsonData();
    return ListView.builder(

      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage:data[index]["photo"] == null ? null : NetworkImage(data[index]["photo"]),
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
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(icon: _searchIcon,color: Colors.white,
          onPressed: _searchPressed,),
        ],
      ),
      drawer: Drawer(child: _renderDrawerItems()),
      body: Container(child: _renderAnimalList()),
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
