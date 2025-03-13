import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:luggo/screens/login_screen.dart';
import 'package:luggo/screens/services_screen.dart';
import 'package:luggo/screens/chats_screen.dart';
import 'package:luggo/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luggo/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Widget> _screens = <Widget>[
    HomeScreenContent(),
    ServicesScreen(),
    ChatsScreen(),
    SettingsScreen(),
  ];

  List<Type> _screensWithoutBottomNav = [
    SettingsScreen,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isRemembered', false);
    prefs.setString("userUID", "none");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<String?> _getUserUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userUID');
  }

  @override
  Widget build(BuildContext context) {
    bool _hideBottomNav = _screensWithoutBottomNav.contains(_screens[_selectedIndex].runtimeType);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<String?>(
          future: _getUserUID(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Welcome to the Home Screen!\nUID: ${snapshot.data}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  _screens[_selectedIndex],
                ],
              );
            } else {
              return Text('No UID found');
            }
          },
        ),
      ),

      bottomNavigationBar: _hideBottomNav ? null : BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              backgroundColor: AppColors.primaryColor,
              selectedItemColor: AppColors.primaryColor,
              unselectedItemColor: const Color.fromARGB(255, 133, 155, 192),
              showUnselectedLabels: true,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.business),
                  label: 'Services',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'This is the Home Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
