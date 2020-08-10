import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reddit_pics/models/Post.dart';

class GalleryScreen extends StatelessWidget {
  final int initialIndex;
  final List<Post> posts;
  const GalleryScreen({Key key, this.initialIndex, this.posts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: new Swiper(
        itemCount: posts.length,
        index: initialIndex,
        itemBuilder: (context, index) {
          return Container(
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(posts[index].url),
            ),
          );
        },
      ),
    );
  }
}
