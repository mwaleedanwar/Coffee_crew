import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/screens/home/brew_list.dart';
import 'package:brew_crew/screens/home/settings_form.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: const SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Brew>>.value(
      initialData: [],
      value: DatabaseService('').brews,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: const Text('Brew Crew'),
          elevation: 0,
          backgroundColor: Colors.brown[400],
          actions: [
            TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: const Icon(Icons.person),
              label: const Text('Logout'),
              style: TextButton.styleFrom(primary: Colors.black),
            ),
            TextButton.icon(
                onPressed: () => _showSettingsPanel(),
                icon: const Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                label: const Text(
                  'Settings',
                  style: TextStyle(color: Colors.black),
                ))
          ],
        ),
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/coffee_bg.png'),
              fit: BoxFit.cover,
            )),
            child: BrewList()),
      ),
    );
  }
}
