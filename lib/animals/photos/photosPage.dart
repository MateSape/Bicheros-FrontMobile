import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bicheros_frontmobile/donations/add_donation.dart';
import 'package:bicheros_frontmobile/donations/donation_page.dart';

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
            .map((data) => Card(
          child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image(image: NetworkImage(data["photo"]),),
              )),
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
          color: Colors.black,
          size: 75.0,
        ),
      )
          : _renderAnimalList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => add_donation_page(
                token: widget.token,
                baseDir: widget.baseDir,
              ),
            ),
          );*/
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
