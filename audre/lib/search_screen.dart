import 'package:audre/models/user_model.dart';
import 'package:audre/other_user_profile_screen.dart';
import 'package:audre/providers/user_provider.dart';
import 'package:audre/services/user_api_services.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<UserModal> users = [];
  Future<void> searchUsers(String name) async {
    try {
      List<UserModal> users = await UserApiServices.searchUsers(
          name: name, uid: FirebaseUserProvider.getUser()!.uid);

      setState(() {
        this.users.clear();
        this.users.addAll(users);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: _searchController,
            onChanged: (value) {
              if (value.length > 3) {
                searchUsers(value);
              }
            },
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                UserModal user = users[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/profile',
                        arguments: user.uid);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.profile_pic ??
                            'https://robohash.org/${user.username}}'),
                      ),
                      title: Text(user.name ?? ''),
                      subtitle: Text(user.username ?? ''),
                      // title: Text(user.name),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
