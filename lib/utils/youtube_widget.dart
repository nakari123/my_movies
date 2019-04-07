import 'package:youtube_player/youtube_player.dart';
import 'package:flutter/material.dart';

class MyTrailerWidget extends StatefulWidget {
  final List<String> playlist;

  MyTrailerWidget({Key key, this.title, this.playlist}) : super(key: key);

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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          YoutubePlayer(
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
                content: Text('Sorry, This video does not currently exist. We will fix as soon as possible :('),
              );
            },
            onVideoEnded: () {
              if(currentPos + 1 < widget.playlist.length) {
                setState(() {
                  currentPos++;
                });
              }
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
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
                getListVideo(widget.playlist)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getListVideo(playlist) {
    return Container(
      //color: Colors.greenAccent.withOpacity(0.6),
        height: 300.0, // Change as per your requirement
        width: 300.0, // Change as per your requirement
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
            ),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: playlist.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentPos = index;
                    });
                  },
                  child: Card(
                    color: currentPos == index ? Colors.greenAccent : Colors.white30,
                    child: Center(
                      child: Text((index + 1).toString()),
                    ),
                  ));
            }));
  }
}