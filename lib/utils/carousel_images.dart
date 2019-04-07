import 'package:flutter/material.dart';
import 'package:my_movies/API/api.dart';
import 'package:my_movies/utils/carousel_pro.dart';
import 'package:my_movies/data/movie_images.dart';

class CarouselImage extends StatelessWidget {
  final List<Backdrop> images;
  final double heightImage;
  final bool autoPlay;
  CarouselImage({Key key, this.images, this.heightImage, this.autoPlay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        height: heightImage,
        width: size.width,
        child: Stack(
          children: <Widget>[
            Carousel(
              images: images.map((image) {
                return NetworkImage(img500BaseUrl + image.filePath);
              }).toList(),
              boxFit: BoxFit.fitWidth,
              autoplay: autoPlay,
              animationDuration: Duration(milliseconds: 3000),
              dotColor: Colors.white,
              showIndicator: false,
              borderRadius: false,
            ),
            Positioned(
              top: heightImage / 2 - 10,
              right: 5,
              child: Icon(Icons.arrow_forward_ios),
            )
          ],
        ));
  }
}

