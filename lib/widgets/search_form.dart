import 'package:flutter/material.dart';
import 'package:reddit_pics/widgets/results_page.dart';

class SearchForm extends StatefulWidget {
  SearchForm({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();
  final _textEditorController = TextEditingController();

  @override
  void dispose() {
    _textEditorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _textEditorController,
                  decoration: InputDecoration(
                    hintText: 'Search a subreddit',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  autofocus: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a subreddit';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: RaisedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ResultPage(query: _textEditorController.text),
                            ),
                          );
                        }
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.blueGrey[100],
                        size: 18,
                      ),
                      label: Text(
                        'Search',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      color: Colors.blueGrey[800],
                      textColor: Colors.blueGrey[50],
                      padding: EdgeInsets.only(
                        top: 16.0,
                        bottom: 16.0,
                        right: 34.0,
                        left: 28.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
