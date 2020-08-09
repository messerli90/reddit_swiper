class Post {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String url;
  final bool over18;
  final String postHint;

  Post(
      {this.title,
      this.id,
      this.thumbnailUrl,
      this.url,
      this.postHint,
      this.over18});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['data']['id'] as String,
        title: json['data']['title'] as String,
        thumbnailUrl: json['data']['thumbnail'] as String,
        url: json['data']['url'] as String,
        postHint: json['data']['post_hint'] as String,
        over18: json['data']['over_18'] as bool);
  }
}
