import 'package:flutter/material.dart';
import 'ctcdata.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// criar uma lista para puxar os dados da api
Future<List<ctcData>> fetchData() async {
  var response = await http.get(
      Uri.parse("https://www.slmm.com.br/CTC/insere.php"),
      headers: {"Accept": "application/json"});

  if (response.statusCode == 200) {
    // print(response.body);
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new ctcData.fromJson(data)).toList();
  } else {
    throw Exception('Erro inesperado....');
  }
}

class Insere extends StatefulWidget {
  const Insere({Key? key}) : super(key: key);

  @override
  State<Insere> createState() => _InsereState();
}

class _InsereState extends State<Insere> {
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
          title: const Text("Inseregem"),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
        children: [
          // o primeiro campo texto tem o foco no inicio
          TextField(
            autofocus: true,
            decoration:
            InputDecoration(border: 
            InputBorder.none,
            icon: Icon(Icons.person),
            hintText: 'Informe o nome'),
          ),
          // o segundo campo texto tem o foco quando o usuário 
          // clica no botão FloatingActionButton.
          TextField(
             decoration:
             InputDecoration(border: 
             InputBorder.none,
             icon: Icon(Icons.mail),
             hintText: 'Informe o email'),
          ),
        ],
      ),
          
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xff03dac6),
          foregroundColor: Colors.black,
          onPressed: () {
            Navigator.pop(
              context
            );
            // Respond to button press
          },
          child: Icon(Icons.add),
        ));
  }
  
}