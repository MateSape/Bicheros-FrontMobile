import 'package:bicheros_frontmobile/donations/detail_donation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'addPhotoPage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class photosPage extends StatefulWidget {
  final String token;
  final String baseDir;
  final int anid;
  photosPage({Key key, this.token, this.baseDir, this.anid}) : super(key: key);

  @override
  photosPageState createState() => photosPageState();
}

class photosPageState extends State<photosPage> {
  var dio;
  var _filter = new TextEditingController(text: "");
  List data;

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
    var response = await dio.get('photo/?search=${widget.anid}',
        options: Options(headers: {"Authorization": "Token ${widget.token}"}));
    setState(() {
      data = response.data;
    });
  }

  Widget _renderAnimalList() {
    //getJsonData();
    return RefreshIndicator(
      onRefresh: () => getJsonData(),
      child: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(8.0),
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 5.0,
        children: data
            .map((data) => GestureDetector(
          onTap: () {
            Alert(context: context, title: "Borrar Foto", desc: "Esta seguro que quiere borrar esta foto?",buttons: <DialogButton>[
              DialogButton(
                child: Text("No, todavia no", style: TextStyle(color: Colors.white),),
                color: Colors.green,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              DialogButton(
                child: Text("Si, estoy seguro", style: TextStyle(color: Colors.white),),
                color: Colors.red,
                onPressed: () {
                  dio.delete(
                    "photo/${data["id_photo"]}/",
                    options:  Options(
                        method: 'POST',
                        responseType: ResponseType.plain,
                        headers: {"Authorization": "Token ${widget.token}"})
                  );
                  getJsonData();
                  Navigator.pop(context);
                },
              ),
            ])
                .show();
          },
              child: Card(
          child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image(image: NetworkImage(data["photo"]),),
                )),
        ),
            ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text("Fotos"),
      ),
      body: data == null
          ? Center(
        child: SpinKitWave(
          color: Colors.white,
          size: 75.0,
        ),
      )
          : _renderAnimalList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => addPhotoPage(
                token: widget.token,
                baseDir: widget.baseDir,
                anid: widget.anid,
              ),
            ),
          );
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
