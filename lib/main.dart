import 'package:flutter/material.dart';
import 'package:my_movies/screen/home.dart';
import 'package:my_movies/screen/detail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies',
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomeScreen(data: fetchHome(1), page: 1,),
        '/detail': (context) => DetailScreen(),
      },
      theme: ThemeData(
        textTheme: TextTheme(body1: TextStyle(color: Colors.white)),brightness: Brightness.dark,
      ),
    );
  }
}
