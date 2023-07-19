import 'package:audre/search_screen.dart';
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
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).popAndPushNamed('/create-post');
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      body: GestureDetector(
        onHorizontalDragStart: (_) => _onPageStartDrag(),
        onHorizontalDragEnd: (_) => _onPageEndDrag(),
        child: Stack(
          children: [
            Center(
              child: PageView.builder(
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
                  return Center(
                    child: AnimatedContainer(
                      width: MediaQuery.of(context).size.width * 1.5,
                      padding: EdgeInsets.symmetric(
                          horizontal: currentPage != index ? 0 : 30),
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Scaffold(
                            // backgroundColor: Colors.white,
                            body: SingleChildScrollView(
                              child: Container(
                                // height: MediaQuery.of(context).size.height * 0.915,
                                height:
                                    MediaQuery.of(context).size.height * 0.97,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: items[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _pageController?.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  },
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _pageController?.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
