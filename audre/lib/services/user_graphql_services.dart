import 'package:audre/models/user_model.dart';
import 'package:audre/services/graphql_services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserGraphQLService {
  UserGraphQLService();

  static Future<UserModal?> getUser(String uid) async {
    final QueryOptions options = QueryOptions(
      document: gql('''
            query getUser(\$uid: String!) {
              getUser(uid: \$uid) {
                uid
                username
                name
                dob
                gender
                email
                profile_pic
                followers
                following
                requests
                pending_requests
                intro
                created_at
                updated_at
              }
            }
        '''),
      variables: {'uid': uid},
    );

    final QueryResult result = await client.value.query(options);
    if (result.hasException) {
      // throw result.exception!;
      return null;
    }
    if (result.data!['getUser'] == null) {
      return null;
    }
    return UserModal.fromJson(result.data!['getUser']);
  }
}
