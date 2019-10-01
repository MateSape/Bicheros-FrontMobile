import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bicheros_frontmobile/vet/add_veterinaria.dart';
import 'package:bicheros_frontmobile/vet/detail_veterinaria.dart';

class VeterinariaPage extends StatefulWidget {
  final String token;
  final String baseDir;

  VeterinariaPage({Key key, this.token, this.baseDir}) : super(key: key);

  @override
  VeterinariaPageState createState() => VeterinariaPageState();
}

class VeterinariaPageState extends State<VeterinariaPage> {
  var dio;
  List data;
  var search = new TextEditingController();

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
    var response = await dio.get('veterinaria/?search=${search.text}',
        options: Options(headers: {"Authorization": "Token ${widget.token}"}));
    setState(() {
      data = response.data;
    });
  }

  Widget _renderAnimalList() {
    return RefreshIndicator(
      onRefresh: () => getJsonData(),
      child: ListView.builder(
        itemCount: data == null ? 0 : data.length+1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0){
            return ListTile(
              title: TextField(
                controller: search,
              ),
              trailing: IconButton(icon: Icon(Icons.search),
              onPressed: () => getJsonData(),),
            );
          }
          else{
            return ListTile(
              title: Text("${data[index-1]["name"]}"),
              trailing: Text(' ${data[index-1]["phone"]}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailVetPage(vet: data[index-1]["id_veterinaria"], token: widget.token, baseDir: widget.baseDir,),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Veterinarias"),
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
              builder: (context) => AddVeterinariaPage(token: widget.token, baseDir: widget.baseDir,),
            ),
          );
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
