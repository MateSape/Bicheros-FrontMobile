import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class registerPage extends StatefulWidget {
  var baseDir;
  registerPage({Key key, this.baseDir}) : super(key: key);
  @override
  State<StatefulWidget> createState() =>registerPageState();
}

class registerPageState extends State<registerPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final title =
      Center(child: Text("Registrarse",
      style: TextStyle(fontSize: 25,)),
      );

    final username = TextFormField(
      controller: usernameController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Nombre de usuario',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final email = TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Contraseña',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password2 = TextFormField(
      controller: password2Controller,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Contraseña',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          var formData = new FormData.from({
            "username": usernameController.text,
            "email": emailController.text,
            "password1": passwordController.text,
            "password2": password2Controller.text
          });
          var response = Dio().post(widget.baseDir+"/registration/", data: formData).whenComplete((){Navigator.pop(context);});
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Registrarse', style: TextStyle(color: Colors.white)),
      ),
    );
    final backButton = IconButton(
      onPressed: (){
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(

          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            title,
            SizedBox(height: 48.0),
            username,
            SizedBox(height: 8.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 8.0),
            password2,
            SizedBox(height: 24.0),
            registerButton,
            SizedBox(height: 8.0),
            backButton,
          ],
        ),
      ),
    );
  }
}
