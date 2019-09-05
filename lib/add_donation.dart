import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class add_donation_page extends StatefulWidget {
  final token;
  final String baseDir;
  add_donation_page({Key key, this.token, this.baseDir}) : super(key: key);
  @override
  add_donation_page_state createState() => new add_donation_page_state();
}

class add_donation_page_state extends State<add_donation_page> {
  var dio;
  var dropdownValue = null;
  var type = <String> ['comida de gato', 'comida de perro', 'remedios', 'collar', 'otros'];
  var Mdate;
  var description = TextEditingController();
  var amount = TextEditingController();

  @override
  void initState() {
    super.initState();

    BaseOptions options = new BaseOptions(
      baseUrl: widget.baseDir+"/api/",
    );
    dio = Dio(options);
  }
  int getItemIndex(){
    for (var x=0; x<type.length; x++){
     if (dropdownValue == type[x]){
       return x;
     }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Añadir nueva donacion"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: TextField(
              controller: description,
            ),
            leading: Text("Descripcion"),
          ),
          ListTile(
            title: TextField(
              controller: amount,
            ),
            leading: Text("Cantidad"),
          ),
          ListTile(
            title: MaterialButton(
                color: Colors.lightBlue,
                onPressed: () async {
                  final newDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));
                  if (newDate != null && newDate != Mdate) {
                    setState(() {
                      Mdate = newDate;
                    });
                  }
                },
                child: Mdate == null
                    ? Text(
                        "Seleccione una fecha",
                        style: TextStyle(color: Colors.white),
                      )
                    : Text(
                        '${Mdate.day.toString()} / ' +
                            '${Mdate.month.toString()} / ${Mdate.year.toString()}',
                        style: TextStyle(color: Colors.white))),
            leading: Text("Fecha"),
          ),
          ListTile(
            title: new DropdownButton<String>(
              hint: Text("Seleccione una opcion"),
              value: dropdownValue,
              items: type.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String value) {
                setState(() {
                  dropdownValue = value;
                });
              },
            ),
            leading: Text("Tipo"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dio
              .post("donacion/",
                  data: {
                    "date": Mdate.year.toString() +
                        "-" +
                        Mdate.month.toString() +
                        "-" +
                        Mdate.day.toString(),
                    "description": amount.text,
                    "type_of_donation": getItemIndex(),
                    'cantidad': int.parse(amount.text)
                  },
                  options: Options(
                      headers: {"Authorization": "Token ${widget.token}"}))
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
