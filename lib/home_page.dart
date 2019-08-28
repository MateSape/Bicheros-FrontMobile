import 'package:bicheros_frontmobile/detail_page.dart';
import 'package:bicheros_frontmobile/AddAnimalPage.dart';
import 'saldo_page.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bicheros_frontmobile/login_page.dart';
import 'package:bicheros_frontmobile/cap_page.dart';
import 'package:bicheros_frontmobile/donation_page.dart';
import 'package:bicheros_frontmobile/veterinaria_page.dart';

class HomePage extends StatefulWidget {
  final String token;
  final String baseDir;

  HomePage({Key key, this.token, this.baseDir}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var dio;
  var _filter = new TextEditingController(text: "");
  var sexFilter = "";
  Icon _searchIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget _appBarTitle = new Text("Bichero's App");
  List data;
  List<DropdownMenuItem<String>> sexos = [
    DropdownMenuItem(
      child: Text("Ninguno."),
      value: "",
    ),
    DropdownMenuItem(
      child: Text("Macho"),
      value: "0",
    ),
    DropdownMenuItem(
      child: Text("Hembra"),
      value: "1",
    )
  ];

  @override
  void initState() {
    super.initState();
    BaseOptions options = new BaseOptions(
      baseUrl: widget.baseDir + "/api/",
    );

    dio = Dio(options);
    getJsonData();
  }

  Future getJsonData() async {
    var response = await dio.get('animals/?search=${sexFilter} ${_filter.text}',
        options: Options(headers: {"Authorization": "Token ${widget.token}"}));
    setState(() {
      data = response.data;
    });
  }

  Widget _renderAnimalList() {
    //getJsonData();
    return RefreshIndicator(
      onRefresh: () => getJsonData(),
      child: ListView.builder(
        itemCount: data == null ? 0 : data.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return ListTile(
              title: TextField(
                controller: _filter,
              ),
              trailing: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => getJsonData(),
              ),
              leading: DropdownButton(
                items: sexos,
                value: sexFilter,
                onChanged: (value) {
                  setState(() {
                    sexFilter = value;
                  });
                },
              ),
            );
          }
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: data[index - 1]["photo"] == null
                  ? null
                  : NetworkImage(data[index - 1]["photo"]),
            ),
            title: Text(
              ' ${data[index - 1]["name"]}',
              textAlign: TextAlign.center,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                      animal: data[index - 1]["id_animal"],
                      token: widget.token,
                      baseDir: widget.baseDir),
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
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VeterinariaPage(
                  token: widget.token,
                  baseDir: widget.baseDir,
                ),
              ),
            )
          },
        ),
        ListTile(
          title: Text("Saldo"),
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => saldo_page(
                  token: widget.token,
                  baseDir: widget.baseDir,
                ),
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
                builder: (context) => capPage(
                  token: widget.token,
                  baseDir: widget.baseDir,
                ),
              ),
            )
          },
        ),
        ListTile(
          title: Text("Donaciones"),
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => donationPage(
                  token: widget.token,
                  baseDir: widget.baseDir,
                ),
              ),
            )
          },
        ),
        ListTile(
          title: Center(
            child: MaterialButton(
              onPressed: () => {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => loginPage()))
              },
              child: Text(
                "Log Out",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blueAccent,
            ),
          ),
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
      ),
      drawer: Drawer(child: _renderDrawerItems()),
      body: data == null
          ? Center(
              child: SpinKitWave(
                color: Colors.black,
                size: 75.0,
              ),
            )
          : Container(child: _renderAnimalList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddAnimalPage(token: widget.token, baseDir: widget.baseDir),
            ),
          );
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
