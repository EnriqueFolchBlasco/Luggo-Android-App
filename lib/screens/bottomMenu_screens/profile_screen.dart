import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:luggo/services/shared_prefs_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luggo/utils/notification_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  String _username = '';
  String _email = '';
  final SharedPrefsService _prefsService = SharedPrefsService();
  String? _networkImageUrl;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    //final prefs = await SharedPreferences.getInstance();
    final data = await _prefsService.getOfflineUserData();

    if (data != null) {



      final uid = data['uid'];
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final imageUrl = userDoc.data()?['profileImage'];

      setState(() {
        _username = data['username'] ?? '';
        _email = data['email'] ?? '';
        if (imageUrl != null) {
          _imageFile = null;
          _networkImageUrl = imageUrl;
        }
      });
    }
  }

  Future<void> pickImage() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    
    if (connectivityResult == ConnectivityResult.none) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: Text('noConnection.title'.tr()),
                content: Text('noConnection.message'.tr()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('noConnection.ok'.tr()),
                  ),
                ],
              ),
        );
      }

      return;
    }

    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (pickedFile != null) {
      File image = File(pickedFile.path);

      setState(() {
        _imageFile = image;
      });

      await uploadProfileImage(image);
    }
  }

  Future<void> uploadProfileImage(File image) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userUID');

    if (uid == null) return;

    try {
      final storageRef = FirebaseStorage.instance.ref().child(
        'profile_pictures/$uid.jpg',
      );
      await storageRef.putFile(image);
      final downloadUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'profileImage': downloadUrl,
      }, SetOptions(merge: true));

      NotificationManager.agregar(
        'noConnection.photoSuccess'.tr(),
      );

      // pa guardar url
      await prefs.setString('profileImageUrl', downloadUrl);

      //descarrgea lcoal
      try {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/avatar.jpg';
        final response = await http.get(Uri.parse(downloadUrl));
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        //print('✅ guardat en: $filePath');
      } catch (e) {
        //print('❌ problemaaa: $e');
      }
    } catch (e) {
      NotificationManager.agregar(
        'noConnection.photoError'.tr(),
      );
      //print("❌ problemaaa no a pujat: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color luggoBlue = Color(0xFF2B68FF);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SizedBox.expand(
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              _imageFile != null
                                  ? FileImage(_imageFile!)
                                  : (_networkImageUrl != null
                                          ? NetworkImage(_networkImageUrl!)
                                          : const AssetImage(
                                            'assets/images/LuggoIconoColor.png',
                                          ))
                                      as ImageProvider,

                          backgroundColor: Colors.grey[300],
                        ),
                        GestureDetector(
                          onTap: pickImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: luggoBlue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 3,
                                  offset: Offset(1, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _username,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _email,
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
