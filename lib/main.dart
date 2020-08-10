import 'package:flutter/material.dart';
import 'package:reddit_pics/screens/home_screen.dart';
import 'package:reddit_pics/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Reddit Images',
        theme: darkTheme,
        home: HomeScreen(),
      );
}
