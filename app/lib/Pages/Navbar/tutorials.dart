import 'package:app/Pages/Quizzes/BasicFundraising.dart';
import 'package:app/Pages/Quizzes/BrandingandDesign.dart';
import 'package:app/Pages/Quizzes/Connections.dart';
import 'package:app/Pages/Quizzes/EmailCampaign.dart';
import 'package:app/Pages/Quizzes/EventPlanning.dart';
import 'package:app/Pages/Quizzes/GrantApplication.dart';
import 'package:app/Pages/Quizzes/ImpactReporting.dart';
import 'package:app/Pages/Quizzes/Leadership.dart';
import 'package:app/Pages/Quizzes/SocialMedia.dart';
import 'package:app/Pages/Quizzes/VolunteerProgram.dart';
import 'package:app/Pages/Quizzes/WebsiteImprovement.dart';
import 'package:app/player.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final videoUrls = [
  'https://www.youtube.com/watch?v=IwMSxbjceBs',// social media 
  'https://www.youtube.com/watch?v=KKseWRzPrUI',// basic fundraising 
  "https://www.youtube.com/watch?v=vSYaWtVNP0I",//volunteer program
  'https://www.youtube.com/watch?v=Dus-C5oa9tA',//grant application 
  'https://www.youtube.com/watch?v=8B6dOWUnm3U',//website development
  'https://www.youtube.com/watch?v=A2gABLXcMy8',//email campaign 
  'https://www.youtube.com/watch?v=bGM8be6_7F8',//Branding 
  "https://www.youtube.com/watch?v=kgQt2JK_5b8",//event planning
  "https://www.youtube.com/watch?v=BV-ZjJh1w8g",//impact reporting
  'https://www.youtube.com/watch?v=BFu6Ptclq_E',//connections
  "https://www.youtube.com/watch?v=bp8DWHpyrpE&t=243s" //leadership

];

final videoId0 = YoutubePlayer.convertUrlToId(videoUrls[0]);
final videoId1 = YoutubePlayer.convertUrlToId(videoUrls[1]);
final videoId2 = YoutubePlayer.convertUrlToId(videoUrls[2]);
final videoId3 = YoutubePlayer.convertUrlToId(videoUrls[3]);
final videoId4 = YoutubePlayer.convertUrlToId(videoUrls[4]);
final videoId5 = YoutubePlayer.convertUrlToId(videoUrls[5]);
final videoId6 = YoutubePlayer.convertUrlToId(videoUrls[6]);
final videoId7 = YoutubePlayer.convertUrlToId(videoUrls[7]);
final videoId8 = YoutubePlayer.convertUrlToId(videoUrls[8]);
final videoId9 = YoutubePlayer.convertUrlToId(videoUrls[9]);
final videoId10 = YoutubePlayer.convertUrlToId(videoUrls[10]);
class Tutorial extends StatefulWidget {
  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  late YoutubePlayerController _controller;
  bool _isPlaying = false;
  String? _currentVideoId;

