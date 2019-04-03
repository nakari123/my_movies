import 'package:flutter/material.dart';
import 'package:my_movies/API/api.dart';
import 'package:my_movies/data/home.dart';
import 'dart:convert';

Future<List> fetchHome() async {
  final response = await API.getHomeList();
  var data = List<Result>();
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    final jsonResponse = json.decode(response.body);
    Welcome welcome = Welcome.fromJson(jsonResponse);
    data = welcome.results;
    return data;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class MyHomeScreen extends StatefulWidget {
  final Future<List> data;

  MyHomeScreen({Key key, this.data}) : super(key: key);

  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: FutureBuilder(
        future: widget.data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data[index].title),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('error');
          }
          // By default, show a loading spinner
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
