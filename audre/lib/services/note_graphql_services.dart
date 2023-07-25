import 'package:audre/models/note_model.dart';
import 'package:audre/services/graphql_services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class NoteGraphQLService {
  NoteGraphQLService();

  static Future<dynamic> getNote({required String noteId}) async {
    final QueryOptions options = QueryOptions(
      document: gql('''
            query getNoteById(\$note_id: String!) {
              getNoteById(note_id: \$note_id) {
                  note_id
                  media_url
                  tags
                  caption
                  interactions{
                    interaction_id
                    note_id
                    user_id
                    type
                    created_at
                  }
                  like_count
                  comment_count
                  dislike_count
                  is_private
                  is_delete
                  created_at
                  updated_at
                  dislike_count
              }
            }
        '''),
      variables: {'note_id': noteId},
    );

    final QueryResult result = await client.value.query(options);
    if (result.hasException) {
      // throw result.exception!;
      return null;
    }
    if (result.data!['getNoteById'] == null) {
      return null;
    }
    return NoteModel.fromJson(result.data!['getNoteById']);
  }

  static Future<dynamic> getComments({required String noteId}) async {
    final QueryOptions options = QueryOptions(
      document: gql('''
            query getNoteComments(\$note_id: String!) {
              getNoteComments(note_id: \$note_id) {
                  comment_id
                  note_id
                  user_id
                  comment
                  user {
                    username
                    profile_pic
                  }
                  created_at
                  updated_at
              }
            }
        '''),
      variables: {'note_id': noteId},
    );

    final QueryResult result = await client.value.query(options);
    print(result);
    if (result.hasException) {
      // throw result.exception!;
      return null;
    }
    if (result.data!['getNoteComments'] == null) {
      return null;
    }
    return result.data!['getNoteComments'];
  }
}
