import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 24),
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/pfp.png'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Column(
              children: [
                Text('created by', style: TextStyle(color: Colors.grey)),
                Text('Altamash Khan', style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          // ListTile(
          //   title: Text('Logout'),
          //   onTap: () {},
          //   leading: Icon(Icons.logout),
          // ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Become a modder?',
                hintText: 'Enter secret code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(onPressed: () {}, child: Text('Verify')),
          Expanded(child: SizedBox()),
          OutlinedButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 5,
              children: [Icon(Icons.exit_to_app_rounded), Text('Exit')],
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
