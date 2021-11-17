import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UpdateWidget(),
    );
  }
}

class UpdateWidget extends StatefulWidget {
  const UpdateWidget({Key? key}) : super(key: key);

  @override
  _UpdateWidgetState createState() => _UpdateWidgetState();
}

class _UpdateWidgetState extends State<UpdateWidget> {
  bool updated = false;
  final String url = 'https://tercerparcialapi.azurewebsites.net/api/Puntos';

  Future<bool> updatedata(
      String nombre, String ubi, String desc, String num, String foto) async {
    var response = await http.put(Uri.parse(url + '/$nombre'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: jsonEncode({
          "nombre": nombre,
          "ubi": ubi,
          "desc": desc,
          "num": num,
          "fotos": foto
        }));
    var data = response.body;
    print(data);

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  _asyncFunc() async {
    var result = await updatedata(nombreController.text, ubiController.text,
        descController.text, numController.text, fotoController.text);
    setState(() {
      updated = result;
    });
  }

  TextEditingController nombreController = TextEditingController();
  TextEditingController ubiController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController numController = TextEditingController();
  TextEditingController fotoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant_menu_sharp),
              SizedBox(width: 10),
              Text('POL10 APP')
            ],
          )),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          children: [
            TextFormField(
                controller: nombreController,
                decoration: InputDecoration(hintText: "Ingresar nombre:")),
            Container(child: Divider()),
            TextFormField(
                controller: ubiController,
                decoration: InputDecoration(hintText: "Ingresar ubicacion:")),
            Container(child: Divider()),
            TextFormField(
                controller: descController,
                decoration: InputDecoration(hintText: "Ingresar descripcion:")),
            Container(child: Divider()),
            TextFormField(
                controller: numController,
                decoration: InputDecoration(hintText: "Ingresar numero:")),
            Container(child: Divider()),
            TextFormField(
                controller: fotoController,
                decoration: InputDecoration(hintText: "Ingresar foto:")),
            Container(child: Divider()),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                child: Text('Actualizar'),
                onPressed: () {
                  _asyncFunc();
                  if (updated) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                    );
                  } else {
                    // showDialog(
                    //     context: context,
                    //     barrierDismissible: false,
                    //     builder: (BuildContext context) {
                    //       return AlertDialog(
                    //         title: Text('Datos erroneos.'),
                    //         content: SingleChildScrollView(
                    //           child: ListBody(
                    //             children: [Text('Verifica los datos.')],
                    //           ),
                    //         ),
                    //         actions: [
                    //           TextButton(
                    //             child: Text('Aceptar'),
                    //             onPressed: () {
                    //               Navigator.of(context).pop();
                    //             },
                    //           )
                    //         ],
                    //       );
                    //     });
                  }
                }),
          ],
        ),
      ),
    );
  }
}
