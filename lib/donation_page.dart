import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bicheros_frontmobile/add_donation.dart';
import 'package:bicheros_frontmobile/detail_donation.dart';

class donationPage extends StatefulWidget {
  final String token;
  final String baseDir;
  donationPage({Key key, this.token, this.baseDir}) : super(key: key);

  @override
  donationPageState createState() => donationPageState();
}

class donationPageState extends State<donationPage> {
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
      baseUrl: widget.baseDir+"/api/",
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
    var response = await dio.get('donacion/?search=${_filter.text}',
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
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Text("${data[index]["id_donation"]}"),
            title: Text(' ${data[index]["type_of_donation"]}'),
            trailing: Text("${data[index]["date"]} "),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      detailDonacion(donation: data[index]["id_donation"], token: widget.token, baseDir: widget.baseDir,),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donaciones"),
      ),
      body: data == null ? Center(
        child: SpinKitWave(
          color: Colors.black,
          size: 75.0,
        ),
      ) : _renderAnimalList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => add_donation_page(token: widget.token, baseDir: widget.baseDir,),
            ),
          );
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
