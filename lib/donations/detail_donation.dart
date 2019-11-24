import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
      amount.text = ica["quantity"].toString();
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
          title: TextField(
            controller: descripcion,
            decoration: InputDecoration(
              hintText: "Descripcion"
            ),
          ),
        ),
        ListTile(
          title: TextField(
            controller: amount,
            decoration: InputDecoration(
              hintText: "Cantidad"
          ),

          ),
        ),
        ListTile(
          title: TextField(
            controller: date,
            decoration: InputDecoration(
                hintText: "Fecha"
            ),
          ),
        ),
        ListTile(
          title: new DropdownButton<String>(
            hint: Text("Seleccione un tipo de donacion"),
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
        ListTile(
            title: MaterialButton(
              onPressed: () {
                borrar();
              },
              color: Colors.red,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            )),
      ],
    );
  }

  Future borrar() async {
    Alert(
      context: context,
      title: "-- Borrar donacion --",
      style: AlertStyle(
          titleStyle: TextStyle(color: Colors.white),
          descStyle: TextStyle(color: Colors.white)),
      desc: "Esta seguro que quiere borrar esta donacion?",
      buttons: <DialogButton>[
        DialogButton(
          child: Text(
            "No, todavia no",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.green,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        DialogButton(
          child: Text(
            "Si, estoy seguro",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.red,
          onPressed: () {
            try{
              dio.delete("donacion/${widget.donation}/",
                  options: Options(
                      method: 'PUT',
                      responseType: ResponseType.plain,
                      headers: {
                        "Authorization": "Token ${widget.token}"
                      })
              ).whenComplete(() {
                Navigator.pop(context);
                Navigator.pop(context);
              });
            }
            catch(e){
              Alert(
                  context: context,
                  title: "Error",
                  desc: "Error, intente nuevamente.")
                  .show();
            }
          },
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    getJsonData();
    puchito = true;
    return Scaffold(
      appBar: AppBar(
        title: Text("Modificar donacion"),
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
                "quantity": int.parse(amount.text)
              },
              options: Options(headers: {
                "Authorization":
                "Token ${widget.token}"
              }))
              .whenComplete(() => Navigator.pop(context));
        },
        child: Icon(
          Icons.save_alt,
        ),
      ),
    );
  }
}