  Map<String, Map<String, dynamic>> _quizResults = {
    'socialMedia': {'completed': false, 'score': 0, 'total': 0},
    'basicFundraising': {'completed': false, 'score': 0, 'total': 0},
    'volunteerProgram': {'completed': false, 'score': 0, 'total': 0},
    'grantApplication': {'completed': false, 'score': 0, 'total': 0},
    'websiteDevelopment': {'completed': false, 'score': 0, 'total': 0},
    'emailCampaign': {'completed': false, 'score': 0, 'total': 0},
    'branding': {'completed': false, 'score': 0, 'total': 0},
    'eventPlanning': {'completed': false, 'score': 0, 'total': 0},
    'impactReporting': {'completed': false, 'score': 0, 'total': 0},
    'connections': {'completed': false, 'score': 0, 'total': 0},
    'leadership': {'completed': false, 'score': 0, 'total': 0},
  };


  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: videoId0!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    _controller.addListener(_onPlayerStateChange);
    _fetchQuizResults();
  }

  Future<void> _fetchQuizResults() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          setState(() {
            final fetchedResults = doc.data()?['quizResults'];
            if (fetchedResults != null) {
              _quizResults.forEach((key, value) {
                if (fetchedResults[key] != null) {
                  _quizResults[key] = Map<String, dynamic>.from(fetchedResults[key]);
                }
              });
            }
          });
        }
      } catch (e) {
        print('Error fetching quiz results: $e');
        // Handle error (e.g., show a snackbar to the user)
      }
    }
  }

  Future<void> _onQuizCompleted(String section, int score, int total) async {
    setState(() {
      _quizResults[section] = {'completed': true, 'score': score, 'total': total};
    });

    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'quizResults': _quizResults,
        }, SetOptions(merge: true));
      } catch (e) {
        print('Error saving quiz results: $e');
        // Handle error (e.g., show a snackbar to the user)
      }
    }
  }

  Widget _buildQuizButton(String section, String label) {
    final result = _quizResults[section]!;
    return result['completed']
        ? Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  'Quiz Completed',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Score: ${result['score']} out of ${result['total']}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          )
        : ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => _getQuizPage(section),
              ));
            },
            child: Text('Take $label Quiz'),
          );
  }

  Widget _getQuizPage(String section) {
    switch (section) {
      case 'socialMedia':
        return GrantProposalQuizApp(
          onQuizCompleted: (score, total) => _onQuizCompleted(section, score, total),
        );
        case 'basicFundraising':
        return FundraisingQuizApp(
          onQuizCompleted: (score, total) => _onQuizCompleted(section, score, total),
        );
        case 'volunteerProgram':
        return VolunteerRecruitmentQuizApp(
          onQuizCompleted: (score, total) => _onQuizCompleted(section, score, total),
        );
        case 'grantApplication':
        return GrantApplicationQuizApp(
          onQuizCompleted: (score, total) => _onQuizCompleted(section, score, total),
        );
        case 'websiteDevelopment':
        return NonprofitWebsiteQuizApp(
          onQuizCompleted: (score, total) => _onQuizCompleted(section, score, total),
        );
        case 'emailCampaign':
        return EmailCampaignQuizApp(
          onQuizCompleted: (score, total) => _onQuizCompleted(section, score, total),
        );
         case 'branding':
        return BrandingDesignQuizApp(
          onQuizCompleted: (score, total) => _onQuizCompleted(section, score, total),
        );
        case 'eventPlanning':
        return EventPlanningQuizApp(
          onQuizCompleted: (score, total) => _onQuizCompleted(section, score, total),
        );
        case 'impactReporting':
        return ImpactReportQuizApp(
          onQuizCompleted: (score, total) => _onQuizCompleted(section, score, total),
        );
        case 'connections':
        return ConnectionsQuizApp(
          onQuizCompleted: (score, total) => _onQuizCompleted(section, score, total),
        );
        case 'leadership':
        return LeadershipQuizApp(
          onQuizCompleted: (score, total) => _onQuizCompleted(section, score, total),
        );
      
      default:
        return Container(); // Placeholder for unimplemented quizzes
    }
  }


  


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
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }


 

  void _onPlayerStateChange() {
    if (_controller.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onPlayerStateChange);
    _controller.dispose();
    super.dispose();
  }

  void _playVideo(String videoId) {
    setState(() {
      _currentVideoId = videoId;
    });
    _controller.load(videoId);
    _controller.play();
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
                const Text(
                  "Welcome To Tutorials",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  "We on the Palorah team know that it can be hard to know where to get started after you receive your plan. Here are some easy how-to Tutorials to help set you up for success. Please choose which video most pertains to the help you need",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                // Table of Contents
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () => _scrollToSection(_section1Key),
                        child: const Text('Social Media Content'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_section2Key),
                        child: const Text('Basic Fundraising'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_section3Key),
                        child: const Text('Volunteer Program'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_section4Key),
                        child: const Text('Grant Application'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_section5Key),
                        child: const Text('Website Improvement'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_section6Key),
                        child: const Text('Email Campaign'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_section7Key),
                        child: const Text('Branding and Design'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_section8Key),
                        child: const Text('Event Planning'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_section9Key),
                        child: const Text('Impact Reporting'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_section10Key),
                        child: const Text('Connections'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_section11Key),
                        child: const Text('Leadership'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Content
                Column(
                  children: [
                    Container(
                  key: _section1Key,
                  height: 400,
                  color: Colors.green[100],
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text('Social Media Content', style: TextStyle(fontSize: 24)),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PlaterScreen(videoId: videoId0!),
                          ));
                        },
                        child: Image.network(YoutubePlayer.getThumbnail(videoId: videoId0!)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildQuizButton('socialMedia', 'Social Media'),
                const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Container(
                      key: _section2Key,
                      height: 400,
                      color: Colors.green[100],
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Text('Basic Fundraising', style: TextStyle(fontSize: 24)),
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PlaterScreen(videoId: videoId1!)));
                            },
                            child: Image.network(YoutubePlayer.getThumbnail(videoId: videoId1!)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildQuizButton('basicFundraising', 'Basic Fundraising'),
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Container(
                      key: _section3Key,
                      height: 400,
                      color: Colors.green[100],
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Text('Volunteer Program',
                                style: TextStyle(fontSize: 24)),
                          ),
                          const SizedBox(
                              height:
                                  16), // Add some space between the text and the image
                          InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PlaterScreen(videoId: videoId2!)));
                              },
                              child: Image.network(
                                  YoutubePlayer.getThumbnail(videoId: videoId2!))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                     _buildQuizButton('volunteerProgram', 'Volunteer Program'),
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Container(
                      key: _section4Key,
                      height: 400,
                      color: Colors.green[100],
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Text('Grant Application',
                                style: TextStyle(fontSize: 24)),
                          ),
                          const SizedBox(
                              height:
                                  16), // Add some space between the text and the image
                          InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PlaterScreen(videoId: videoId3!)));
                              },
                              child: Image.network(
                                  YoutubePlayer.getThumbnail(videoId: videoId3!))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                     _buildQuizButton('grantApplication', 'Grant Application'),
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Container(
                      key: _section5Key,
                      height: 400,
                      color: Colors.green[100],
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Text('Website Improvement',
                                style: TextStyle(fontSize: 24)),
                          ),
                          const SizedBox(
                              height:
                                  16), // Add some space between the text and the image
                          InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PlaterScreen(videoId: videoId4!)));
                              },
                              child: Image.network(
                                  YoutubePlayer.getThumbnail(videoId: videoId4!))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                     _buildQuizButton('websiteDevelopment', 'Website Development'),
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Container(
                      key: _section6Key,
                      height: 400,
                      color: Colors.green[100],
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Text('Email Campaign',
                                style: TextStyle(fontSize: 24)),
                          ),
                          const SizedBox(
                              height:
                                  16), // Add some space between the text and the image
                          InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PlaterScreen(videoId: videoId5!)));
                              },
                              child: Image.network(
                                  YoutubePlayer.getThumbnail(videoId: videoId5!))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                     _buildQuizButton('emailCampaign', 'Email Campaign'),
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Container(
                      key: _section7Key,
                      height: 400,
                      color: Colors.green[100],
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Text('Branding and Design',
                                style: TextStyle(fontSize: 24)),
                          ),
                          const SizedBox(
                              height:
                                  16), // Add some space between the text and the image
                          InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PlaterScreen(videoId: videoId6!)));
                              },
                              child: Image.network(
                                  YoutubePlayer.getThumbnail(videoId: videoId6!))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                     _buildQuizButton('branding', 'Branding'),
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Container(
                      key: _section8Key,
                      height: 400,
                      color: Colors.green[100],
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Text('Event Planning',
                                style: TextStyle(fontSize: 24)),
                          ),
                          const SizedBox(
                              height:
                                  16), // Add some space between the text and the image
                          InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PlaterScreen(videoId: videoId7!)));
                              },
                              child: Image.network(
                                  YoutubePlayer.getThumbnail(videoId: videoId7!))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                     _buildQuizButton('eventPlanning', 'Event Planning'),
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Container(
                      key: _section9Key,
                      height: 400,
                      color: Colors.green[100],
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Text('Impact Reporting',
                                style: TextStyle(fontSize: 24)),
                          ),
                          const SizedBox(
                              height:
                                  16), // Add some space between the text and the image
                          InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PlaterScreen(videoId: videoId8!)));
                              },
                              child: Image.network(
                                  YoutubePlayer.getThumbnail(videoId: videoId8!))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                     _buildQuizButton('impactReporting', 'Impact Reporting'),
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Container(
                      key: _section10Key,
                      height: 400,
                      color: Colors.green[100],
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child:
                                Text('Connections', style: TextStyle(fontSize: 24)),
                          ),
                          const SizedBox(
                              height:
                                  16), // Add some space between the text and the image
                          InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PlaterScreen(videoId: videoId9!)));
                              },
                              child: Image.network(
                                  YoutubePlayer.getThumbnail(videoId: videoId9!))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildQuizButton('connections', 'Connections'),
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Container(
                      key: _section11Key,
                      height: 400,
                      color: Colors.green[100],
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child:
                                Text('Leadership', style: TextStyle(fontSize: 24)),
                          ),
                          const SizedBox(
                              height:
                                  16), // Add some space between the text and the image
                          InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PlaterScreen(videoId: videoId10!)));
                              },
                              child: Image.network(
                                  YoutubePlayer.getThumbnail(videoId: videoId10!))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildQuizButton('leadership', 'Leadership'),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      
    );
  }
}
