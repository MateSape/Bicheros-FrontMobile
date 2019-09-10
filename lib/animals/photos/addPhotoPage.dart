import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class addPhotoPage extends StatefulWidget {
  final token;
  final String baseDir;
  final int anid;
  addPhotoPage({Key key, this.token, this.baseDir, this.anid})
      : super(key: key);
  @override
  addPhotoPageState createState() => new addPhotoPageState();
}

class addPhotoPageState extends State<addPhotoPage> {
  var dio;
  File photo;

  @override
  void initState() {
    super.initState();

    BaseOptions options = new BaseOptions(
      baseUrl: widget.baseDir + "/api/",
    );
    dio = Dio(options);
  }


  Future getImage() async {
    var image2 = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      photo = image2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Añadir nueva foto"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: MaterialButton(
              color: Colors.lightBlue,
              onPressed: () => getImage(),
              child: Icon(
                Icons.image,
                color: Colors.white,
              ),
            ),
          ),
          Image(
            image: photo == null
                ? NetworkImage(
                    "https://webhostingmedia.net/wp-content/uploads/2018/01/http-error-404-not-found.png")
                : FileImage(photo),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          try {
            FormData formData = new FormData.from({
              "photo": UploadFileInfo(photo, photo.path),
              "animal": widget.anid,
            });
            dio
                .post("photo/",
                    data: formData,
                    options: Options(
                        method: 'POST',
                        responseType: ResponseType.plain,
                        headers: {"Authorization": "Token ${widget.token}"}))
                .whenComplete(() => Navigator.pop(context));
          } catch (e) {
            Alert(context: context, title: "Error", desc: "Intente de nuevo")
                .show();
          }
        },
        child: Icon(
          Icons.save_alt,
          color: Colors.white,
        ),
      ),
    );
  }
}
