import 'package:flutter/material.dart';
import 'package:my_movies/API/api.dart';
import 'dart:convert';
import 'package:my_movies/data/video.dart';
import 'package:my_movies/utils/youtube_widget.dart';


Future<List> fetchVideo(int id) async {
  final response = await API.getVideo(id);
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    final jsonResponse = json.decode(response.body);
    return Video.fromJson(jsonResponse).results;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class TrailerWidget extends StatefulWidget {
  Future<List> data;
  final String title;
  TrailerWidget({Key key, this.data, this.title}) : super(key: key);

  @override
  _TrailerWidgetState createState() => _TrailerWidgetState();
}

class _TrailerWidgetState extends State<TrailerWidget> {
  final List<String> playlist = <String>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + ' Trailer'),
      ),
      body: Center(
        child: FutureBuilder(
          future: widget.data,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                for (var video in snapshot.data) {
                  playlist.add(video.key);
                }
                print(playlist);
                return MyTrailerWidget(
                    title: 'Youtube Player Demo', playlist: playlist);
                //return MyVideoTrailer(playlist: playlist);
              } else {
                return Text('Sorry, We will update trailer soon :(');
              }
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
