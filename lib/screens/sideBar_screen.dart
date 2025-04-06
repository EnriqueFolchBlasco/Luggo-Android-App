import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:luggo/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBarScreen extends StatelessWidget {
  const SideBarScreen({super.key});

  //************************************************************
  // CONTROL DE LOG OUT
  //************************************************************

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //************************************************************
      // COPIA DE LA UPBAR (Efecte)
      //************************************************************

      backgroundColor: Color.fromRGBO(230, 235, 242, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(Icons.close, size: 40, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset('assets/LuggoColor2.png', height: 30),
            Spacer(),
            Spacer(),
          ],
        ),
      ),

      //************************************************************
      // BODY DE L'APP (OPCIONS)
      //************************************************************
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.room_preferences_outlined),
              title: Text('Preferencias',
              style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 18, fontWeight: FontWeight.w400),
              ),
              onTap: () {

              },
            ),
            Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.settings),
              title: Text('Opciones',
              style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 18, fontWeight: FontWeight.w400),
              ),
              onTap: () {

              },
            ),
            Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.privacy_tip),
              title: Text('Privacidad',
              style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 18, fontWeight: FontWeight.w400),
              ),
              onTap: () {

              },
            ),
            Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.help),
              title: Text('Ayuda',
              style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 18, fontWeight: FontWeight.w400),
              ),
              onTap: () {

              },
            ),
            Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.logout),
              title: Text(
                'Log out',
                style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 18, fontWeight: FontWeight.w400),
              ),
              onTap: () {
                _logout(context);
              },
            ),

            Divider(),
          ],
        ),
      ),
    );
  }
}
