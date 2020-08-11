import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reddit_pics/models/History.dart';
import 'package:reddit_pics/models/Post.dart';
import 'package:reddit_pics/repositories/history_repository.dart';
import 'package:reddit_pics/repositories/reddit_repository.dart';
import 'package:reddit_pics/screens/gallery_screen.dart';

class SubredditScreen extends StatefulWidget {
  final String subreddit;

  SubredditScreen({Key key, this.subreddit}) : super(key: key);

  @override
  _SubredditScreenState createState() => _SubredditScreenState();
}

class _SubredditScreenState extends State<SubredditScreen> {
  String after = '';
  List<Post> posts;
  Future<List<Post>> postsFuture;

  @override
  void initState() {
    print('initing ${widget.subreddit}');
    postsFuture = _fetchPosts();
    super.initState();
  }

  void _postClicked(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            GalleryScreen(posts: posts, initialIndex: posts.indexOf(post)),
      ),
    );
  }

  Future<List<Post>> _fetchPosts() async {
    String responseBody = await searchSubreddits(widget.subreddit);

    setState(() {
      after = getAfterId(responseBody);
      posts = parsePosts(responseBody);
    });

    insertHistory(new History(
      subreddit: widget.subreddit,
      imgUrl: posts[0].thumbnailUrl,
    ));

    return posts;
  }

  Widget _buildThumbnail(Post post) {
    return GestureDetector(
      onTap: () => _postClicked(post),
      child: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(post.thumbnailUrl)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildGallery(snapshot) {
    List<Post> _posts = snapshot.data;
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 2 / 2,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      padding: EdgeInsets.all(4),
      children: List.generate(
        _posts.length,
        (i) => _buildThumbnail(
          _posts[i],
        ),
      ),
    );
  }

  Widget _buildLoader() => Center(
        child: Container(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SvgPicture.asset(
                'assets/images/imagination.svg',
                height: 100,
              ),
              Text(
                'Grabbing pictures',
                style: TextStyle(
                  color: Color(0xFF718096),
                ),
              ),
              CircularProgressIndicator()
            ],
          ),
        ),
      );

  Widget _buildResults() {
    return FutureBuilder(
      future: postsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildGallery(snapshot);
        }
        return _buildLoader();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("/r/${widget.subreddit}"),
          backgroundColor: Theme.of(context).backgroundColor),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: _buildResults(),
      ),
    );
  }
}
