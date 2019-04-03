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
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height / 2;
    final double itemWidth = size.width / 2;
    final childRatio = itemWidth / itemHeight;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: FutureBuilder(
        future: widget.data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _gridList(snapshot.data, childRatio);
          } else if (snapshot.hasError) {
            return Text('error');
          }
          // By default, show a loading spinner
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget _gridList(data, childRatio) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: childRatio,
      ),
      shrinkWrap: true,
      padding: EdgeInsets.only(left: 5, right: 5, top: 20),
      scrollDirection: Axis.vertical,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _itemView(data[index]);
      },
    );
  }

  Widget _itemView(data) {
    return Card(
      child: GridTile(
          child: Column(
            children: <Widget>[
              Container(
                  height: 40,
                  child: Text(data.title),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(6)),
              Expanded(
                child: Image.network(
                  img500and282BaseUrl + data.posterPath,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          )),
    );
  }
}
