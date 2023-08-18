import 'package:intl/intl.dart';
import 'package:audre/components/player.dart';
import 'package:audre/models/note_model.dart';
import 'package:audre/providers/user_provider.dart';
import 'package:audre/services/note_api_services.dart';
import 'package:audre/services/note_graphql_services.dart';
import 'package:flutter/material.dart';

class NoteView extends StatefulWidget {
  final String noteId;
  const NoteView({super.key, required this.noteId});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  final TextEditingController _commentController = TextEditingController();
  late NoteModel? note;
  bool loading = true;
  bool isCommentLoading = true;
  var isLiked;
  List<dynamic> comments = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NoteGraphQLService.getNote(noteId: widget.noteId).then((value) {
      setState(() {
        note = value;
        loading = false;
      });

      if (value!.interactions!.isNotEmpty) {
        value.interactions!.forEach((element) {
          if (element.userId == UserProvider.getUser()!.uid) {
            if (element.type == 'like') {
              setState(() {
                isLiked = true;
              });
            } else {
              setState(() {
                isLiked = false;
              });
            }
          }
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> likeDislike({
    required String noteId,
    required bool? likeStatus,
  }) async {
    // setState(() {
    //   isLiked = likeStatus;
    // });
    await NoteApiServices.likeDislikeNote(
        noteId: noteId,
        userId: UserProvider.getUser()!.uid ?? '',
        isLiked: likeStatus);
    setState(() {
      isLiked = likeStatus;
    });

    NoteModel? tempNote = await NoteGraphQLService.getNote(
      noteId: widget.noteId,
    );

    List userInteractions = tempNote!.interactions
        .where((element) => element.userId == UserProvider.getUser()!.uid)
        .toList();

    setState(() {
      note = tempNote;
    });

    tempNote.toLocalString();
    if (userInteractions.isEmpty) {
      setState(() {
        isLiked = null;
      });
      return;
    }

    String interactionType = userInteractions.first.type;
    if (interactionType == 'like') {
      setState(() {
        isLiked = true;
      });
      return;
    }

    if (interactionType == 'dislike') {
      setState(() {
        isLiked = false;
      });
      return;
    }
  }

  void _showCommentWindow(BuildContext context) async {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // return CommentView(comments: comments, noteId: note!.noteId);
        String noteId = note!.noteId;
        String profilePic = UserProvider.getUser()?.profile_pic ?? '';
        return isCommentLoading
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                appBar: AppBar(
                    title: const Text('Post Comments'),
                    leading: BackButton(
                      onPressed: () => Navigator.of(context).pop(),
                    )),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 150,
                        child: ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            return CommentBubble(
                              comment: comments[index],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 10),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundImage: NetworkImage(profilePic),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  constraints: const BoxConstraints(
                                      minHeight: 40,
                                      maxHeight:
                                          120), // Set a minimum and maximum height for the comment box
                                  child: SingleChildScrollView(
                                    child: TextFormField(
                                      controller: _commentController,
                                      cursorColor: Colors.white,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      maxLines:
                                          null, // Allow the TextField to have unlimited lines (expand vertically)
                                      decoration: const InputDecoration(
                                        hintText: 'Add a comment...',
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isCommentLoading = true;
                                  });
                                  comments.add({
                                    'user': {
                                      'username':
                                          UserProvider.getUser()!.username,
                                      'profile_pic':
                                          UserProvider.getUser()!.profile_pic
                                    },
                                    'comment': _commentController.text
                                  });
                                  NoteApiServices.addComment(
                                          noteId: noteId,
                                          userId: UserProvider.getUser()!.uid,
                                          comment: _commentController.text)
                                      .then((value) {
                                    NoteGraphQLService.getComments(
                                            noteId: noteId)
                                        .then((value) {
                                      setState(() {
                                        comments = value;
                                      });
                                      _commentController.clear();
                                      Navigator.of(context).pop();
                                    });
                                  });
                                },
                                icon: const Icon(Icons.send_rounded,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (note == null) {
      return const Center(child: Text('Some problem occured'));
    }
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          // gradient: const LinearGradient(
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //     colors: [Colors.purple, Colors.blue]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 100),
            Player(audioUrl: note!.mediaUrl),
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      bool? likeStatus = isLiked != true ? true : null;

                      likeDislike(noteId: note!.noteId, likeStatus: likeStatus);
                    },
                    icon: Icon(Icons.favorite_rounded,
                        color: isLiked != null && isLiked == true
                            ? Colors.red
                            : Colors.white)),
                Text(note!.likeCount.toString(),
                    style: const TextStyle(color: Colors.white)),
                const Divider(),
                IconButton(
                    onPressed: () {
                      bool? likeStatus = isLiked != false ? false : null;

                      likeDislike(noteId: note!.noteId, likeStatus: likeStatus);
                    },
                    icon: Icon(Icons.heart_broken_rounded,
                        color: isLiked != null && isLiked == false
                            ? Colors.red
                            : Colors.white)),
                Text(note!.dislikeCount.toString(),
                    style: const TextStyle(color: Colors.white)),
                const Divider(),
                IconButton(
                    onPressed: () {
                      NoteGraphQLService.getComments(noteId: note!.noteId)
                          .then((value) {
                        setState(() {
                          isCommentLoading = false;
                        });
                        setState(() {
                          comments = value;
                        });
                        _showCommentWindow(context);
                      }).catchError((e) {
                        print(e);
                      });
                    },
                    icon:
                        const Icon(Icons.comment_rounded, color: Colors.white)),
                Text(note!.commentCount.toString(),
                    style: const TextStyle(color: Colors.white)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// comment bubble UI

class CommentBubble extends StatefulWidget {
  final dynamic comment;
  const CommentBubble({super.key, required this.comment});

  @override
  State<CommentBubble> createState() => _CommentBubbleState();
}

class _CommentBubbleState extends State<CommentBubble> {
  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;
    final user = comment['user'];
    print(comment['created_at']);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(user['profile_pic']),
                  )),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(user['username'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Text(comment['comment'],
                        style: const TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        readTimestamp(comment[
                            'created_at']), // Replace with the timestamp of the comment.
                        style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

String readTimestamp(String timestamp) {
  var now = DateTime.now();
  var format = DateFormat('HH:mm a');
  var date = DateTime.fromMicrosecondsSinceEpoch(int.parse(timestamp) * 1000);
  var diff = date.difference(now);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else {
    if (diff.inDays == 1) {
      time = '${diff.inDays}DAY AGO';
    } else {
      time = '${diff.inDays}DAYS AGO';
    }
  }

  return time;
}
