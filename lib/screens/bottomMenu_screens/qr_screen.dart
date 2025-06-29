import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:luggo/utils/constants.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:luggo/services/database_service.dart';

class EscaneadorDeItemsScreen extends StatefulWidget {
  const EscaneadorDeItemsScreen({super.key});

  @override
  State<EscaneadorDeItemsScreen> createState() =>
      _EscaneadorDeItemsScreenState();
}

class _EscaneadorDeItemsScreenState extends State<EscaneadorDeItemsScreen> {
  bool escaneado = false;

  
  void _qrDetectat(BarcodeCapture capture) async {
    if (escaneado || capture.barcodes.isEmpty) {
      return;
    }

    setState(() {
      escaneado = true;
    });

    final barcode = capture.barcodes.first;
    final codeQR = barcode.rawValue;
    //print('🤞🧊🧊🧊👌👌💀💀🤓👆: $codeQR');

    if (codeQR == null) {
      _mensatgePop('error'.tr(), 2);
      await _cooldownAntiSpamError();
      return;
    }

    final partes = codeQR.split(':');
    if (partes.length != 2) {
      _mensatgePop('error'.tr(), 2);
      await _cooldownAntiSpamError();
      return;
    }

    final mudanzaId = int.tryParse(partes[0]);
    final itemId = int.tryParse(partes[1]);

    if (mudanzaId == null || itemId == null) {
      _mensatgePop('error'.tr(), 2);
      await _cooldownAntiSpamError();
      return;
    }

    final db = await DatabaseService.getDatabase();
    final item = await db.itemDao.obtenerItemPorId(itemId);

    if (item != null && item.mudanzaId == mudanzaId) {
      await db.itemDao.actualizarItem(item.copyWith(gotIt: true));
      if (mounted) {
        _mensatgePop('qrCorrecte'.tr(), 1);
      }
      await _cooldownAntiSpamError();
    } else {
      _mensatgePop('error'.tr(), 2);
      await _cooldownAntiSpamError();
    }
  }



  Future<void> _cooldownAntiSpamError() async {
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        escaneado = false;
      });
    }
  }

  void _mensatgePop(String message, int tipo) {
    //1 green
    //2 red

    if (!mounted){
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: tipo == 1
            ? const Color.fromARGB(255, 0, 255, 0)
            : const Color.fromARGB(255, 255, 0, 0)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),

      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Center(
            child: Text(
              'qrTitle'.tr(),
              style: const TextStyle(
                fontFamily: 'clashDisplay',
                color: AppColors.primaryColor,
                fontSize: 28,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.fromLTRB(40, 8, 40, 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'qrInfoHelp'.tr(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Helvetica',
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          //******************************************** */
          // MOBILE SCANNER CONTROLLER DINS DE CAIXETA
          //******************************************** */
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: AppColors.primaryColor, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),

                child: MobileScanner(
                  controller: MobileScannerController(
                    facing: CameraFacing.back,
                  ),
                  
                  onDetect: _qrDetectat,
                ),

              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            "qrIndicaciones".tr(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Helvetica',
            ),
          ),
        ],
      ),
    );
  }
}
