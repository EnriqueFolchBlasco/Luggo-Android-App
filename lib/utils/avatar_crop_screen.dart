import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:luggo/utils/constants.dart';

class AvatarCropScreen extends StatefulWidget {
  final File imageFile;
  final Function(Uint8List croppedBytes) onCropped;

  const AvatarCropScreen({required this.imageFile, required this.onCropped, Key? key}) : super(key: key);

  @override
  State<AvatarCropScreen> createState() => _AvatarCropScreenState();
}

class _AvatarCropScreenState extends State<AvatarCropScreen> {
  final GlobalKey _cropKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              'assets/images/LuggoColor2.png',
              height: 30,
            ),
            const Spacer(),
            const Spacer(),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          
          const SizedBox(height: 24),
          Center(
            child: ClipOval(
              child: RepaintBoundary(
                key: _cropKey,
                child: Container(
                  width: 250,
                  height: 250,
                  color: Colors.grey[300],
                  child: InteractiveViewer(
                    boundaryMargin: const EdgeInsets.all(80),
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: Image.file(
                      widget.imageFile,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
                onPressed: _cropImage,
                child: Text(
                  'cropUpload'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Helvetica',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _cropImage() async {
    try {
      final boundary = _cropKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List bytes = byteData!.buffer.asUint8List();

      widget.onCropped(bytes);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error cropping avatar')),
      );
    }
  }
}
