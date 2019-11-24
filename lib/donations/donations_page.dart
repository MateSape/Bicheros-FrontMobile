import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bicheros_frontmobile/donations/add_donation.dart';
import 'package:bicheros_frontmobile/donations/donation_page.dart';

class donationsPage extends StatefulWidget {
  final String token;
  final String baseDir;
  donationsPage({Key key, this.token, this.baseDir}) : super(key: key);

  @override
  donationsPageState createState() => donationsPageState();
}

class donationsPageState extends State<donationsPage> {
  var dio;
  int v1 = 0;
  int v2 = 0;
  int v3 = 0;
  int v4 = 0;
  int v5 = 0;
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
    var response = await dio.get('donacion/',
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
        children: makelist(),
      ),
    );
  }

  List<Widget> makelist() {
    v1 = 0;
    v2 = 0;
    v3 = 0;
    v4 = 0;
    v5 = 0;
    for (int x = 0; x < data.length; x++) {
      if (data[x]["type_of_donation"] == "comida de gato") {
        setState(() {
          v1 += data[x]["quantity"];
        });
      } else if (data[x]["type_of_donation"] == "comida de perro") {
        setState(() {
          v2 += data[x]["quantity"];
        });
      } else if (data[x]["type_of_donation"] == "remedios") {
        setState(() {
          v3 += data[x]["quantity"];
        });
      } else if (data[x]["type_of_donation"] == "collar") {
        setState(() {
          v4 += data[x]["quantity"];
        });
      } else if (data[x]["type_of_donation"] == "otros") {
        setState(() {
          v5 += data[x]["quantity"];
        });
      }
    }
    List<Card> pepe = [
      Card(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    donationPage(token: widget.token, baseDir: widget.baseDir, type: 0,),
              ),
            );
          },
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10.0),
              children: <Widget>[
                Text("Comida de gato",
                textAlign: TextAlign.center,),
                Text(
                  v1.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Card(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    donationPage(token: widget.token, baseDir: widget.baseDir, type: 1,),
              ),
            );
          },
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10.0),
              children: <Widget>[
                Text("Comida de perro",
                  textAlign: TextAlign.center,),
                Text(
                  v2.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Card(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    donationPage(token: widget.token, baseDir: widget.baseDir, type: 2,),
              ),
            );
          },
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10.0),
              children: <Widget>[
                Text("Remedios",
                  textAlign: TextAlign.center,),
                Text(
                  v3.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Card(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    donationPage(token: widget.token, baseDir: widget.baseDir, type: 3,),
              ),
            );
          },
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10.0),
              children: <Widget>[
                Text("Collares",
                  textAlign: TextAlign.center,),
                Text(
                  v4.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Card(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    donationPage(token: widget.token, baseDir: widget.baseDir, type: 4,),
              ),
            );
          },
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10.0),
              children: <Widget>[
                Text("Otros",
                  textAlign: TextAlign.center,),
                Text(
                  v5.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
        
      ),
    ];
    return pepe;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text("Donaciones"),
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
