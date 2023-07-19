import 'package:audre/models/note_model.dart';

import 'rest_api_services.dart';

class NoteApiServices {
  // ignore: non_constant_identifier_names
  static Future<dynamic?> createNote(
      {required media_url, required created_by}) async {
    try {
      final response = await RestApiServices.postRequest('notes/create-note', {
        'media_url': media_url,
        'created_by': created_by,
      });
      return NoteModel.fromJson(response['note']);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
