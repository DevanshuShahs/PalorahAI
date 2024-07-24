import 'package:app/player.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

final videoUrls =[
 'https://www.youtube.com/watch?v=2S9oO8MQi0o',
 'https://www.youtube.com/watch?v=2S9oO8MQi0o'
];

final videoId = YoutubePlayer.convertUrlToId(videoUrls[1]);


class Tutorial extends StatefulWidget {
  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _section1Key = GlobalKey();
  final GlobalKey _section2Key = GlobalKey();
  final GlobalKey _section3Key = GlobalKey();
  final GlobalKey _section4Key = GlobalKey();
  final GlobalKey _section5Key = GlobalKey();
  final GlobalKey _section6Key = GlobalKey();
  final GlobalKey _section7Key = GlobalKey();
  final GlobalKey _section8Key = GlobalKey();
  final GlobalKey _section9Key = GlobalKey();
  final GlobalKey _section10Key = GlobalKey();
  final GlobalKey _section11Key = GlobalKey();





  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome To Tutorials",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  "We on the Palorah team know that it can be hard to know where to get started after you receive your plan. Here are some easy how-to Tutorials to help set you up for success. Please choose which video most pertains to the help you need",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 16),
                // Table of Contents
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () => _scrollToSection(_section1Key),
                        child: Text('Social Media Content'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_section2Key),
                        child: Text('Basic Fundraising'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_section3Key),
                        child: Text('Volunteer Program'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_section4Key),
                        child: Text('Grant Application'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_section5Key),
                        child: Text('Website Improvement'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_section6Key),
                        child: Text('Email Campaign'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_section7Key),
                        child: Text('Branding and Design'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_section8Key),
                        child: Text('Event Planning'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_section9Key),
                        child: Text('Impact Reporting'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_section10Key),
                        child: Text('Connections'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_section11Key),
                        child: Text('Leadership'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                // Content
                 Container(
               key: _section1Key,
               height: 400,
               color: Colors.green[100],
               child: Column(
               children: [
             Padding(
             padding: const EdgeInsets.only(top: 16.0),
             child: Text('Social Media Content', style: TextStyle(fontSize: 24)),
             ),
             SizedBox(height: 16), // Add some space between the text and the image
             InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PlaterScreen(videoId: videoId!)));
              },
              child: Image.network(YoutubePlayer.getThumbnail(videoId: videoId!))),
    ],
  ),
),
                SizedBox(height: 20),
                Container(
               key: _section2Key,
               height: 400,
               color: Colors.green[100],
               child: Column(
               children: [
             Padding(
             padding: const EdgeInsets.only(top: 16.0),
             child: Text('Basic Fundraising ', style: TextStyle(fontSize: 24)),
             ),
             SizedBox(height: 16), // Add some space between the text and the image
             InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PlaterScreen(videoId: videoId!)));
              },
              child: Image.network(YoutubePlayer.getThumbnail(videoId: videoId!))),
    ],
  ),
),
                SizedBox(height: 20),
               Container(
               key: _section3Key,
               height: 400,
               color: Colors.green[100],
               child: Column(
               children: [
             Padding(
             padding: const EdgeInsets.only(top: 16.0),
             child: Text('Volunteer Program', style: TextStyle(fontSize: 24)),
             ),
             SizedBox(height: 16), // Add some space between the text and the image
             InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PlaterScreen(videoId: videoId!)));
              },
              child: Image.network(YoutubePlayer.getThumbnail(videoId: videoId!))),
    ],
  ),
),
                SizedBox(height: 20),
                Container(
               key: _section4Key,
               height: 400,
               color: Colors.green[100],
               child: Column(
               children: [
             Padding(
             padding: const EdgeInsets.only(top: 16.0),
             child: Text('Grant Application', style: TextStyle(fontSize: 24)),
             ),
             SizedBox(height: 16), // Add some space between the text and the image
             InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PlaterScreen(videoId: videoId!)));
              },
              child: Image.network(YoutubePlayer.getThumbnail(videoId: videoId!))),
    ],
  ),
),
                SizedBox(height: 20),
               Container(
               key: _section5Key,
               height: 400,
               color: Colors.green[100],
               child: Column(
               children: [
             Padding(
             padding: const EdgeInsets.only(top: 16.0),
             child: Text('Website Improvement', style: TextStyle(fontSize: 24)),
             ),
             SizedBox(height: 16), // Add some space between the text and the image
             InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PlaterScreen(videoId: videoId!)));
              },
              child: Image.network(YoutubePlayer.getThumbnail(videoId: videoId!))),
    ],
  ),
),
                SizedBox(height: 20),
               Container(
               key: _section6Key,
               height: 400,
               color: Colors.green[100],
               child: Column(
               children: [
             Padding(
             padding: const EdgeInsets.only(top: 16.0),
             child: Text('Email Campaign', style: TextStyle(fontSize: 24)),
             ),
             SizedBox(height: 16), // Add some space between the text and the image
             InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PlaterScreen(videoId: videoId!)));
              },
              child: Image.network(YoutubePlayer.getThumbnail(videoId: videoId!))),
    ],
  ),
),
                SizedBox(height: 20),
                Container(
               key: _section7Key,
               height: 400,
               color: Colors.green[100],
               child: Column(
               children: [
             Padding(
             padding: const EdgeInsets.only(top: 16.0),
             child: Text('Branding and Design', style: TextStyle(fontSize: 24)),
             ),
             SizedBox(height: 16), // Add some space between the text and the image
             InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PlaterScreen(videoId: videoId!)));
              },
              child: Image.network(YoutubePlayer.getThumbnail(videoId: videoId!))),
    ],
  ),
),
                SizedBox(height: 20),
                Container(
               key: _section8Key,
               height: 400,
               color: Colors.green[100],
               child: Column(
               children: [
             Padding(
             padding: const EdgeInsets.only(top: 16.0),
             child: Text('Event Planning', style: TextStyle(fontSize: 24)),
             ),
             SizedBox(height: 16), // Add some space between the text and the image
             InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PlaterScreen(videoId: videoId!)));
              },
              child: Image.network(YoutubePlayer.getThumbnail(videoId: videoId!))),
    ],
  ),
),
                SizedBox(height: 20),
               Container(
               key: _section9Key,
               height: 400,
               color: Colors.green[100],
               child: Column(
               children: [
             Padding(
             padding: const EdgeInsets.only(top: 16.0),
             child: Text('Impact Reporting', style: TextStyle(fontSize: 24)),
             ),
             SizedBox(height: 16), // Add some space between the text and the image
             InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PlaterScreen(videoId: videoId!)));
              },
              child: Image.network(YoutubePlayer.getThumbnail(videoId: videoId!))),
    ],
  ),
),
                SizedBox(height: 20),
               Container(
               key: _section10Key,
               height: 400,
               color: Colors.green[100],
               child: Column(
               children: [
             Padding(
             padding: const EdgeInsets.only(top: 16.0),
             child: Text('Connections', style: TextStyle(fontSize: 24)),
             ),
             SizedBox(height: 16), // Add some space between the text and the image
             InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PlaterScreen(videoId: videoId!)));
              },
              child: Image.network(YoutubePlayer.getThumbnail(videoId: videoId!))),
    ],
  ),
),
                SizedBox(height: 20),
                Container(
               key: _section11Key,
               height: 400,
               color: Colors.green[100],
               child: Column(
               children: [
             Padding(
             padding: const EdgeInsets.only(top: 16.0),
             child: Text('Leadership', style: TextStyle(fontSize: 24)),
             ),
             SizedBox(height: 16), // Add some space between the text and the image
             InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PlaterScreen(videoId: videoId!)));
              },
              child: Image.network(YoutubePlayer.getThumbnail(videoId: videoId!))),
    ],
  ),
),
              ],
            ),
          ),
        ),
      ),
    );
  }
}