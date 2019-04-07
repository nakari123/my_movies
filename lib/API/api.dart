import 'dart:async';
import 'package:http/http.dart' as http;
const baseUrl = "https://api.themoviedb.org/3/";
const apiKey = "api_key=ef565edc786b6dab58173bc6d4104e80";
const language = "en-US";
const img500and282BaseUrl = 'https://image.tmdb.org/t/p/w500_and_h282_face';
const img500BaseUrl = 'https://image.tmdb.org/t/p/w500';
const img166and174BaseUrl = 'https://image.tmdb.org/t/p/w116_and_h174_face';
const youtubeApiKey = "AIzaSyDTV0o-S1A9PJbMXY9sjqXSfxlnWubl2pQ";
const youtubeUrl = "https://www.youtube.com/watch?v=";


class API {
  static Future getHomeList(page, type) {
    var url = baseUrl + "movie/" + type +"?" + apiKey + '&page=' + page.toString();
    return http.get(url);
  }
  static Future getGenreList() {
    var url = baseUrl + "genre/movie/list?" + apiKey;
    return http.get(url);
  }
  static Future getDetail(id) {
    var url = baseUrl + "movie/" + id.toString() + "?" + apiKey;
    return http.get(url);
  }
  static Future getImage(id) {
    var url = baseUrl + "movie/" + id.toString() + "/images?" + apiKey;
    return http.get(url);
  }
  static Future getVideo(id) {
    var url = baseUrl + "movie/" + id.toString() + "/videos?" + apiKey;
    return http.get(url);
  }
}
