import 'package:on_audio_query/on_audio_query.dart';

class GetSongs {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<SongModel>> getAllSong() async {
    List<SongModel> allSongs = await _audioQuery.querySongs();
    return allSongs;
  }
}
