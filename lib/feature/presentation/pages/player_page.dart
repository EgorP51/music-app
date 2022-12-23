import 'package:flutter/material.dart';
import 'package:music_app/feature/presentation/constants/constants.dart';
import 'package:audioplayers/audioplayers.dart';

class PlayerPage extends StatelessWidget{

  late final _name;
  late final _imgUri;
  late final _songUri;
  late final _genre;
  late final _performer;
  late final _info;

  PlayerPage({super.key, required name,required imgUri, required songUri,required genre,required performer,required info}){
    _name = name;
    _imgUri = imgUri;
    _songUri = songUri;
    _genre = genre;
    _performer = performer;
    _info = info;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.whiteColor,
      ),
      body: Container(
        color: Constants.amberColor,
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              height: 570,
              padding: EdgeInsets.all(15),
              decoration:
              const BoxDecoration(
                color: Constants.whiteColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)
                )
              ),
              child: Column(
                children: [
                  _MainImage(_imgUri,_genre),
                  Text(_name,style: TextStyle(fontSize: 30,color: Constants.blackColor,fontWeight: FontWeight.w500),),
                  Text(_performer,style: TextStyle(fontSize: 20,color: Colors.black38,fontWeight: FontWeight.w400),),
                  Player(_songUri)
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}


class _MainImage extends StatelessWidget{

  late final _imgUri;
  late final _genre;

  _MainImage(String imgUri,String genre){
    _imgUri = imgUri;
    _genre = genre;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
            image:NetworkImage(_imgUri)
        ),
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        border: Border.all(
          width: 6.0,
          //color: Constants.genreColors[_genre]!
        ),
      ),
    );
  }
}

class Player extends StatefulWidget{

  late final _songUri;

  Player(String songUri){
    _songUri = songUri;
  }

  @override
  _PlayerState createState() => _PlayerState(_songUri);
}

class _PlayerState extends State<Player>{

  late final _songUri;

  _PlayerState(String songUri){
    _songUri = songUri;
  }

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Slider(
            activeColor: Constants.amberColor,
            inactiveColor: Constants.amberColor,
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged: (value) async{
              final position = Duration(seconds: value.toInt());
              await audioPlayer.seek(position);

              await audioPlayer.resume();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(position)),
                Text(formatTime(duration - position)),
              ],
            ),
          ),
          CircleAvatar(
            backgroundColor: Constants.amberColor,
            foregroundColor: Constants.blackColor,
            radius: 35,
            child: IconButton(
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Constants.blackColor,
              ),
              iconSize: 50,
              onPressed: () async {
                if(isPlaying){
                  await audioPlayer.pause();
                }else{
                  await audioPlayer.play(_songUri);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

String formatTime(Duration duration){

  String twoDigits(int n) => n.toString().padLeft(2,'0');

  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return [
    if(duration.inHours > 0) hours,
    minutes,seconds
  ].join(':');
}