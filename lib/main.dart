import 'package:flutter/material.dart';
import 'package:nav_music_player/screens/screen.dart';
import 'package:nav_music_player/services/service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GetPermission getPermission = GetPermission();

  @override
  void initState() {
    super.initState();
    getPermission.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const MainScreen(),
        '/songlist': (context) => const SongList(),
        '/playscreen': (context) => const PlayScreen(),
      },
    );
  }
}
