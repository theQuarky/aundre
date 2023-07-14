import 'package:audre/models/user_model.dart';
import 'package:audre/providers/user_provider.dart';
import 'package:audre/services/user_api_services.dart';
import 'package:audre/services/user_graphql_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final String uid;
  const OtherUserProfileScreen({super.key, required this.uid});

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  UserModal? user, currentUser;

  Future<void> followUnfollowUser() async {
    if (getRelationshipStatus() == 'Following') {
      UserApiServices.unfollowUser(uid: currentUser?.uid, unfollowId: user?.uid)
          .then((value) {
        loadUser();
      });
    } else if (getRelationshipStatus() == 'Requested') {
      UserApiServices.cancelFollowRequest(
              uid: currentUser?.uid, cancelId: user?.uid)
          .then((value) {
        loadUser();
      });
    } else {
      UserApiServices.followUser(uid: currentUser?.uid, followId: user?.uid)
          .then((value) {
        loadUser();
      });
    }
  }

  Future<void> loadUser() async {
    UserGraphQLService.getUser(widget.uid).then((value) {
      setState(() {
        user = value;
      });
    });
    UserProvider.getUser().then((value) {
      print('USER: ${value?.toLocalString()}');
      setState(() {
        currentUser = value;
      });
    });
  }

  String getRelationshipStatus() {
    print('''
      currentUser pending_requests:  $currentUser
      user UID: ${user?.uid}
    ''');

    if (currentUser!.pending_requests!.contains(user!.uid)) {
      return "Requested";
    }
    if (currentUser!.following!.contains(user!.uid)) {
      return "Following";
    }
    return "Follow";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null && currentUser == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Scaffold(

          // backgroundColor: Colors.white,
          body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height * 0.915,
          height: MediaQuery.of(context).size.height * 0.97,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BackButton(
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const Text('Profile',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  IconButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login', (Route<dynamic> route) => false);
                      },
                      icon: const Icon(Icons.logout)),
                ],
              ),
              currentUser!.requests!.contains(user!.uid)
                  ? Container(
                      height: 25,
                      width: 200,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 0, 0, 0),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                              ),
                              onPressed: () {
                                UserApiServices.acceptFollowRequest(
                                        uid: currentUser?.uid,
                                        acceptId: user?.uid)
                                    .then((value) {
                                  loadUser();
                                });
                              },
                              child: const Text(
                                'Accept',
                                style: TextStyle(color: Colors.white),
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                              ),
                              onPressed: () {
                                UserApiServices.rejectFollowRequest(
                                        uid: currentUser?.uid,
                                        rejectId: user?.uid)
                                    .then((value) {
                                  loadUser();
                                });
                              },
                              child: const Text(
                                'Decline',
                                style: TextStyle(color: Colors.white),
                              )),
                        ],
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 10,
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
                              color: Colors.black,
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
                                    child: Image(
                                        image: NetworkImage(user?.profile_pic ??
                                            'https://www.pinclipart.com/picdir/big/148-1486972_mystery-man-avatar-circle-clipart.png'),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover),
                                    // child: Image.network(
                                    //   user?.profile_pic ??
                                    //       'https://www.pinclipart.com/picdir/big/148-1486972_mystery-man-avatar-circle-clipart.png',
                                    //   width: 100,
                                    //   height: 100,
                                    //   fit: BoxFit.cover,
                                    // ),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        user?.username != null ? '@${user?.username}' : '',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      IntroSection(
                        introText: user?.intro ?? '',
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
                    followUnfollowUser();
                  },
                  style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all<Size>(const Size(4, 40)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 0, 0, 0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  child: Text(
                    getRelationshipStatus(),
                    style: const TextStyle(
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
          width: MediaQuery.of(context).size.width * 0.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isExpanded
                    ? bioText.trim()
                    : bioText.length > 100
                        ? '${bioText.trim().substring(0, 100)}...'
                        : bioText.trim(),
                style: const TextStyle(
                  fontSize: 15,
                ),
              )
            ],
          ),
        ),
        bioText.trim().length > 100
            ? GestureDetector(
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
              )
            : const SizedBox(),
      ],
    );
  }
}

class OtherUserProfileScreenArguments {
  final String uid;

  OtherUserProfileScreenArguments(this.uid);
}
