import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'random_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.pink[400],
      ),
      home: RandomWords(),
    );
  }
}
