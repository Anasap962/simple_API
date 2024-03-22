import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        // Assuming you are using Material3
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List productsList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse('http://fakestoreapi.com/products');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          productsList = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: productsList.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              itemBuilder: (context, index) {
                final data = productsList[index];
                return ListTile(
                  leading: Image.network(data['image']),
                  title: Text(data['title']),
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: productsList.length,
            ),
    );
  }
}

// http://fakestoreapi.com/products