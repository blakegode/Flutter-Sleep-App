import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';

class YoutubeState extends StatefulWidget {
  @override
  _YoutubeStateState createState() => _YoutubeStateState();
}

class _YoutubeStateState extends State<YoutubeState> {

  List<String> titles = [
    'How much sleep do you really need?',
    'Tips for Better Sleep',
    'What to do if you have trouble sleeping',
    'Sleep data and statistics',
    'How can you prevent drowsey driving?',
  ];

  List<String> videoIds = [
    'knJWF4km3y0',
    't0kACis_dJE',
    'ooBDWD4VH7o',
    'N_rEpjEBC60',
    'CqW3Eeszi-Q',
  ];

  List<Uri> links = [
    Uri.parse('https://www.cdc.gov/sleep/about_sleep/how_much_sleep.html'),
    Uri.parse('https://www.cdc.gov/sleep/about_sleep/sleep_hygiene.html'),
    Uri.parse('https://www.cdc.gov/sleep/about_sleep/cant_sleep.html'),
    Uri.parse('https://www.cdc.gov/sleep/data_statistics.html'),
    Uri.parse('https://www.cdc.gov/sleep/features/drowsy-driving.html'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(videoIds.length, (index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    titles[index],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: videoIds[index],
                    flags: YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                      isLive: false,
                    ),
                  ),
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.blue,
                  progressColors: ProgressBarColors(
                    playedColor: Colors.blue,
                    handleColor: Colors.blueAccent,
                  ),
                ),
                builder: (context, player) {
                  return player;
                },
              ),
              SizedBox(height: 20),
              Link(
                uri: links[index],
                target: LinkTarget.defaultTarget,
                builder: (context,openLink) => TextButton(
                  onPressed: openLink,
                  child: Center(
                  child: Text(
                      links[index].toString(),
                      style: TextStyle(fontSize: 20, color: Colors.lightBlue ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          );
        }),
      ),
    );
  }
}