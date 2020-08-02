import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:reddit_pics/models/Post.dart';
import 'package:reddit_pics/repositories/reddit_repository.dart';

class ResultScreen extends StatefulWidget {
  final String subreddit;

  ResultScreen(this.subreddit);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Future<String> futureSearchResponse;
  List<Post> posts;
  String after;
  ScrollController _scrollController;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    futureSearchResponse = searchSubreddits(widget.subreddit).then((value) {
      after = getAfterId(value);
      posts = parsePosts(value);
      return value;
    });
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (loading == false) {
        setState(() {
          loading = true;
        });
        print('fetching more.');
        _fetchMore();
      }
    }
  }

  void _fetchMore() async {
    String newPostsResponse = await searchSubreddits(widget.subreddit, after);
    setState(() {
      posts.addAll(parsePosts(newPostsResponse));
      after = getAfterId(newPostsResponse);
      loading = false;
    });
  }

  Widget _resultsGrid(String data) {
    return GridView.count(
      controller: _scrollController..addListener(_scrollListener),
      padding: const EdgeInsets.all(2),
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      crossAxisCount: 2,
      children: List.generate(
        posts.length,
        (index) => _resultCell(posts[index]),
      ),
    );
  }

  Widget _resultCell(Post post) {
    return Container(
      child: CachedNetworkImage(
        imageUrl: post.thumbnailUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subreddit),
      ),
      body: FutureBuilder<String>(
        future: futureSearchResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _resultsGrid(snapshot.data);
          } else if (snapshot.hasError) {
            return Center(child: Text('Error retrieving images'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}