import 'package:flutter/material.dart';
import 'detalhes.dart';
import 'insere.dart';
import 'ctcdata.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

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
  // criar a lista
  late Future<List<ctcData>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  delete(String id) async {
    // remove aluno da api
    var res = http.delete(
      Uri.parse('https://www.slmm.com.br/CTC/delete.php?id=${id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Listagem"),
          backgroundColor: Color.fromARGB(25, 250, 90, 20),
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
                                    // nome do aluno
                                    Text(data[index].nome),
                                    // botao para apagá-lo da api
                                    IconButton(
                                      onPressed: () {
                                        // passa o id do aluno correspondente para função delete
                                        delete(data[index].id.toString());
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Lista()),
                                        );
                                      },
                                      icon: Icon(Icons.delete_rounded),
                                    ),
                                    // botao para mostrar os detalhes do aluno
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              // passa o id correspondente ao aluno selecionado
                                                  Detalhes(
                                                      value: data[index]
                                                          .id
                                                          .toString())),
                                        );
                                      },
                                      icon: Icon(Icons.edit),
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
        // botao para pagina de inserir aluno
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 207, 3, 218),
          foregroundColor: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Insere()),
            );
          },
          child: Icon(Icons.add),
        ));
  }
}