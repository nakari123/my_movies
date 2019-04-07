// To parse this JSON data, do
//
//     final video = videoFromJson(jsonString);

import 'dart:convert';

Video videoFromJson(String str) {
  final jsonData = json.decode(str);
  return Video.fromJson(jsonData);
}

String videoToJson(Video data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Video {
  int id;
  List<Result> results;

  Video({
    this.id,
    this.results,
  });

  factory Video.fromJson(Map<String, dynamic> json) => new Video(
    id: json["id"] == null ? null : json["id"],
    results: json["results"] == null ? null : new List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "results": results == null ? null : new List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Result {
  String id;
  String iso6391;
  String iso31661;
  String key;
  String name;
  String site;
  int size;
  String type;

  Result({
    this.id,
    this.iso6391,
    this.iso31661,
    this.key,
    this.name,
    this.site,
    this.size,
    this.type,
  });

  factory Result.fromJson(Map<String, dynamic> json) => new Result(
    id: json["id"] == null ? null : json["id"],
    iso6391: json["iso_639_1"] == null ? null : json["iso_639_1"],
    iso31661: json["iso_3166_1"] == null ? null : json["iso_3166_1"],
    key: json["key"] == null ? null : json["key"],
    name: json["name"] == null ? null : json["name"],
    site: json["site"] == null ? null : json["site"],
    size: json["size"] == null ? null : json["size"],
    type: json["type"] == null ? null : json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "iso_639_1": iso6391 == null ? null : iso6391,
    "iso_3166_1": iso31661 == null ? null : iso31661,
    "key": key == null ? null : key,
    "name": name == null ? null : name,
    "site": site == null ? null : site,
    "size": size == null ? null : size,
    "type": type == null ? null : type,
  };
}
