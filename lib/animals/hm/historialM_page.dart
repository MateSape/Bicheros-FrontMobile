import 'package:flutter/material.dart';
import 'package:bicheros_frontmobile/animals/hm/detail_historialM.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'add_historialM.dart';
// import 'package:flutter_share_me/flutter_share_me.dart';

class historialMPage extends StatefulWidget {
  final String token;
  final String baseDir;
  final int anid;

  historialMPage({Key key, this.token, this.baseDir, this.anid}) : super(key: key);

  @override
  historialMPageState createState() => historialMPageState();
}

class historialMPageState extends State<historialMPage> {
  var dio;
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
    var response = await dio.get('historial/?search=${widget.anid}',
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
              title: Text("${data[index]["enfermedad"]}"),
              trailing: Text(' ${data[index]["fecha"]}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        detail_historialM_page(hid: data[index]["id_HM"], token: widget.token, baseDir: widget.baseDir,),
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
        title: Text("Historial Medico"),
        actions: <Widget>[
          /*IconButton(
            icon: Icon(Icons.share),
              onPressed: () async {
              var response = await FlutterShareMe().shareToWhatsApp(
                msg: 'hola bb'
              );
              },
          ),*/
        ],
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
              builder: (context) => add_historialM_page(token: widget.token, baseDir: widget.baseDir, anid: widget.anid,),
            ),
          );
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}