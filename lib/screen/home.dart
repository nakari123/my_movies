import 'package:flutter/material.dart';
import 'package:my_movies/API/api.dart';
import 'package:my_movies/data/home.dart';
import 'package:my_movies/data/genre.dart';
import 'dart:convert';

Future<List> fetchHome() async {
  final response = await API.getHomeList();
  final response_genre = await API.getGenreList();
  var data = List<Result>();
  var genre = List<Genre>();
  if (response.statusCode == 200 && response_genre.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    final jsonResponse = json.decode(response.body);
    final jsonGenreResponse = json.decode(response_genre.body);
    Welcome welcome = Welcome.fromJson(jsonResponse);
    View view = View.fromJson(jsonGenreResponse);
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
            return _listView(snapshot.data, childRatio);
          } else if (snapshot.hasError) {
            return Text('error');
          }
          // By default, show a loading spinner
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget _listView(data, childRatio) {
    return ListView.builder(
        itemBuilder: (context, index) {
          return _itemView(data[index]);
        },
        itemCount: data.length);
  }

  Widget _itemView(data) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(bottom: 5),
        child: Stack(
          children: <Widget>[
            Container(
              child: Image.network(
                img500and282BaseUrl + data.backdropPath,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              bottom: 40,
              left: 10,
              child: Text(data.title,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
            ),
            Positioned(
              bottom: 20,
              left: 10,
              child: Text(data.releaseDate,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
            ),
          ],
        ),
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
                backgroundColor: Colors.greenAccent.withOpacity(0.6),
                title: Text(data.title),
                content: _itemDetail(data),
              );
            });
      },
    );
  }

  Widget _itemDetail(data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            child: Text(data.overview), padding: EdgeInsets.only(bottom: 10)),
        Container(
          padding: EdgeInsets.only(bottom: 15),
          child: Row(
            children: <Widget>[
              Icon(Icons.calendar_today),
              Container(
                  child: Text(data.releaseDate),
                  padding: EdgeInsets.only(left: 10))
            ],
          ),
        ),
        Container(
          child: Container(
            height: 50,
            width: 170,
            child: RaisedButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: Colors.black.withOpacity(0.8),
              textColor: Colors.white,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Icon(Icons.movie_creation, color: Colors.white),
                  ),
                  Text('Watch Trailer'),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
