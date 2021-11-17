import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'main.dart';
import 'models/descrip.dart';

class DeleteScreen extends StatelessWidget {
  const DeleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DeleteWidget(),
    );
  }
}

class DeleteWidget extends StatefulWidget {
  const DeleteWidget({Key? key}) : super(key: key);

  @override
  _DeleteWidgetState createState() => _DeleteWidgetState();
}

class _DeleteWidgetState extends State<DeleteWidget> {
  bool deleted = false;
  final String url = 'https://tercerparcialapi.azurewebsites.net/api/Puntos/';

  Future<bool> deletedata(String nombre) async {
    var response = await http.delete(
      Uri.parse(url + nombre),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    var data = response.body;
    print(data);

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Descripcion>> getData() async {
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<Descripcion> descriptions = [];
      for (var model in jsonResponse) {
        Descripcion description = Descripcion.fromJson(model);
        descriptions.add(description);
      }

      return descriptions;
    } else {
      throw Exception('Error al llamar al API');
    }
  }

  _asyncFunc() async {
    var result = await deletedata(nombreController.text);
    setState(() {
      deleted = result;
    });
  }

  late Future<List<Descripcion>> _descripciones;
  TextEditingController nombreController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _descripciones = getData();
  }

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
        ),
      ),
      body: SafeArea(
          child: ListView(
        children: [
          TextFormField(
              controller: nombreController,
              decoration: InputDecoration(hintText: "Ingresar nombre:")),
          Container(child: Divider()),
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Text('DELETE'),
              onPressed: () {
                _asyncFunc();
                if (deleted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                  );
                }
              }),
          FutureBuilder(
              future: _descripciones,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Nombre: ' + snapshot.data[index].nombre),
                          subtitle: Text('Ubi: ' + snapshot.data[index].ubi),
                        );
                      });
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Ocurrio un error: ${snapshot.error}'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ],
      )),
    );
  }
}
