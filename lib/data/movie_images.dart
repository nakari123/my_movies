// To parse this JSON data, do
//
//     final imageMv = imageMvFromJson(jsonString);

import 'dart:convert';

ImageMv imageMvFromJson(String str) {
  final jsonData = json.decode(str);
  return ImageMv.fromJson(jsonData);
}

String imageMvToJson(ImageMv data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class ImageMv {
  int id;
  List<Backdrop> backdrops;
  List<Backdrop> posters;

  ImageMv({
    this.id,
    this.backdrops,
    this.posters,
  });

  factory ImageMv.fromJson(Map<String, dynamic> json) => new ImageMv(
    id: json["id"],
    backdrops: new List<Backdrop>.from(json["backdrops"].map((x) => Backdrop.fromJson(x))),
    posters: new List<Backdrop>.from(json["posters"].map((x) => Backdrop.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "backdrops": new List<dynamic>.from(backdrops.map((x) => x.toJson())),
    "posters": new List<dynamic>.from(posters.map((x) => x.toJson())),
  };
}

class Backdrop {
  double aspectRatio;
  String filePath;
  int height;
  String iso6391;
  double voteAverage;
  int voteCount;
  int width;

  Backdrop({
    this.aspectRatio,
    this.filePath,
    this.height,
    this.iso6391,
    this.voteAverage,
    this.voteCount,
    this.width,
  });

  factory Backdrop.fromJson(Map<String, dynamic> json) => new Backdrop(
    aspectRatio: json["aspect_ratio"].toDouble(),
    filePath: json["file_path"],
    height: json["height"],
    iso6391: json["iso_639_1"] == null ? null : json["iso_639_1"],
    voteAverage: json["vote_average"].toDouble(),
    voteCount: json["vote_count"],
    width: json["width"],
  );

  Map<String, dynamic> toJson() => {
    "aspect_ratio": aspectRatio,
    "file_path": filePath,
    "height": height,
    "iso_639_1": iso6391 == null ? null : iso6391,
    "vote_average": voteAverage,
    "vote_count": voteCount,
    "width": width,
  };
}
