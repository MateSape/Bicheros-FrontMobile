import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bicheros_frontmobile/donations/add_donation.dart';
import 'package:bicheros_frontmobile/donations/detail_donation.dart';

class donationPage extends StatefulWidget {
  final String token;
  final String baseDir;
  final int type;
  donationPage({Key key, this.token, this.baseDir, this.type})
      : super(key: key);

  @override
  donationPageState createState() => donationPageState();
}

class donationPageState extends State<donationPage> {
  var types = <String> ['comida de gato', 'comida de perro', 'remedios', 'collar', 'otros'];
  var dio;
  List data;
  String title;

  @override
  void initState() {
    BaseOptions options = new BaseOptions(
      baseUrl: widget.baseDir + "/api/",
    );
    dio = Dio(options);
    getJsonData();
    getTitle();
    super.initState();
  }

  Future getJsonData() async {
    var response = await dio.get('donacion/?search=${widget.type}',
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
            leading: Text("${data[index]["cantidad"]}"),
            title: Text(' ${data[index]["description"]}'),
            trailing: Text("${data[index]["date"]} "),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => detailDonacion(
                    donation: data[index]["id_donation"],
                    token: widget.token,
                    baseDir: widget.baseDir,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void getTitle(){
    for (var x=0; x<types.length; x++){
      if (widget.type == x){
        setState(() {
          title =  types[x];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
              builder: (context) => add_donation_page(
                token: widget.token,
                baseDir: widget.baseDir,
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
