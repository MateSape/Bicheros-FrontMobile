import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bicheros_frontmobile/add_veterinaria.dart';
import 'package:bicheros_frontmobile/detail_veterinaria.dart';

class VeterinariaPage extends StatefulWidget {
  final String token;

  VeterinariaPage({Key key, this.token}) : super(key: key);

  @override
  VeterinariaPageState createState() => VeterinariaPageState();
}

class VeterinariaPageState extends State<VeterinariaPage> {
  var dio;
  List data;

  @override
  void initState() {
    super.initState();
    BaseOptions options = new BaseOptions(
      // 192.168.0.X
      // 172.20.10.X
      // 192.168.100.235
      baseUrl: "http://192.168.100.113:8080/api/",
    );

    dio = Dio(options);
    getJsonData();
  }

  Future getJsonData() async {
    var response = await dio.get('veterinaria/',
        options: Options(headers: {"Authorization": "Token ${widget.token}"}));
    setState(() {
      data = response.data;
    });
  }

  Widget _renderAnimalList() {
    return RefreshIndicator(
      onRefresh: () => getJsonData(),
      child: ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text("${data[index]["name"]}"),
            trailing: Text(' ${data[index]["phone"]}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailVetPage(vet: data[index]["id_veterinaria"], token: widget.token,),
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
        title: Text("Veterinarias"),
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
              builder: (context) => AddVeterinariaPage(token: widget.token,),
            ),
          );
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
