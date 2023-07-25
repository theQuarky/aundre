import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(0, 255, 255, 255),
      body: Center(
        child: Column(
          children: [
            Text('Feed'),
            ElevatedButton(onPressed: null, child: Text('Post'))
          ],
        ),
      ),
    );
  }
}
