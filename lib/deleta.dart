import 'package:flutter/material.dart';
import 'ctcdata.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// criar uma Deleta para puxar os dados da api
Future<List<ctcData>> fetchData() async {
  var response = await http.get(
      Uri.parse("https://www.slmm.com.br/CTC/delete.php?id="+"id"),
      headers: {"Accept": "application/json"});

  if (response.statusCode == 200) {
    // print(response.body);
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new ctcData.fromJson(data)).toList();
  } else {
    throw Exception('Erro inesperado....');
  }
}

class Deleta extends StatefulWidget {
  const Deleta({Key? key}) : super(key: key);

  @override
  State<Deleta> createState() => _DeletaState();
}

class _DeletaState extends State<Deleta> {
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
          title: const Text("Deletagem"),
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
                                      onPressed: () {},
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
        ));
  }
}