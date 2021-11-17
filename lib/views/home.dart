import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pol10/models/descrip.dart';
import 'package:pol10/views/widgets/pollo_card.dart';

import '../delete.dart';
import '../post.dart';
import '../update.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Descripcion>> _descripciones;

  final String url = 'https://tercerparcialapi.azurewebsites.net/api/Puntos';

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

  @override
  void initState() {
    super.initState();
    _descripciones = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.restaurant_menu_sharp),
            SizedBox(width: 10),
            Text('POL10 APP')
          ],
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: _descripciones,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return PolloCard(descripcion: snapshot.data[index]);
                    });
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Ocurrio un error: ${snapshot.error}'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text('Opciones'),
            ),
            ListTile(
              title: const Text('Ver Restaurantes'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Postear un restaurante'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PostScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Actualizar informacion'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UpdateScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Borrar un restaurante'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DeleteScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
