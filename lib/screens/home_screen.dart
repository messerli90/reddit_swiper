import 'package:flutter/material.dart';
import 'package:reddit_pics/colors.dart';
import 'package:reddit_pics/repositories/popular_subreddits.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25,
            ),
            _buildSearch(),
            _buildHistory(),
            _buildPopular(),
          ],
        ),
      ),
    );
  }
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
            Text(
              'Clear history',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF718096),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 150,
          child: GridView.count(
            crossAxisCount: 1,
            mainAxisSpacing: 16,
            scrollDirection: Axis.horizontal,
            children: [
              _buildHistoryCard(),
              _buildHistoryCard(),
              _buildHistoryCard(),
              _buildHistoryCard(),
            ],
          ),
        )
      ],
    ),
  );
}

Widget _buildHistoryCard() {
  return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            'https://images.unsplash.com/photo-1596768526072-10ee5a7b9645?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=900&q=60',
          ),
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
              '/r/cars',
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
        ),
      )
      .toList();
}

Widget _buildPopularButton({text, bgColor, textColor}) {
  return RaisedButton(
    elevation: 4,
    textColor: textColor,
    color: bgColor,
    child: Text(text),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    onPressed: () {},
  );
}
