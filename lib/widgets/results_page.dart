import 'package:flutter/material.dart';
import 'package:reddit_pics/repositories/reddit_repository.dart';
import 'package:reddit_pics/widgets/post_list.dart';

class ResultPage extends StatefulWidget {
  final String query;

  ResultPage({Key key, this.query}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results for ' + widget.query),
      ),
      body: FutureBuilder<String>(
        future: searchSubreddits(widget.query),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PostsList(
                  posts: parsePosts(snapshot.data),
                  subreddit: widget.query,
                  after: getAfterId(snapshot.data),
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
