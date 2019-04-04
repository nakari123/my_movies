import 'package:flutter/material.dart';
import 'package:my_movies/API/api.dart';
import 'package:my_movies/data/detail.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:convert';

Future<Welcome> fetchDetail(int id) async {
  final response = await API.getDetail(id);
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    final jsonResponse = json.decode(response.body);
    return Welcome.fromJson(jsonResponse);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class DetailScreen extends StatefulWidget {
  final Future<Welcome> data;

  DetailScreen({Key key, this.data}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: Center(
        child: FutureBuilder(
          future: widget.data,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _detailBody(context, snapshot.data);
            } else if (snapshot.hasError) {
              return Text('error');
            }
            // By default, show a loading spinner
            return CircularProgressIndicator();
          },
        ),
      ),
      //body: _detailBody(context)
    );
  }
}

Widget _detailBody(context, data) {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: Column(
      children: <Widget>[
        _top(context, data),
        _overView(data),
        _company(data),
      ],
    ),
  );
}

Widget _company(data) {
  return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 150.0,
      child: new ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            width: 150,
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(right: 5),
            child: Column(
              children: <Widget>[
                Expanded(
                    child: Image.network(
                  'https://image.tmdb.org/t/p/w500/kP7t6RwGz2AvvTkvnI1uteEwHet.png',
                  fit: BoxFit.fitWidth,
                )),
                Text(
                  'DreamWork',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ],
      ));
}

Widget _overView(data) {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(color: Color.fromRGBO(36, 106, 193, 0.8)),
    child: Column(
      children: <Widget>[Text(data.overview)],
    ),
  );
}

Widget _top(context, data) {
  return Container(
    height: 430,
    decoration: BoxDecoration(color: Color.fromRGBO(16, 44, 78, 1)),
    child: Stack(
      children: <Widget>[
        Image.network(
          img500and282BaseUrl + '/h3KN24PrOheHVYs9ypuOIdFBEpX.jpg',
          fit: BoxFit.fill,
        ),
        Positioned(
          child: Image.network(
            'https://image.tmdb.org/t/p/w116_and_h174_face/xvx4Yhf0DVH8G4LzNISpMfFBDy2.jpg',
            fit: BoxFit.fill,
          ),
          top: 140,
          left: 10,
        ),
        Container(
            child: Positioned(
          width: 250,
          child: Text('How to Train Your Dragon: The Hidden World (2019)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          right: 20,
          bottom: 130,
        )),
        Positioned(
          bottom: 20,
          left: MediaQuery.of(context).size.width / 10,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  child: Row(
                children: <Widget>[
                  CircularPercentIndicator(
                    radius: 70.0,
                    animation: true,
                    animationDuration: 1200,
                    lineWidth: 12.0,
                    percent: 0.4,
                    center: new Text(
                      "40%",
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    circularStrokeCap: CircularStrokeCap.butt,
                    backgroundColor: Colors.greenAccent,
                    progressColor: Colors.green,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text('User Score'),
                  )
                ],
              )),
              Expanded(
                  child: Row(
                children: <Widget>[
                  Icon(Icons.play_arrow),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text('Play Trailer'),
                  )
                ],
              ))
            ],
          ),
        ),
      ],
    ),
  );
}
