import 'package:flutter/material.dart';
import 'package:reddit_pics/widgets/result_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchFieldController;

  @override
  void initState() {
    super.initState();
    _searchFieldController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _searchFieldSubmitted(String value) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(value),
      ),
    );
  }

  Widget _searchField() => TextField(
        controller: _searchFieldController,
        onSubmitted: _searchFieldSubmitted,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Subreddit',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: _searchField(),
        ),
      ),
    );
  }
}
