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

  @override
  void initState() {
    super.initState();
    _searchFieldController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

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

  Widget _historyButton(String item) => FlatButton(
        color: Colors.red[600],
        textColor: Colors.white,
        onPressed: () => _searchFieldSubmitted(item),
        onLongPress: () => _removeFromHistory(item),
        child: Text(item),
      );

  Widget _getHistoryWidgets() {
    return FutureBuilder(
      future: _fetchHistory(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.length > 0) {
          List<Widget> _buttons = new List<Widget>();
          for (var i = 0; i < snapshot.data.length; i++) {
            _buttons.add(
              _historyButton(snapshot.data[i]),
            );
          }
          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceAround,
            spacing: 8.0,
            children: _buttons,
          );
        }
        return Text(
          'Nothing in your history.',
          style: Theme.of(context).textTheme.subtitle1,
        );
      },
    );
  }

  Widget _historySection() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'History',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              'Long press to remove from history',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          _getHistoryWidgets(),
        ],
      );

  void _searchFieldSubmitted(String value) async {
    _updateHistory(value);
    _searchFieldController.clear();
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
        autofocus: true,
        controller: _searchFieldController,
        onSubmitted: _searchFieldSubmitted,
        // textInputAction: TextInputAction.go,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Subreddit to search',
          suffixIcon: IconButton(
            onPressed: () => _searchFieldController.clear(),
            icon: Icon(Icons.clear),
          ),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_searchField(), _historySection()],
        ),
      ),
    );
  }
}
