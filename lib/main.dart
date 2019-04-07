import 'package:flutter/material.dart';
import 'package:my_movies/screen/home.dart';
import 'package:my_movies/screen/detail.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();

    // Initialize the Tab Controller
    controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  TabBar getTabBar() {
    return TabBar(
      tabs: <Tab>[
        Tab(
          // set icon to the tab
          icon: Icon(Icons.movie),
        ),
        Tab(
          icon: Icon(Icons.fiber_new),
        ),
        Tab(
          icon: Icon(Icons.insert_chart),
        ),
      ],
      // setup the controller
      controller: controller,
    );
  }

  TabBarView getTabBarView(var tabs) {
    return TabBarView(
      // Add tabs as widgets
      children: tabs,
      // set the controller
      controller: controller,
    );
  }

  @override
  build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies',
      theme: ThemeData(
        textTheme: TextTheme(body1: TextStyle(color: Colors.white)),
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: getTabBar(),
          color: Colors.greenAccent.withOpacity(0.5),
        ),
        body: getTabBarView(<Widget>[
          MyHomeScreen(
            data: fetchHome(1, 'popular'),
            page: 1,
            type: 'popular'
          ),
          MyHomeScreen(
            data: fetchHome(1, 'upcoming'),
            page: 1,
            type: 'upcoming'
          ),
          MyHomeScreen(
            data: fetchHome(1, 'top_rated'),
            page: 1,
            type: 'top_rated'
          ),
        ]),
      )
    );
  }
}
