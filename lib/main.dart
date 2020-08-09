import 'package:flutter/material.dart';
import 'package:reddit_pics/screens/home_screen.dart';

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
          primarySwatch: Colors.teal,
          accentColor: Colors.tealAccent,
          appBarTheme: AppBarTheme(
            color: Colors.teal,
            brightness: Brightness.light,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: SearchScreen(),
        home: HomeScreen(),
      );
}
