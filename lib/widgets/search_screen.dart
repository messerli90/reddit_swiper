import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reddit_pics/widgets/result_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchFieldController;
  List<String> history = [];

  Future<List<String>> _fetchHistory() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList('history');
  }

  void _updateHistory(String value) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> _history = prefs.getStringList('history');
    if (_history == null) {
      await prefs.setStringList('history', [value]);
    } else if (_history.indexOf(value) == -1) {
      _history.add(value);
      await prefs.setStringList('history', _history);
    }
    setState(() {
      history = _history;
    });
  }

  void _removeFromHistory(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> _history = prefs.getStringList('history');
    _history.remove(value);
    await prefs.setStringList('history', _history);
    setState(() {
      history = _history;
    });
  }

  Widget _getHistoryWidgets() {
    return FutureBuilder(
      future: _fetchHistory(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Widget> _buttons = new List<Widget>();
          for (var i = 0; i < snapshot.data.length; i++) {
            _buttons.add(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new FlatButton(
                  color: Colors.red[600],
                  textColor: Colors.white,
                  onPressed: () => print('pressed ${snapshot.data[i]}'),
                  onLongPress: () => _removeFromHistory(snapshot.data[i]),
                  child: Text(snapshot.data[i]),
                ),
              ),
            );
          }
          // snapshot.data
          return Wrap(
            children: _buttons,
          );
        }
        return Text('');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _searchFieldController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _searchFieldSubmitted(String value) async {
    _updateHistory(value);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ResultScreen(value);
        },
      ),
    );
  }

  Widget _searchField() => TextField(
        controller: _searchFieldController,
        onSubmitted: _searchFieldSubmitted,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Subreddit to search',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reddit Swiper'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: () => print('pressed'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: _searchField(),
            ),
            _getHistoryWidgets(),
          ],
        ),
      ),
    );
  }
}
