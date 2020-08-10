class History {
  final int id;
  final String subreddit;
  final String imgUrl;

  History({this.id, this.subreddit, this.imgUrl});

  Map<String, dynamic> toMap() {
    return {'subreddit': subreddit, 'img_url': imgUrl};
  }
}
