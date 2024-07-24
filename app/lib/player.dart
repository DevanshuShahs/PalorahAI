import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class PlaterScreen extends StatefulWidget {
  const PlaterScreen({super.key, required this.videoId});

  final String videoId;

  @override
  State<PlaterScreen> createState() => _PlaterScreenState();
}

class _PlaterScreenState extends State<PlaterScreen> {
  late final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: widget.videoId,
    flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
    ),
);
@override
void dispose(){
  super.dispose();
  _controller.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Player"),),
      body: YoutubePlayer(controller: _controller),
    );
  }
}