import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RSSDemo extends StatefulWidget {
  RSSDemo() : super();

  static const String id = '/';
  final String title = 'RSS Demo';
 
  @override
  RSSDemoState createState() => RSSDemoState();
}
 
class RSSDemoState extends State<RSSDemo> {
  //
  static const String FEED_URL =
      // 'https://www.nasa.gov/rss/dyn/lg_image_of_the_day.rss';
      'https://medium.com/feed/@itsencrypted';
  RssFeed _feed;
  String _title;
  var index = 0;
  static const String loadingFeedMsg = 'Loading Feed...';
  static const String feedLoadErrorMsg = 'Error Loading Feed.';
  static const String feedOpenErrorMsg = 'Error Opening Feed.';
  static const String placeholderImg = 'images/no_image.png';
  GlobalKey<RefreshIndicatorState> _refreshKey;
 
  updateTitle(title) {
    setState(() {
       _title = title;  
    });
  }
 
  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }
 
  Future<void> openFeed(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: false,
      );
      return;
    }
    updateTitle(feedOpenErrorMsg);
  }
 
  load() async {
    updateTitle(loadingFeedMsg);
    loadFeed().then((result) {
      if (null == result || result.toString().isEmpty) {
        updateTitle(feedLoadErrorMsg);
        return;
      }
      updateFeed(result);
      updateTitle(_feed.title);
    });
  }
 
  Future<RssFeed> loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(FEED_URL);
      return RssFeed.parse(response.body);
    } catch (e) {
      //
    }
    return null;
  }
 
  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    updateTitle(widget.title);
    load();
  }
 
  title(title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  pubdate(pubDate) {
    return Text(
      pubDate.toString(),
      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w200),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
 

 
  thumbnail(imageUrl) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: CachedNetworkImage(
        placeholder: (context, url) => Image.asset(placeholderImg),
        imageUrl: imageUrl,
        height: 50,
        width: 70,
        alignment: Alignment.center,
        fit: BoxFit.fill,
      ),
    );
  }
 
  rightIcon() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: Colors.grey,
      size: 30.0,
    );
  }


  // if (_feed.items[index].categories.length > 0) { list(){} } else { return
  // null };

  list() {
    final postList = _feed.items[index];

    if (_feed.items[index].categories.length > 0) {
      return ListView.builder(
        itemCount: _feed.items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _feed.items[index];
          // final item = postList.items[index];
          // final postList = _feed.items.take(item => item.categories.length > 0);
          return ListTile(
            title: title(item.title),
            subtitle: pubdate(item.pubDate),
            // leading: thumbnail(item.enclosure.url),
            trailing: rightIcon(),
            contentPadding: EdgeInsets.all(5.0),
            onTap: () => openFeed(item.link),
          );
        },
      );
    } //final do meu if correto
    else {
      return null;
    }
  }
 
  isFeedEmpty() {
    return null == _feed || null == _feed.items;
  }
 
  body() {
    return isFeedEmpty()
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            key: _refreshKey,
            child: list(),
            onRefresh: () => load(),
          );
  }
 
  @override
  Widget build(BuildContext context) {
    print(_feed.items.length);
    print(_feed.items[3].categories.length);
    print(_feed.items[3].title);
    print(_feed.items[3].content.value);
      return Scaffold(appBar: AppBar(
        title: Text(_title),
      ),
      body: body(),);
  }
}
