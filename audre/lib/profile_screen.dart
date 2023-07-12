import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Scaffold(
          appBar: AppBar(
            leading: const BackButton(
              color: Colors.white,
            ),
            flexibleSpace: Container(
              alignment: Alignment.center,
              child: const Center(
                child: Text(
                  'Profile',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {},
              )
            ],
          ),
          // backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 150,
                        child: Stack(
                          children: [
                            Align(
                              alignment: const AlignmentDirectional(-1, 0),
                              child: Container(
                                width: 250,
                                height: 150,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 5, 5, 5),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(100),
                                    topLeft: Radius.circular(0),
                                    topRight: Radius.circular(100),
                                  ),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Align(
                                  alignment: const AlignmentDirectional(1, 0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          'https://picsum.photos/seed/298/600',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Ghost Writer',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          IntroSection(
                            introText:
                                'Lesbian, Feminist, Poet, Activist and Mother, 1934-1992, New York, NY, USA, 58',
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/create-profile');
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(double.infinity, 40)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 0, 0, 0)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildFFL(title: 'Notes', subtitle: '40'),
                      _buildFFL(title: 'Following', subtitle: '1.2k'),
                      _buildFFL(title: 'Followers', subtitle: '1.2k'),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}

Widget _buildFFL({String? title, String? subtitle}) {
  return Column(
    children: [
      Text(
        subtitle!,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        title!,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

class IntroSection extends StatefulWidget {
  final String introText;
  const IntroSection({super.key, required this.introText});
  @override
  _IntroSectionState createState() => _IntroSectionState();
}

class _IntroSectionState extends State<IntroSection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bioText = widget.introText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            children: [
              Text(
                isExpanded ? bioText : '${bioText.substring(0, 40)}...',
                style: const TextStyle(
                  fontSize: 15,
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded ? 'Show less' : 'Show more',
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
