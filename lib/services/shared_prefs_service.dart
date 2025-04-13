import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {

  Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
  

  Future<void> saveOfflineLoginData(String uid, String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedInBefore', true);
    await prefs.setString('userUID', uid);
    await prefs.setString('username', username);
  }

  Future<Map<String, String>?> getOfflineUserData() async {
  final prefs = await SharedPreferences.getInstance();
  bool? loggedBefore = prefs.getBool('loggedInBefore');

  if (loggedBefore == true) {
    final uid = prefs.getString('userUID');
    final username = prefs.getString('username');

    if (uid != null && username != null) {
      return {'uid': uid, 'username': username};
    }
  }
  return null;
}

}
