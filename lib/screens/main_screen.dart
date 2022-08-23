import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: InkWell(
          child: Container(
            height: 50,
            width: 300,
            decoration: const BoxDecoration(
              color: Colors.grey,
            ),
            child: const Text(
              "fetch all song",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/songlist');
          },
        ),
      ),
    );
  }
}
