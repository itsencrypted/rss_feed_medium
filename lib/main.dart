import 'package:flutter/material.dart';
import 'package:rss_feed_medium/screens/rssdemo.dart';

void main() {
  runApp(MyApp());
}
 

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => RSSDemo(),

      
      },
    );
  }
}
