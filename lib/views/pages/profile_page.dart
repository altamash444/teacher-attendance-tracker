import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SharedPreferencesAsync modderPref = SharedPreferencesAsync();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
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
      ),
    );
  }
}
