class History {
  final int id;
  final String subreddit;
  final String imgUrl;
  String createdAt;

  History({this.id, this.subreddit, this.imgUrl, this.createdAt});

  void updateTimestamp(String dateTime) {
    this.createdAt = dateTime;
  }

  Map<String, dynamic> toMap() {
    return {'subreddit': subreddit, 'img_url': imgUrl, 'created_at': createdAt};
  }
}
