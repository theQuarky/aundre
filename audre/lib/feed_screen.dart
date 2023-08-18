import 'package:audre/components/full_noteview.dart';
import 'package:audre/components/noteview_widget.dart';
import 'package:audre/models/note_model.dart';
import 'package:audre/models/user_model.dart';
import 'package:audre/providers/user_provider.dart';
import 'package:audre/services/note_graphql_services.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  UserModal? user = UserProvider.getUser();
  int page = 0;
  List<String>? noteIds = [];
  NoteModel? note;

  Future<void> _onPageChanged() async {
    setState(() {
      page = page + 1;
    });
    NoteGraphQLService.getFeedData(userId: user!.uid ?? " ", page: page)
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        noteIds = [...noteIds!, ...value];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("FeedScreen");
    _onPageChanged();
  }

  @override
  Widget build(BuildContext context) {
    if (noteIds == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            children: [
              const Text("Feed", style: TextStyle(fontSize: 30)),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/chat-list');
                  },
                  icon: const Icon(Icons.message_rounded,
                      size: 30, color: Colors.black)),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: PageView.builder(
            itemCount: noteIds!.length,
            pageSnapping: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return NoteView(
                noteId: noteIds![index],
              );
            },
            onPageChanged: (value) {
              if (value == noteIds!.length - 1) {
                _onPageChanged();
              }
            },
          ),
        ),
      ],
    );
  }
}
