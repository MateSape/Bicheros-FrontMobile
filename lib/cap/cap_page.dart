import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bicheros_frontmobile/cap/add_cap_page.dart';
import 'package:bicheros_frontmobile/cap/detail_cap.dart';

class capPage extends StatefulWidget {
  final String token;
  final String baseDir;

  capPage({Key key, this.token, this.baseDir}) : super(key: key);

  @override
  _capPageState createState() => _capPageState();
}

class _capPageState extends State<capPage> {
  var dio;
  var _filter = new TextEditingController();
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

  Future getJsonData() async {
    var response = await dio.get('cap/?search=${_filter.text}',
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
        itemCount: data == null ? 0 : data.length+1,
        itemBuilder: (BuildContext context, int index) {
          if( index == 0){
            return ListTile(
              title: TextField(
                controller: _filter,
              ),
              trailing: IconButton(icon: Icon(Icons.search),
                onPressed: () => getJsonData(),),
            );
          }
          return ListTile(
            leading: Text("${data[index-1]["id_cap"]}"),
            title: Text(' ${data[index-1]["nameC"]} ${data[index-1]["last_nameC"]}',),
            trailing: Text("${data[index-1]["telefono"]} "),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailCapPage(cap: data[index-1]["id_cap"], token: widget.token, baseDir: widget.baseDir,),
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
        title: Text("Adoptantes"),
      ),
      body: data == null ? Center(
        child: SpinKitWave(
          color: Colors.white,
          size: 75.0,
        ),
      ) : _renderAnimalList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCapPage(token: widget.token, baseDir: widget.baseDir,),
            ),
          );
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
