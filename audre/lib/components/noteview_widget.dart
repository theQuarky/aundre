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
      print('object: $value');
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
        return SingleChildScrollView(
          child: Container(
              color: Colors.black,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close_rounded,
                              color: Colors.white)),
                      const Text('Comments',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.send_rounded,
                              color: Colors.transparent)),
                    ],
                  ),
                  const Divider(color: Colors.white, thickness: 2),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                        ),
                        ...comments
                            .map((e) => CommentBubble(
                                  comment: e,
                                ))
                            .toList()
                      ],
                    ),
                  ), // Add your comment list UI here,
                  const Divider(color: Colors.white, thickness: 2),
                  isCommentLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 10),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(
                                    UserProvider.getUser()?.profile_pic ?? ''),
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
                                    style: const TextStyle(color: Colors.white),
                                    maxLines:
                                        null, // Allow the TextField to have unlimited lines (expand vertically)
                                    decoration: const InputDecoration(
                                      hintText: 'Add a comment...',
                                      hintStyle: TextStyle(color: Colors.white),
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
                                NoteApiServices.addComment(
                                        noteId: note!.noteId,
                                        userId: UserProvider.getUser()!.uid,
                                        comment: _commentController.text)
                                    .then((value) {
                                  NoteGraphQLService.getComments(
                                          noteId: note!.noteId)
                                      .then((value) {
                                    setState(() {
                                      comments = value;
                                    });
                                    setState(() {
                                      isCommentLoading = false;
                                    });
                                    _commentController.clear();
                                  });
                                });
                              },
                              icon: const Icon(Icons.send_rounded,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                ],
              )),
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
    print(widget.comment);
    final comment = widget.comment;
    final user = comment['user'];
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
                  Text(comment['comment'],
                      style: const TextStyle(color: Colors.white)),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
