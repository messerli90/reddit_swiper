import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:reddit_pics/widgets/result_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchFieldController;
  List<String> history = [];
  List<Color> colors = [];

  @override
  void initState() {
    super.initState();
    _searchFieldController = TextEditingController();
    colors = _createColors();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Color> _createColors() {
    List<Color> _colors = List<Color>();
    RandomColor _randomColor = RandomColor();
    for (var i = 0; i < 20; i++) {
      _colors.add(_randomColor.randomColor(
          colorSaturation: ColorSaturation.highSaturation));
    }
    return _colors;
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

  Widget _buildHistoryButton(String item, int i) {
    return FlatButton(
      color: colors[i],
      textColor: Colors.white,
      onPressed: () => _searchFieldSubmitted(item),
      onLongPress: () => _removeFromHistory(item),
      child: Text(item),
    );
  }

  Widget _getHistoryWidgets() {
    return FutureBuilder(
      future: _fetchHistory(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.length > 0) {
          List<Widget> _buttons = new List<Widget>();
          for (var i = 0; i < snapshot.data.length; i++) {
            _buttons.add(
              _buildHistoryButton(snapshot.data[i], i),
            );
          }
          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
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

  Widget _historySection() => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'History',
              style: TextStyle(
                color: Colors.teal[900],
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),
            _getHistoryWidgets(),
            SizedBox(height: 12),
            Text(
              'Long press to remove from history',
              style: TextStyle(
                  color: Colors.teal[500],
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
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
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal[200],
              style: BorderStyle.solid,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            gapPadding: 2,
          ),
          labelText: 'Subreddit to search',
          labelStyle: TextStyle(color: Colors.teal[100]),
          prefix: Padding(
            padding: EdgeInsets.only(right: 4),
            child: Text(
              '/r/',
              style: TextStyle(
                color: Colors.teal[200],
              ),
            ),
          ),
          suffixIcon: IconButton(
            onPressed: () => _searchFieldController.clear(),
            icon: Icon(Icons.clear),
          ),
        ),
      );

  Widget _header() => Container(
        child: Row(
          children: [
            Text(
              'Reddit',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0),
            ),
            SizedBox(width: 8),
            Text(
              'Swiper',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 25.0),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.teal[700],
          // padding: EdgeInsets.all(32.0),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: _header(),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: _searchField(),
              ),
              Container(
                margin: EdgeInsets.only(right: 12),
                width: MediaQuery.of(context).size.width - 12,
                decoration: BoxDecoration(
                  color: Colors.teal[100],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(64),
                    bottomRight: Radius.circular(64),
                  ),
                ),
                child: _historySection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
