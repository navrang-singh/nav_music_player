import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nav_music_player/services/service.dart';

class SongList extends StatefulWidget {
  const SongList({Key? key}) : super(key: key);

  @override
  State<SongList> createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  GetSongs getSongs = GetSongs();

  Widget widpermissionNotFound() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/sad.svg',
              color: Colors.red,
              semanticsLabel: 'sad pick',
            ),
            const Text(
              'There is nothing to show',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Songs",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: FutureBuilder<List<SongModel>>(
        future: getSongs.getAllSong(),
        builder: (context, item) {
          if (item.data == null) return const CircularProgressIndicator();

          if (item.data!.isEmpty) return widpermissionNotFound();

          return ListView.builder(
            itemCount: item.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(item.data![index].title),
                subtitle: Text(item.data![index].artist ?? "No Artist"),
                trailing: const Icon(Icons.arrow_forward_rounded),
                leading: QueryArtworkWidget(
                  id: item.data![index].id,
                  type: ArtworkType.AUDIO,
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/playscreen',
                    arguments: {
                      'allsongs': item.data,
                      'index': index,
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
