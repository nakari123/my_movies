import 'package:flutter/material.dart';
import 'package:my_movies/API/api.dart';
import 'package:my_movies/data/home.dart';
import 'package:my_movies/data/genre.dart';
import 'package:my_movies/screen/detail.dart';
import 'dart:convert';

Future<List> fetchHome(page) async {
  final response = await API.getHomeList(page);
  final response_genre = await API.getGenreList();
  var data = List<Result>();
  if (response.statusCode == 200 && response_genre.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    final jsonResponse = json.decode(response.body);
    final jsonGenreResponse = json.decode(response_genre.body);
    Welcome welcome = Welcome.fromJson(jsonResponse);
    View view = View.fromJson(jsonGenreResponse);
    data = welcome.results;
    return [data, view.genres];
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class MyHomeScreen extends StatefulWidget {
  final Future<List> data;
  final int page;

  MyHomeScreen({Key key, this.data, this.page}) : super(key: key);

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
        title: widget.page == 1
            ? Text('Home')
            : Text('Page ' + widget.page.toString()),
      ),
      body: Center(
        child: FutureBuilder(
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
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomeScreen(
                        data: fetchHome(widget.page + 1),
                        page: widget.page + 1)));
          },
          backgroundColor: Colors.greenAccent.withOpacity(0.8),
          child: Icon(Icons.navigate_next)),
    );
  }

  Widget _listView(data, childRatio) {
    return ListView.builder(
        itemBuilder: (context, index) {
          return _itemView(data[0][index], data[1]);
        },
        itemCount: data[0].length);
  }

  Widget _itemView(data, genre) {
    List<String> genList = List();
    for (var gen in data.genreIds) {
      for (var g in genre) {
        if (g.id == gen) genList.add(g.name);
      }
    }
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(bottom: 15),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Image.network(
                    img500and282BaseUrl + data.backdropPath,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.withOpacity(0.5)
                  ),
                  child: Container(
                    padding: EdgeInsets.only(right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(data.title, style: TextStyle(fontSize: 17)),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(data.releaseDate, style: TextStyle(color: Colors.white30),),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(15),
                child: Image.network(
                  img166ahd174BaseUrl + data.posterPath,
                  fit: BoxFit.fitHeight,
                  filterQuality: FilterQuality.medium,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogWidget(data: data, genList: genList);
            });
      },
    );
  }
}

class DialogWidget extends StatefulWidget {
  final Result data;
  final List<String> genList;

  DialogWidget({Key key, this.data, this.genList}) : super(key: key);

  @override
  _DialogWidgetState createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> opacityAnimation;
  Animation<double> scaleAnimatoin;
  Animation<Offset> positionAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    opacityAnimation = Tween<double>(begin: 0.0, end: 0.4).animate(CurvedAnimation(parent: controller, curve: Curves.easeInCubic));
    positionAnimation = Tween<Offset>(begin: Offset(0,-1), end: Offset.zero).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

    controller.addListener(() {
      setState(() {
      });
    });
    controller.forward();
  }
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: positionAnimation,
      child: AlertDialog(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                controller.addStatusListener((status){
                  if(status == AnimationStatus.dismissed){
                    Navigator.pop(context);
                  }
                });
                controller.reverse();
              })
        ],
        backgroundColor: Colors.greenAccent.withOpacity(0.6),
        title: Text(widget.data.title),
        content: _itemDetail(widget.data, widget.genList),
      ),
    );
  }

  Widget _itemDetail(data, genList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            child: Text(data.overview), padding: EdgeInsets.only(bottom: 10)),
        Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(Icons.dehaze),
              ),
              getTextWidgets(genList)
            ],
          ),
        ),
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
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            height: 50,
            width: 170,
            child: RaisedButton(
              onPressed: () {

                controller.addStatusListener((status){
                  if(status == AnimationStatus.dismissed){
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              data: fetchDetail(data.id),
                              title: data.title,
                            )));
                  }
                });
                controller.reverse();
              },
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
                  Text('View More'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getTextWidgets(List<String> strings) {
    return Wrap(
        children: strings
            .map((item) => Container(
                child: Text(item), padding: EdgeInsets.only(right: 5)))
            .toList());
  }
}
