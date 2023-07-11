import 'package:flutter/material.dart';
import 'package:audre/feed_screen.dart';
import 'package:audre/profile_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> items = [const ProfileScreen(), const FeedScreen()];

  double currentPage = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: false,
      body: Center(
        child: PageView.builder(
          itemCount: items.length,
          onPageChanged: (int index) {
            setState(() {
              currentPage = index.toDouble();
            });
          },
          itemBuilder: (BuildContext context, int index) {
            final scale = currentPage != index ? 1 : 0.1;

            return AnimatedPadding(
              padding: EdgeInsets.all((10.0 * scale)),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Center(
                  child: items[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
