import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reddit_pics/models/History.dart';
import 'package:reddit_pics/models/Post.dart';
import 'package:reddit_pics/repositories/history_repository.dart';
import 'package:reddit_pics/repositories/popular_subreddits.dart';
import 'package:reddit_pics/repositories/reddit_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchFieldController;
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    _searchFieldController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: ListView(
          children: [
            _buildSearch(),
            _buildHistory(),
            _buildPopular(),
          ],
        ),
      ),
    );
  }
}

performSearch(String subreddit) async {
  // perform search
  String responseBody = await searchSubreddits(subreddit);

  // print(responseBody);
  List<Post> posts = parsePosts(responseBody);
  String after = getAfterId(responseBody);

  // Navigate to results page
  // Navigator.of(context).push(route)

  // add to history if there's results
  History newHistory =
      History(subreddit: subreddit, imgUrl: posts[0].thumbnailUrl);

  insertHistory(newHistory);

  // set state?
}

Widget _buildSearch() {
  return Padding(
    padding: EdgeInsets.all(16),
    child: Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Color(0x77000000)),
                  BoxShadow(
                    color: Color(0xFF1A202C),
                    spreadRadius: -3,
                    blurRadius: 4,
                  )
                ]),
            child: TextFormField(
              style: TextStyle(
                color: Color(0xFFCBD5E0),
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(18),
                border: InputBorder.none,
                hintText: 'Search Subreddit',
                hintStyle: TextStyle(color: Color(0xFF4A5568)),
                prefixText: '/r/',
                prefixStyle: TextStyle(color: Color(0xFF718096)),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF4A5568),
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildHistory() {
  return Container(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Expanded(
              child: Text(
                'History',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF7EBEC),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                deleteAll();
                print('pressed');
              },
              child: Text(
                'Clear history',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF718096),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 150,
          child: FutureBuilder(
              future: getHistory(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.length > 0) {
                  return GridView.count(
                    crossAxisCount: 1,
                    mainAxisSpacing: 16,
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                      snapshot.data.length,
                      (i) => _buildHistoryCard(snapshot.data[i]),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SvgPicture.asset(
                          'assets/images/dog_walking.svg',
                          height: 100,
                        ),
                        Text(
                          'History empty',
                          style: TextStyle(
                            color: Color(0xFF718096),
                          ),
                        )
                      ],
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              }),
        )
      ],
    ),
  );
}

Widget _buildHistoryCard(History history) {
  print(history);
  return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(history.imgUrl),
        ),
        borderRadius: BorderRadius.circular(10),
        // color: Colors.blue,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1A202C),
            offset: Offset(0, 0),
            blurRadius: 3,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.center,
            colors: [Colors.black, Colors.transparent],
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              '/r/${history.subreddit}',
              style: TextStyle(color: Color(0xFFEDF2F7)),
            ),
          ),
        ),
      ));
}

Widget _buildPopular() {
  return Container(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Expanded(
              child: Text(
                'Popular Subreddits',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF7EBEC),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 200,
          child: Wrap(
            // crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceEvenly,
            spacing: 8,
            children: _buildPopularButtons(),
          ),
        )
      ],
    ),
  );
}

List<Widget> _buildPopularButtons() {
  return popularSubreddits
      .map(
        (s) => _buildPopularButton(
          text: s['text'],
          bgColor: Color(s['bgColor']),
          textColor: Color(s['textColor']),
          subreddit: s['subreddit'],
        ),
      )
      .toList();
}

Widget _buildPopularButton({text, bgColor, textColor, subreddit}) {
  return RaisedButton(
    elevation: 4,
    textColor: textColor,
    color: bgColor,
    child: Text(text),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    onPressed: () {
      performSearch(subreddit);
    },
  );
}
