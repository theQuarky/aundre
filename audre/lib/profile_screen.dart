import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('logo.png'),
                ),
                const SizedBox(width: 10),
                Row(children: [
                  _buildStatColumn('Post', '23'),
                  _buildStatColumn('Followers', '23'),
                  _buildStatColumn('Following', '23'),
                ]),
                const SizedBox(width: 20),
              ],
            ),

            // const SizedBox(height: 20),
            // const Text(
            //   'Username',
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 10),
            // const Text(
            //   'Bio',
            //   style: TextStyle(
            //     fontSize: 18,
            //   ),
            // ),
            // const SizedBox(height: 20),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     // Handle Edit Profile button press
            //   },
            //   child: const Text('Edit Profile'),
            // ),
            // const SizedBox(height: 20),
            // GridView.count(
            //   shrinkWrap: true,
            //   crossAxisCount: 3,
            //   crossAxisSpacing: 2,
            //   mainAxisSpacing: 2,
            //   children: List.generate(
            //     9,
            //     (index) => Image.asset(
            //       'assets/post_image_$index.jpg',
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String count) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
