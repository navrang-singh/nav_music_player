import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:on_audio_query/on_audio_query.dart';

class GetPermission {
  OnAudioQuery audioQuery = OnAudioQuery();

  requestPermission() async {
    // web version is not supported !!! :(
    if (!kIsWeb) {
      bool permissionStatus = await audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await audioQuery.permissionsRequest();
      }
    }
  }
}
