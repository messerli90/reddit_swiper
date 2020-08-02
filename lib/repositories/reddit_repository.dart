import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:reddit_pics/models/Post.dart';

Future<String> searchSubreddits(String query, [String after]) async {
  String url = "https://www.reddit.com/r/" + query + '.json';

  if (after != null) {
    url = "$url?after=$after";
  }

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to fetch subreddit.');
  }
}

Future<List<Post>> getPosts(String query, [String after]) async {
  String response = await searchSubreddits(query, after);
  return parsePosts(response);
}

List<Post> parsePosts(String responseBody) {
  final parsed = json
      .decode(responseBody)['data']['children']
      .cast<Map<String, dynamic>>();

  return parsed
      // .where((json) => json['data']['thumbnail'] != null)
      .where((json) => json['data']['post_hint'] == 'image')
      .map<Post>((json) {
    return Post.fromJson(json);
  }).toList();
}

String getAfterId(String responseBody) {
  return json.decode(responseBody)['data']['after'];
}
