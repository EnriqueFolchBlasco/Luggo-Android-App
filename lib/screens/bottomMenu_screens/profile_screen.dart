import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:luggo/services/shared_prefs_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luggo/utils/notification_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    final data = await _prefsService.getOfflineUserData();
    if (data == null) return;

    final prefs = await SharedPreferences.getInstance();
    String? imageUrl = prefs.getString('profileImageUrl');
    final uid = data['uid'];

    if ((imageUrl == null || imageUrl.isEmpty) && uid != null) {
      try {
        final userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        imageUrl = userDoc.data()?['profileImage'];

        if (imageUrl != null && imageUrl.isNotEmpty) {
          await prefs.setString('profileImageUrl', imageUrl);
        }
      } catch (_) {}
    }

    final connectivity = await Connectivity().checkConnectivity();
    final hasInternet = connectivity != ConnectivityResult.none;

    setState(() {
      _username = data['username'] ?? '';
      _email = data['email'] ?? '';
      _networkImageUrl =
          (hasInternet && imageUrl != null && imageUrl.isNotEmpty)
              ? imageUrl
              : null;
    });
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

      NotificationManager.agregar('noConnection.photoSuccess'.tr());

      // pa guardar url
      await prefs.setString('profileImageUrl', downloadUrl);
    } catch (e) {
      NotificationManager.agregar('noConnection.photoError'.tr());
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
                              _networkImageUrl != null
                                  ? NetworkImage(_networkImageUrl!)
                                  : const AssetImage(
                                        'assets/images/LuggoIconoColor.png',
                                      )
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




Future<void> pickImage() async {
  final connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.none) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
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
    imageQuality: 85,
  );

  if (pickedFile != null) {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      cropStyle: CropStyle.circle,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Edit Avatar',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Edit Avatar',
        ),
      ],
    );

    if (croppedFile != null) {
      await uploadProfileImage(File(croppedFile.path));
    }
  }
}


}
