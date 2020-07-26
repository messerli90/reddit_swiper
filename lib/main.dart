import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:photo_view/photo_view.dart';

import 'models/Post.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reddit Images',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SearchPage(title: 'Subreddit Images'),
    );
  }
}

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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

class ResultPage extends StatefulWidget {
  ResultPage({Key key, this.query}) : super(key: key);

  final String query;

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Future<List<Post>> searchSubreddits(String query) async {
    final String url = "https://www.reddit.com/r/" + query + '.json';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Use the compute function to run parsePhotos in a separate isolate.
      // return compute(parsePosts, response.body);
      return parsePosts(response.body);
    } else {
      throw Exception('Failed to fetch subreddit.');
    }
  }

  List<Post> parsePosts(String responseBody) {
    final parsed = json
        .decode(responseBody)['data']['children']
        .cast<Map<String, dynamic>>();

    return parsed
        // .where((json) => json['data']['thumbnail'] != null)
        .where((json) => json['data']['post_hint'] == 'image')
        .map<Post>((json) {
      return Post.fromJson(json);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results for ' + widget.query),
      ),
      body: FutureBuilder<List<Post>>(
        future: searchSubreddits(widget.query),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PostsList(posts: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PostsList extends StatelessWidget {
  final List<Post> posts;

  PostsList({Key key, this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: GestureDetector(
            onTap: () {
              return Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => Container(
                      child: PhotoView(
                        imageProvider: NetworkImage(posts[index].url),
                      ),
                    ),
                  ));
            },
            child: Hero(
              tag: posts[index].id,
              child: Image.network(
                posts[index].thumbnailUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
