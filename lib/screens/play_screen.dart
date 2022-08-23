import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
// ignore: depend_on_referenced_packages
import 'package:rxdart/rxdart.dart';
import 'package:nav_music_player/widgets/widget.dart';
import 'package:marquee/marquee.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  // ignore: prefer_typing_uninitialized_variables
  var data;

  final player = AudioPlayer();
  List allsongs = [];
  int index = 0;
  StreamController<String> titleController = StreamController();

  void playSongwithnoti(int index) {
    String title = allsongs[index].title!;
    titleController.sink.add(title);
    playSong(index);
  }

  void playSong(int index) async {
    await player.setUrl(allsongs[index].uri!);
    player.play();
    await player.setSpeed(1.0);
  }

  void pauseSong() async {
    await player.pause();
  }

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    data = ModalRoute.of(context)!.settings.arguments;
    allsongs = data['allsongs'];
    index = data['index'];

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: size.height * 0.48,
                  width: size.width * 0.82,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/img/a.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
                stream: titleController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: 31,
                      width: double.maxFinite,
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Marquee(
                        velocity: 50,
                        //pauseAfterRound: const Duration(seconds: 2),
                        text: ("${snapshot.data}        "),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<PositionData>(
              stream: positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return SeekBar(
                  duration: positionData?.duration ?? Duration.zero,
                  position: positionData?.position ?? Duration.zero,
                  bufferedPosition:
                      positionData?.bufferedPosition ?? Duration.zero,
                  onChangeEnd: player.seek,
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: const Icon(
                    Icons.skip_previous,
                    size: 100,
                  ),
                  onTap: () {
                    pauseSong();
                    index = (index - 1) % (allsongs.length);
                    playSongwithnoti(index);
                  },
                ),
                StreamBuilder<PlayerState>(
                  stream: player.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final playing = playerState?.playing;

                    if (playing != true) {
                      return InkWell(
                        child: const Icon(
                          Icons.play_circle_fill_rounded,
                          size: 100,
                        ),
                        onTap: () {
                          playSongwithnoti(index);
                        },
                      );
                    } else {
                      return InkWell(
                        child: const Icon(
                          Icons.pause_circle_filled_rounded,
                          size: 100,
                        ),
                        onTap: () {
                          pauseSong();
                        },
                      );
                    }
                  },
                ),
                InkWell(
                  child: const Icon(
                    Icons.skip_next,
                    size: 100,
                  ),
                  onTap: () {
                    pauseSong();
                    index = (index + 1) % (allsongs.length);
                    playSongwithnoti(index);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
