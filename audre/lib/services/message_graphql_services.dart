import 'package:audre/services/graphql_services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MessagesGraphQLService {
  MessagesGraphQLService();

  static Future<dynamic> getMessages(
      {required String uid, int page = 0}) async {
    final QueryOptions options = QueryOptions(
      document: gql('''
            query getMessages(\$uid: String!, \$page: Int!) {
              getMessages(uid: \$uid, page: \$page) {
                message_id
                chat_id
                sender_id
                partner_id
                message
                sender{
                  uid
                  username
                  profile_pic
                }
                created_at
              }
            }
        '''),
      variables: {'uid': uid, 'page': page},
    );
    final QueryResult result = await client.value.query(options);
    if (result.hasException) {
      return null;
    }
    if (result.data!['getMessages'] == null) {
      return null;
    }
    return result.data!['getMessages'];
  }

  static Future<List<Map<String, dynamic>>?> getChats(
      {required String uid}) async {
    final QueryOptions options = QueryOptions(
      document: gql('''
            query getChats(\$uid: String!) {
              getChats(uid: \$uid) {
                chat_id
                partner_id
                partner{
                  uid
                  username
                  profile_pic
                }
                last_message
                last_message_time
              }
            }
        '''),
      variables: {'uid': uid},
    );
    final QueryResult result = await client.value.query(options);
    if (result.hasException) {
      return null;
    }
    if (result.data!['getChats'] == null) {
      return null;
    }
    return result.data!['getChats'].map<Map<String, dynamic>>((e) {
      return {
        'chat_id': e['chat_id'],
        'partner_id': e['partner_id'],
        'partner': e['partner'],
        'last_message': e['last_message'],
        'last_message_time': e['last_message_time'],
      };
    }).toList();
  }
}
