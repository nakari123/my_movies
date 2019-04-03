// To parse this JSON data, do
//
//     final view = viewFromJson(jsonString);

import 'dart:convert';

View viewFromJson(String str) {
  final jsonData = json.decode(str);
  return View.fromJson(jsonData);
}

String viewToJson(View data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class View {
  List<Genre> genres;

  View({
    this.genres,
  });

  factory View.fromJson(Map<String, dynamic> json) => new View(
    genres: json["genres"] == null ? null : new List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "genres": genres == null ? null : new List<dynamic>.from(genres.map((x) => x.toJson())),
  };
}

class Genre {
  int id;
  String name;

  Genre({
    this.id,
    this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) => new Genre(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
  };
}
