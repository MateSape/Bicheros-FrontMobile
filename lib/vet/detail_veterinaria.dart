import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';

class DetailVetPage extends StatefulWidget {
  final String baseDir;
  final vet;
  final String token;

  DetailVetPage({Key key, this.vet, this.token, this.baseDir}) : super(key: key);

  @override
  DetailVetPageState createState() => DetailVetPageState();
}

class DetailVetPageState extends State<DetailVetPage> {
  var dio;

  var puchito = false; //trolling
  FormData formData;
  var name = new TextEditingController();
  var address = new TextEditingController();
  var phone = new TextEditingController();
  var email = new TextEditingController();
  var editMode = false;
  var data;

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
    var response = await dio.get("veterinaria/${widget.vet.toString()}/",
        options: Options(headers: {"Authorization": "Token ${widget.token}"}));

    setState(() {
      data = response.data;
    });
  }

  Widget _renderAnimalDetail() {
    List<Widget> items = [
      Text(
        data["name"],
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text("Direccion: ${data["address"]}"),
      Text("email: ${data["email"]}"),
      Text("Telefono: ${data["phone"]}"),
    ];

    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) => index == 0
          ? ListTile(
        title: items[index],
      )
          : ListTile(title: items[index]),
      separatorBuilder: (context, index) => Divider(),
    );
  }

  Widget _changeScreen() {
    if (puchito == false) {
      puchito = true;
      name.text = data["name"];
      address.text = data["address"];
      email.text = data["email"];
      phone.text = data["phone"];
    }
    return editMode == false ? _renderAnimalDetail() : _renderAnimalEdit();
  }

  Widget _renderAnimalEdit() {
    List<Widget> items = [
      ListTile(
        leading: Text("nombre"),
        title: TextField(
          controller: name,
        ),
      ),
      ListTile(
        leading: Text("Direccion"),
        title: TextField(
          controller: address,
        ),
      ),
      ListTile(
        leading: Text("email"),
        title: TextField(
          controller: email,
        ),
      ),
      ListTile(
        leading: Text("telefono"),
        title: TextField(
          controller: phone,
        ),
      ),
      ListTile(
          title: MaterialButton(
            onPressed: () {
              dio.delete("veterinaria/${widget.vet.toString()}/",
                  options:
                  Options(headers: {"Authorization": "Token ${widget.token}"}));
              Navigator.pop(context);
            },
            color: Colors.red,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          )),
    ];
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) => items[index],
      separatorBuilder: (context, index) => Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Informacion detallada Veterinaria",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                this.editMode = !this.editMode;
              });
            },
            icon: Icon(
              editMode == false ? Icons.mode_edit : Icons.remove_red_eye,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: data == null
          ? Center(
        child: SpinKitWave(
          color: Colors.white,
          size: 75.0,
        ),
      )
          : _changeScreen(),
      floatingActionButton: editMode == false
          ? null
          : FloatingActionButton(
        onPressed: () {
          formData = new FormData.from({
            "name": name.text,
            "address": address.text,
            "phone": phone.text,
            "email": email.text,
          });

          dio
              .put('veterinaria/${widget.vet.toString()}/',
              data: formData,
              options: Options(
                  method: 'PUT',
                  responseType: ResponseType.plain,
                  headers: {
                    "Authorization": "Token ${widget.token}"
                  }))
              .catchError((error) => print(error));
          Navigator.pop(context);
        },
        child: Icon(Icons.save_alt),
      ),
    );
  }
}
