import 'package:audre/providers/user_provider.dart';
import 'package:audre/services/note_api_services.dart';
import 'package:audre/services/note_graphql_services.dart';
import 'package:flutter/material.dart';

class CommentBubble extends StatelessWidget {
  final dynamic comment;
  const CommentBubble({super.key, required this.comment});
  @override
  Widget build(BuildContext context) {
    print(comment['created_at']);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(comment['user']['profile_pic']),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment['user']['username'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4.0),
                Text(comment['comment'],
                    style:
                        const TextStyle(fontSize: 15.0, color: Colors.white)),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Text(
                      comment[
                          'created_at'], // Replace with the timestamp of the comment.
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                    const SizedBox(width: 4.0),
                    const Icon(
                      Icons.favorite_border,
                      size: 12.0,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
