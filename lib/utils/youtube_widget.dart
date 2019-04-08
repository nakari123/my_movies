import 'package:youtube_player/youtube_player.dart';
import 'package:flutter/material.dart';

class MyTrailerWidget extends StatefulWidget {
  final List<String> playlist;
  final List<String> info;

  MyTrailerWidget({Key key, this.title, this.playlist, this.info})
      : super(key: key);

  final String title;

  @override
  _MyTrailerWidgetState createState() => _MyTrailerWidgetState();
}

class _MyTrailerWidgetState extends State<MyTrailerWidget> {
  int currentPos;
  VideoPlayerController _videoController;
  bool isMute = false;

  @override
  void initState() {
    currentPos = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 3,
            child: YoutubePlayer(
              context: context,
              source: widget.playlist[currentPos],
              quality: YoutubeQuality.HD,
              aspectRatio: 16 / 9,
              autoPlay: false,
              startFullScreen: false,
              keepScreenOn: true,
              controlsActiveBackgroundOverlay: true,
              controlsTimeOut: Duration(seconds: 4),
              playerMode: YoutubePlayerMode.DEFAULT,
              callbackController: (controller) {
                _videoController = controller;
              },
              showThumbnail: true,
              onError: (error) {
                AlertDialog(
                  content: Text(
                      'Sorry, This video does not currently exist. We will fix as soon as possible :('),
                );
              },
              onVideoEnded: () {
                if (currentPos + 1 < widget.playlist.length) {
                  setState(() {
                    currentPos++;
                  });
                }
              },
            ),
          ),
          _controlWidget(),
          Flexible(flex: 5,child: getListVideo(widget.playlist, widget.info, height)),
        ],
      ),
    );
  }

  Widget getListVideo(playlist, info, height) {
    return Container(
        child: ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              return GestureDetector(child: _listItem(playlist[index], info[index]), onTap: (){
                setState(() {
                  currentPos = index;
                });
              },);
            }));
  }

  Widget _listItem(key, info) {
    return Card(
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 10),
                width: 180,
                child: Image.network(
                  'https://img.youtube.com/vi/' + key + '/0.jpg',
                  fit: BoxFit.fitWidth,
                )),
            Flexible(child: Text(info), fit: FlexFit.loose),
          ],
        ),
      ),
    );
  }

  Widget _controlWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () => _videoController.value.isPlaying
                    ? null
                    : _videoController.play(),
              ),
              IconButton(
                icon: Icon(Icons.pause),
                onPressed: () => _videoController.pause(),
              ),
              IconButton(
                icon: Icon(isMute ? Icons.volume_off : Icons.volume_up),
                onPressed: () {
                  _videoController.setVolume(isMute ? 1 : 0);
                  setState(
                        () {
                      isMute = !isMute;
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
