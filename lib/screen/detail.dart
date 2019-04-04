import 'package:flutter/material.dart';
import 'package:my_movies/API/api.dart';
import 'package:my_movies/data/detail.dart';
import 'package:my_movies/data/movie_images.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:convert';

Future<List> fetchDetail(int id) async {
  final response = await API.getDetail(id);
  final imageRespone = await API.getImage(id);
  if (response.statusCode == 200 && imageRespone.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    final jsonResponse = json.decode(response.body);
    final jsonImageResponse = json.decode(imageRespone.body);
    return [Welcome.fromJson(jsonResponse), ImageMv.fromJson(jsonImageResponse)];
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class DetailScreen extends StatefulWidget {
  final Future<List> data;
  final String title;

  DetailScreen({Key key, this.data, this.title}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
          future: widget.data,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _detailBody(context, snapshot.data[0], snapshot.data[1]);
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

Widget _detailBody(context, data, images) {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: Column(
      children: <Widget>[
        _top(context, data),
        _overView(data),
        _overDetail(data),
        _company(data),
        _poster(images)
      ],
    ),
  );
}
Widget _poster(images) {
  return Container(); //TODO: change
}
Widget _itemCom(data) {
  return Container(
    width: 160,
    decoration: BoxDecoration(color: Colors.white),
    padding: EdgeInsets.all(20),
    margin: EdgeInsets.only(right: 5),
    alignment: Alignment.center,
    child: Column(
      children: <Widget>[
        Expanded(
            child: data.logoPath != null
                ? Image.network(
                    img500BaseUrl + data.logoPath,
                    fit: BoxFit.fitWidth,
                  )
                : Image.asset('images/no-image-large.png',
                    fit: BoxFit.fitWidth)),
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            data.name,
            style: TextStyle(color: Colors.black),
          ),
        )
      ],
    ),
  );
}

Widget _company(data) {
  var isExist = data.productionCompanies.length > 0;
  return isExist
      ? Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 150.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: ((context, index) {
              return _itemCom(data.productionCompanies[index]);
            }),
            itemCount: data.productionCompanies.length,
          ))
      : Container();
}

Widget _overDetail(data) {
  return Container(
    margin: EdgeInsets.only(top: 5),
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(color: Color.fromRGBO(36, 106, 193, 0.8)),
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(child: Text('Status: ' + data.status)),
            Expanded(
                child: Text('Run time: ' + data.runtime.toString() + ' min'))
          ],
        ),
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Text('Budget : ' + data.budget.toString() + ' \$')),
              Expanded(
                  child: Text('Revenue : ' + data.revenue.toString() + ' \$'))
            ],
          ),
        ),
        Container(
            child: Text('Tagline: ' + data.tagline),
            alignment: Alignment.centerLeft),
      ],
    ),
  );
}

Widget _overView(data) {
  return Container(
    margin: EdgeInsets.only(top: 5),
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
          img500and282BaseUrl + data.backdropPath,
          fit: BoxFit.fill,
        ),
        Positioned(
          child: Image.network(
            img166ahd174BaseUrl + data.posterPath,
            fit: BoxFit.fill,
          ),
          top: 140,
          left: 10,
        ),
        Container(
            child: Positioned(
          width: 250,
          child: Text(data.title,
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
                    radius: 80.0,
                    animation: true,
                    animationDuration: 1200,
                    lineWidth: 12.0,
                    percent: data.voteAverage / 10,
                    center: new Text(
                      (data.voteAverage * 10).toString() + "%",
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
