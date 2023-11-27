//import 'dart:html';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomeMaterial(),
    );
  }
}


class HomeMaterial extends StatefulWidget {
  const HomeMaterial({super.key});

  @override
  State<HomeMaterial> createState() => _HomeMaterialState();
}

class _HomeMaterialState extends State<HomeMaterial> {
  late Future<Map<String, dynamic>> dadosCotacoes;

  @override
  void initState() {
    super.initState();
    dadosCotacoes = getDadosCotacoes();
  }

  Future<Map<String, dynamic>> getDadosCotacoes() async {
    try {
      final res = await http.get(Uri.parse('http://api.hgbrasil.com/finance/quotations?key=f20f7e9c'));

      if (res.statusCode != HttpStatus.ok) {
        throw 'Erro de conexão';
      }

      final data = jsonDecode(res.body);
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cotações Brasil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
          future: dadosCotacoes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            final data = snapshot.data as Map<String, dynamic>;
            
            
            
            
            if (data['results']['stocks'] == null) {
              return const Center(
                child: Text('Dados de cotações indisponíveis.'),
              );
            }
            

            final bolsasNomes = data['results']['stocks'];
            List<MapEntry<String, dynamic>> bolsasLista = bolsasNomes.entries.toList();
          
            
            
            
            return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              for (var bolsa in bolsasLista)

                MyCard(
                  nomeBolsa: bolsa.key,
                  location: bolsa.value['location'].toString(),
                  variation: bolsa.value['variation'].toString() ,
                ),
            ],
          );
        },
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  final String nomeBolsa;
  final String location;
  final String variation;

  const MyCard({
    super.key,
    required this.nomeBolsa,
    required this.location,
    required this.variation,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.0,
      height: 300.0,
      child: Card(
        elevation: 5.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              nomeBolsa,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Location: $location'),
            Text('Variation: $variation'),
          ],
        ),
      ),
    );
  }
}