import 'package:audre/search_screen.dart';
import 'package:audre/services/socket_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:audre/feed_screen.dart';
import 'package:audre/profile_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isDragging = false;
  PageController? _pageController;
  final List<Widget> items = [
    const FeedScreen(),
    const SearchScreen(),
    const ProfileScreen(),
  ];

  double currentPage = 0.0;
  void _onPageStartDrag() {
    setState(() {
      _isDragging = true;
    });
  }

  void _onPageEndDrag() {
    setState(() {
      _isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SocketService.connectToServer(
        userId: FirebaseAuth.instance.currentUser!.uid);
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: false,
      resizeToAvoidBottomInset: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/record-post');
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      body: PageView.builder(
        physics: !_isDragging
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        onPageChanged: (int index) {
          setState(() {
            currentPage = index.toDouble();
          });
        },
        controller: _pageController,
        itemBuilder: (BuildContext context, int index) {
          // final padding = (100.0 * scale + (100.0 / height));
          return Container(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              padding: EdgeInsets.all(currentPage != index ? 0 : 10),
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: Colors.white,
                  ),
                  child: items[index]));
        },
      ),
    );
  }
}
