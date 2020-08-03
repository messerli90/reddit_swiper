import 'package:flutter/material.dart';
import 'package:reddit_pics/widgets/search_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Reddit Images',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Colors.blueGrey[900],
            brightness: Brightness.dark,
          ),
          accentColor: Colors.blueAccent,
          primarySwatch: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SearchScreen(),
      );
}
