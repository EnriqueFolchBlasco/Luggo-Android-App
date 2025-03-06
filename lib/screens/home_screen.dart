import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  // Log the user out of the app
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        title: Text('Home Screen'),  // Title of the app bar
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),  // Log out the user when button is pressed
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Center the content vertically
          children: <Widget>[
            Text(
              'Welcome to the Home Screen!',  // Greeting text
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),  // Call _logout when button is pressed
              child: Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
