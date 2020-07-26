import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reddit_pics/models/Post.dart';
import 'package:reddit_pics/repositories/reddit_repository.dart';

class PostsList extends StatefulWidget {
  final List<Post> posts;
  final String subreddit;
  final String after;

  PostsList({Key key, this.posts, this.subreddit, this.after})
      : super(key: key);

  @override
  _PostsListState createState() => _PostsListState(posts, after);
}

class _PostsListState extends State<PostsList> {
  bool loading = false;
  List<Post> posts;
  String after;

  _PostsListState(this.posts, this.after);

  ScrollController _scrollController = ScrollController();

  void fetchMore() async {
    print(after);
    print(posts);
    String response = await searchSubreddits(widget.subreddit, after);
    List<Post> newPosts = parsePosts(response);

    setState(() {
      after = getAfterId(response);
      posts.addAll(newPosts);
      loading = false;
    });
    // String response = await searchSubreddits(widget.subreddit, widget.after);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _scrollController
        ..addListener(() {
          var triggerFetchMoreSize =
              0.9 * _scrollController.position.maxScrollExtent;

          if (_scrollController.position.pixels > triggerFetchMoreSize &&
              !loading) {
            setState(() {
              loading = true;
            });
            fetchMore();
            print('fetching more');
          }
        }),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: widget.posts.length,
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
                        imageProvider: NetworkImage(widget.posts[index].url),
                      ),
                    ),
                  ));
            },
            child: Hero(
              tag: widget.posts[index].id,
              child: Image.network(
                widget.posts[index].thumbnailUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
