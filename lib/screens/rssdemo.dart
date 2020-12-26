import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:rss_feed_medium/models/medium_article_model.dart';
import 'package:url_launcher/url_launcher.dart';


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
      'https://medium.com/feed/@jupassos';
 
 Future fetchNews() async {
    final _response = await http.get(FEED_URL);

    if (_response.statusCode == 200) {
      var _decoded = new RssFeed.parse(_response.body);
      return _decoded.items
          .map((item) => NewsModel(
        title: item.title,
        author: item.dc.creator,
        published: item.pubDate.toString(),
        blogpost: item.guid,
      ))
          .toList();
    } else {
      HttpException('Failed to Fetch the Data');
    }
  }

 launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
 
  @override
  Widget build(BuildContext context) {
      return Scaffold(appBar: AppBar(
        title: Text('oioi'),
      ),
      body: Container(

          child: FutureBuilder(
            future: fetchNews(),
            builder: (context, snap) {
              if (snap.hasData) {
                final List _news = snap.data;
                return ListView.separated(
                  itemBuilder: (context, i) {
                    final NewsModel _item = _news[i];
                    return ListTile(
                      title: Text('${_item.title}', style: TextStyle(fontWeight: FontWeight.w600),),
                      subtitle: Text('by ${_item.author}    published: ${_item.published}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right) ,
                      onTap: (){
                        launchURL(_item.blogpost);
                      },//placeholder para abrir o link depois
                    );
                  },
                  separatorBuilder: (context, i) => Divider(),
                  itemCount: _news.length,
                );
              } else if (snap.hasError) {
                return Center(
                  child: Text(snap.error.toString()),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      );
  }
}
