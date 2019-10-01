import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';

BaseOptions options = new BaseOptions(
  baseUrl: "http:///192.168.100.235:8000/api/",
);

var dio = Dio(options);

class detailDonacion extends StatefulWidget {
  final token;
  final donation;
  final String baseDir;

  detailDonacion({Key key, this.donation, this.token, this.baseDir}) : super(key: key);

  @override
  detailDonacionState createState() => detailDonacionState();
}

class detailDonacionState extends State<detailDonacion> {
  var dio;

  var type = <String> ['comida de gato', 'comida de perro', 'remedios', 'collar', 'otros'];
  var puchito = false;
  var descripcion = new TextEditingController();
  var Dtype;
  var amount = new TextEditingController();
  var date = new TextEditingController();

  var ica;

  @override
  void initState() {
    super.initState();

    BaseOptions options = new BaseOptions(
      baseUrl: widget.baseDir+"/api/",
    );
    dio = Dio(options);
  }

  Future getJsonData() async {
    if (puchito == false) {
      var response = await dio.get("donacion/${widget.donation.toString()}/",
          options: Options(headers: {
            "Authorization": "Token ${widget.token}"
          }));

      setState(() {
        ica = response.data;
      });
      print(ica);
      descripcion.text = ica["description"];
      date.text = ica["date"];
      Dtype = ica["type_of_donation"];
      amount.text = ica["cantidad"].toString();
    }
  }

  int getItemIndex(){
    for (var x=0; x<type.length; x++){
      if (Dtype == type[x]){
        return x;
      }
    }
  }

  Widget buildDetail() {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Text("Descripcion"),
          title: TextField(
            controller: descripcion,
          ),
        ),
        ListTile(
          leading: Text("Cantidad"),
          title: TextField(
            controller: amount,
          ),
        ),
        ListTile(
          title: TextField(
            controller: date,
          ),
          leading: Text("Fecha"),
        ),
        ListTile(
          leading: Text("Tipo "),
          title: new DropdownButton<String>(
            hint: Text("Seleccione una opcion"),
            value: Dtype,
            items: type.map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (String value) {
              setState(() {
                Dtype = value;
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    getJsonData();
    puchito = true;
    return Scaffold(
      appBar: AppBar(
        title: Text("Modificar donacion"),
         actions: <Widget>[
           IconButton(
             icon: Icon(Icons.delete),
             onPressed: () {
               dio.delete(
                 "donacion/${widget.donation}/",
                   options: Options(headers: {
                     "Authorization":
                     "Token ${widget.token}"
                   }),
               );
               Navigator.pop(context);
             },
           )
         ],
      ),
      body: ica == null
          ? Center(
        child: SpinKitWave(
          color: Colors.white,
          size: 75.0,
        ),
      )
          : buildDetail(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dio
              .put("donacion/${ica['id_donation']}/",
              data: {
                "date": date.text,
                "description": descripcion.text,
                "type_of_donation": getItemIndex(),
                "cantidad": int.parse(amount.text)
              },
              options: Options(headers: {
                "Authorization":
                "Token ${widget.token}"
              }))
              .whenComplete(() => Navigator.pop(context));
        },
        child: Icon(
          Icons.save_alt,
          color: Colors.white,
        ),
      ),
    );
  }
}
