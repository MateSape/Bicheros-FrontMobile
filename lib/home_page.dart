import 'package:bicheros_frontmobile/detail_page.dart';
import 'package:bicheros_frontmobile/AddAnimalPage.dart';
import 'saldo_page.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bicheros_frontmobile/login_page.dart';
import 'package:bicheros_frontmobile/cap_page.dart';
class HomePage extends StatefulWidget {
  final String token;

  HomePage({Key key, this.token}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var dio;
  var _filter = new TextEditingController(text: "");
  Icon _searchIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget _appBarTitle = new Text("Bichero's App");
  List data;

  @override
  void initState() {
    super.initState();
    BaseOptions options = new BaseOptions(
      // 192.168.0.X
      // 172.20.10.X
      // 192.168.100.235
      baseUrl: "http://192.168.100.231:8080/api/",
    );

    dio = Dio(options);
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
        this._appBarTitle = new Text("Bichero's App");
        _filter.clear();
      }
    });
  }

  Future getJsonData() async {
    var response = await dio.get('animals/?search=${_filter.text}', options: Options(
      headers: {
        "Authorization": "Token ${widget.token}"
      }
    ));
    setState(() {
      data = response.data;
    });
  }

  Widget _renderAnimalList() {
    //getJsonData();
    return RefreshIndicator(
      onRefresh: () => getJsonData(),
      child: ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: data[index]["photo"] == null
                  ? null
                  : NetworkImage(data[index]["photo"]),
            ),
            title: Text(
                ' ${data[index]["name"]}',
            textAlign: TextAlign.center,),
            //trailing: Text(" ${data[index]["race"]}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailPage(animal: data[index]["id_animal"], token: widget.token,),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _renderDrawerItems() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Veterinarias"),
          /*onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => saldo_page(),
                  ),
                )
              },*/
        ),
        ListTile(
          title: Text("Saldo"),
          onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => saldo_page(token: widget.token,),
                  ),
                )
              },
        ),
        ListTile(
          title: Text("Adoptantes"),
          onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => capPage(token: widget.token,),
                  ),
                )
              },
        ),
        ListTile(
          title: Text("Donaciones"),
          /*onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => saldo_page(),
                  ),
                )
              },*/
        ),
        ListTile(
          title: Center(child: MaterialButton(onPressed: null, child: Text("Log Out", style: TextStyle(color: Colors.white),), color: Colors.blueAccent,),),
          onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => loginPage()))
              },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            color: Colors.white,
            onPressed: _searchPressed,
          ),
        ],
      ),
      drawer: Drawer(child: _renderDrawerItems()),
      body: data == null ? Center(
        child: SpinKitWave(
          color: Colors.black,
          size: 75.0,
        ),
      ) : Container(child: _renderAnimalList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAnimalPage(token: widget.token,),
            ),
          );
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
