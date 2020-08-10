import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:reddit_pics/models/History.dart';
import 'package:reddit_pics/models/Post.dart';
import 'package:reddit_pics/repositories/history_repository.dart';
import 'package:reddit_pics/repositories/reddit_repository.dart';
import 'package:reddit_pics/widgets/post_screen.dart';

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
    _scrollController = ScrollController();
    futureSearchResponse = searchSubreddits(widget.subreddit).then((value) {
      after = getAfterId(value);
      posts = parsePosts(value);
      if (posts.length > 0) {
        // add to history if there's results
        History newHistory =
            History(subreddit: widget.subreddit, imgUrl: posts[0].thumbnailUrl);

        insertHistory(newHistory);
      }
      return value;
    });
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

  void _postClicked(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostScreen(posts, posts.indexOf(post)),
      ),
    );
  }

  Widget _resultsGrid(String data) {
    return GridView.count(
      controller: _scrollController..addListener(_scrollListener),
      padding: const EdgeInsets.all(2),
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      crossAxisCount: 3,
      children: List.generate(
        posts.length,
        (index) => _resultCell(posts[index]),
      ),
    );
  }

  Widget _resultCell(Post post) {
    return Container(
      child: Hero(
          tag: post.id,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                print("tapped: ${post.id}");
                _postClicked(post);
              },
              child: CachedNetworkImage(
                imageUrl: post.thumbnailUrl,
                fit: BoxFit.cover,
              ),
            ),
          )),
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
