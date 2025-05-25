import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:luggo/screens/content_screens/service_screens/service_forms/donation_form.dart';
import 'package:luggo/screens/content_screens/service_screens/service_forms/labor_form.dart';
import 'package:luggo/screens/content_screens/service_screens/service_forms/recycling_form.dart';
import 'package:luggo/screens/content_screens/service_screens/service_forms/smallmove_form.dart';
import 'package:luggo/screens/content_screens/service_screens/service_forms/storepickup_form.dart';
import 'package:luggo/screens/content_screens/service_screens/service_forms/transport_form.dart';
import 'package:luggo/screens/content_screens/service_screens/service_forms/user_info_form.dart';
import 'package:luggo/screens/content_screens/service_screens/service_purchasedetails_screen.dart';
import 'package:luggo/screens/sideBar_screens/sidebar_screen.dart';
import 'package:luggo/services/shared_prefs_service.dart';
import 'package:luggo/services/stripe_service.dart';
import 'package:luggo/utils/constants.dart';
import 'package:luggo/utils/utils_widgets/barra_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String serviceType;

  const ServiceDetailsScreen({super.key, required this.serviceType});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();

}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  final _clauFormulari = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dniController = TextEditingController();
  final _pickupController = TextEditingController();
  final _dropoffController = TextEditingController();
  final _notesController = TextEditingController();
  final _materialsController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          padding: const EdgeInsets.only(left: 18),
          icon: const Icon(Icons.menu),
          iconSize: 36,
          onPressed: () async {

            final result = await Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (_, __, ___) => const SideBarScreen(),
                transitionsBuilder: (_, animation, __, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
            );

            //refrescar tot en idioma cambiat
            if (result == true) {
              setState(() {});
            }

          },
        ),
        title: Image(
          image: AssetImage('assets/images/LuggoColor_noBackground.png'),
          height: 28,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      splashRadius: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Center(
                  child: Text(
                    widget.serviceType.tr(),
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

                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                    bottom: 10,
                  ),
                  child: BarraProgressoAmazon(1),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      UserInfoForm(
                        nombreController: _nameController,
                        dniController: _dniController,
                        telefonoController: _phoneController,
                        emailController: _emailController,
                      ),

                      _seleccionarTipoDeForm(),
                    ],
                  ),
                )
                

              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          MediaQuery.of(context).viewPadding.bottom + 16,
        ),

        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {

              bool estaTotPlenat() {
                return _nameController.text.trim().isNotEmpty &&
                    _emailController.text.trim().isNotEmpty &&
                    _phoneController.text.trim().isNotEmpty &&
                    _pickupController.text.trim().isNotEmpty &&
                    _dateController.text.trim().isNotEmpty &&
                    _timeController.text.trim().isNotEmpty;
              }


              //combrobar camps fulls
              if (!estaTotPlenat()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'pleaseFillRequiredFields'.tr(),
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: AppColors.primaryColor,
                  ),
                );
                return;
              }


              // POP UP MODALS De pagar

              bool paymentSuccess = await StripeService.instance.makePayment(
                context,
                _getPreuServici(widget.serviceType),
                'eur',
              );

              if (paymentSuccess) {
                
                //guardar en firebase
                putjarFirebaseServiciPagat();

                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder:
                        (_, __, ___) => ServicePurchaseDetailsScreen(
                          serviceType: widget.serviceType,
                        ),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      'payment_failed'.tr(),
                      style: const TextStyle(color: Colors.black),
                    ),
                    backgroundColor: const Color(0xFFF4F6FA),
                  ),
                );
              }
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'next'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      
    );
  }

  Future<void> putjarFirebaseServiciPagat() async {
    final uid = await SharedPrefsService().getUserUUID();

    final servicioData = {
      'userId': uid,
      'tipo': widget.serviceType,
      'estado': "Awaiting approval",
      'nombre': _nameController.text.trim(),
      'dni': _dniController.text.trim(),
      'telefono': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
      'ubicacion': _pickupController.text.trim(),
      'destino': _dropoffController.text.trim(),
      'detallesTransporte': _notesController.text.trim(),
      'materiales': _materialsController.text.trim(),
      'fecha': _dateController.text.trim(),
      'hora': _timeController.text.trim(),
      'pago': _getPreuServici(widget.serviceType),
      'creacionTimestamp': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('services')
        .add(servicioData);
    
  }

  double _getPreuServici(String type) {
    switch (type) {
      case 'transportService':
        return 20.0;

      case 'donateService':
        return 10.0;

      case 'recyclingService':
        return 15.0;

      case 'storePickupService':
        return 12.0;

      case 'smallMoveService':
        return 25.0;

      case 'laborService':
        return 18.0;

      default:
        return 10.0;
    }
  }


  Widget _seleccionarTipoDeForm() {
    switch (widget.serviceType) {
      case 'transportService':
        return TransportForm(
          clauFormulari: _clauFormulari,
          pickupController: _pickupController,
          dropoffController: _dropoffController,
          dateController: _dateController,
          timeController: _timeController,
        );

      case 'donateService':
        return DonationForm(
          clauFormulari: _clauFormulari,
          pickupController: _pickupController,
          notesController: _notesController,
          dateController: _dateController,
          timeController: _timeController,
        );

      case 'recyclingService':
        return RecyclingForm(
          clauFormulari: _clauFormulari,
          pickupController: _pickupController,
          materialsController: _materialsController,
          dateController: _dateController,
          timeController: _timeController,
        );

      case 'storePickupService':
        return StorePickupForm(
          clauFormulari: _clauFormulari,
          pickupController: _pickupController,
          notesController: _notesController,
          dateController: _dateController,
          timeController: _timeController,
        );

      case 'smallMoveService':
        return SmallMoveForm(
          clauFormulari: _clauFormulari,
          pickupController: _pickupController,
          dropoffController: _dropoffController,
          notesController: _notesController,
          dateController: _dateController,
          timeController: _timeController,
        );

      case 'laborService':
        return LaborForm(
          clauFormulari: _clauFormulari,
          addressController: _pickupController,
          jobController: _notesController,
          dateController: _dateController,
          timeController: _timeController,
        );

      default:
        return const Text('Unsupported service type');
    }
  }
}
