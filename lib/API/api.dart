import 'dart:async';
import 'package:http/http.dart' as http;
const baseUrl = "https://api.themoviedb.org/3/";
const apiKey = "api_key=ef565edc786b6dab58173bc6d4104e80";
const language = "en-US";
const img500and282BaseUrl = 'https://image.tmdb.org/t/p/w500_and_h282_face';
const img500BaseUrl = 'https://image.tmdb.org/t/p/w500';


class API {
  static Future getHomeList() {
    var url = baseUrl + "movie/top_rated?" + apiKey + '&language=' + language + '&page=1';
    return http.get(url);
  }
  static Future getGenreList() {
    var url = baseUrl + "genre/movie/list?" + apiKey + '&language=' + language;
    return http.get(url);
  }
}
