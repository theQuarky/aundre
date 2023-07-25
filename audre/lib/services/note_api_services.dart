import 'package:audre/models/note_model.dart';

import 'rest_api_services.dart';

class NoteApiServices {
  // ignore: non_constant_identifier_names
  static Future<dynamic?> createNote(
      {required mediaUrl, required createdBy, required caption}) async {
    try {
      final response = await RestApiServices.postRequest('notes/create-note',
          {'media_url': mediaUrl, 'created_by': createdBy, 'caption': caption});
      return NoteModel.fromJson(response['note']);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<void> likeDislikeNote(
      {required noteId, required userId, required isLiked}) async {
    try {
      await RestApiServices.postRequest('notes/add-interaction', {
        'note_id': noteId,
        'created_by': userId,
        'type':
            isLiked != null ? (isLiked == true ? 'like' : 'dislike') : 'neutral'
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<void> addComment({
    required noteId,
    required userId,
    required comment,
  }) async {
    try {
      await RestApiServices.postRequest('notes/add-comment',
          {'note_id': noteId, 'created_by': userId, 'comment_text': comment});
    } catch (e) {
      print(e);
    }
  }
}
