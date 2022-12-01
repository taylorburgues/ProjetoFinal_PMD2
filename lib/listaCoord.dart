import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'ctcdata.dart';
import 'package:http/http.dart' as http;

import 'detalhes.dart';
import 'insere.dart';


// criar uma lista para puxar os dados da api
Future<List<ctcData>> fetchData() async {
  var response = await http.get(
      Uri.parse("https://www.slmm.com.br/CTC/getLista.php"),
      headers: {"Accept": "application/json"});

  if (response.statusCode == 200) {
    // print(response.body);
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new ctcData.fromJson(data)).toList();
  } else {
    throw Exception('Erro inesperado....');
  }
}

class Lista extends StatefulWidget {
  const Lista({Key? key}) : super(key: key);

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  // criar aqui
  late Future<List<ctcData>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("listagem"),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: FutureBuilder<List<ctcData>>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ctcData> data = snapshot.data!;
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            child: ListTile(
                                title: Text(data[index].id.toString()),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(data[index].nome),
                                    //Text(data[index].data),
                                    Icon(Icons.bolt_rounded),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Detalhes()),
                                        );
                                      },
                                      icon: Icon(Icons.favorite),
                                    )
                                  ],
                                )));
                      });
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // by default
                return CircularProgressIndicator();
              }),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xff03dac6),
          foregroundColor: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Insere()),
            );
            // Respond to button press
          },
          child: Icon(Icons.add),
        ));
  }
}











/*
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'ctcdata.dart';
import 'package:http/http.dart' as http;

Future<List<ctcData>> fetchData() async {
  final response = await http.get(Uri.parse('https://www.slmm.com.br/CTC/getLista.php'),
      );
  print('depois get');
  if (response.statusCode == 200) {
    print(response.body);
    List jsonResponse = json.decode(response.body);
    List<ctcData> ctcList = <ctcData>[];

    return jsonResponse.map((data) => ctcData.fromJson(data)).toList();
  } else {
    throw Exception("Erro inesperado....");
  }
}

class listaCoord extends StatefulWidget {
  const listaCoord({super.key});

  @override
  State<listaCoord> createState() => _listaCoordState();
}

class _listaCoordState extends State<listaCoord> {
  late Future<List<ctcData>> futureData;

  @override
  void initState() {
    print('fetchData');
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Lista')),
        body: Center(
            child: FutureBuilder<List<ctcData>>(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<ctcData> data = snapshot.data!;
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                              child: ListTile(
                                  title: Text(data[index].nome),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.bolt_rounded),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.favorite))
                                    ],
                                  )));
                        });
                  }
                  return Text(snapshot.data.toString());
                })));
  }
}
*/
