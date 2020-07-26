import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SearchPage(title: 'Flutter Demo Home Page'),
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _textEditorController,
                  decoration: InputDecoration(hintText: 'Search a subreddit'),
                  autofocus: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a subreddit';
                    }
                    return null;
                  },
                ),
                RaisedButton.icon(
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
                  icon: Icon(Icons.search),
                  label: Text('Search'),
                  color: Colors.blueGrey[800],
                  textColor: Colors.blueGrey[50],
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
        .where((json) => json['data']['thumbnail'] != null)
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
          child: Image.network(
            posts[index].thumbnailUrl,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}

class Post {
  final String thumbnailUrl;
  final String title;

  Post({this.title, this.thumbnailUrl});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['data']['title'] as String,
      thumbnailUrl: json['data']['thumbnail'] as String,
    );
  }
}
