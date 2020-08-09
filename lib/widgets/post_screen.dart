import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reddit_pics/models/Post.dart';

class PostScreen extends StatelessWidget {
  final List<Post> posts;
  final initialIndex;

  PostScreen(this.posts, [this.initialIndex]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Swiper'),
      ),
      body: Swiper(
        itemCount: posts.length,
        index: initialIndex ?? 0,
        onIndexChanged: (value) {
          CachedNetworkImage(imageUrl: posts[value + 1].url);
        },
        itemBuilder: (BuildContext context, int index) {
          return Hero(
              tag: posts[index].id,
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(posts[index].url),
              ));
        },
      ),
    );
  }
}
