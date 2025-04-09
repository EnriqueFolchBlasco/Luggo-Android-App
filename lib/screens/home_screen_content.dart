import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:luggo/utils/constants.dart';

//************************************************************
// TO DO fer la db local q almacena mudances (items count)
//************************************************************

class HomeScreenContent extends StatelessWidget {

  //CAMBAIR EL MENSATGE DE HOLA DEPENGUENT DEL DIA HGORA
  String _calcularMensatgeBenbinguda() {
    final hora = DateTime.now().hour;

    if (hora >= 6 && hora < 13) {
      //print(hora.toString());
      return 'greeting1';  //dia
    } else if (hora >= 13 && hora < 21) { 
      return 'greeting2'; //vesprada
    } else {
      return 'greeting3'; //nit
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          //************************************************************
          // DIR MATI VESPRA O NIT + AVATAR
          //************************************************************
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _calcularMensatgeBenbinguda().tr(),
                      style: const TextStyle(
                        fontFamily: 'ClashDisplay',
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'userName'.tr(),
                      style: const TextStyle(
                        fontFamily: 'ClashDisplay',
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.black.withAlpha((0.05 * 255).round()),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/LuggoIconoColor.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          //************************************************************
          // PART DE LES CARTES
          //************************************************************
          Text(
            'yourMoves'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Helvetica',
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [

                //TO DO CREAR ANTES QUE TOT TARGETA DE AÑADIR MUDANZA
                _mudanzaCard(context, 'Mudanza Bilbao', 64, 0.75),
                const SizedBox(width: 12),
                _mudanzaCard(context, 'Mudanza Castellón', 32, 0.4),
              ],
            ),
          ),
          const SizedBox(height: 32),

          //************************************************************
          // SERVEIS
          //************************************************************
          Text(
            'needMoveHelp'.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Helvetica',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'moveHelpText'.tr(),
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w400,
              fontFamily: 'Helvetica',
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  //************************************************************
  // CARTA ESTRUCTURA
  // TODO FER EL PRESS/ON TAP
  //************************************************************

  Widget _mudanzaCard(BuildContext context, String title, int items, double progress,) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.primaryColor.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Helvetica',
              fontSize: 16,
            ),
          ),

          const Spacer(),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  '$items items',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Text('progressLabel'.tr(), style: TextStyle(fontSize: 12)),
            ],
          ),

          const SizedBox(height: 6),

          //************************************************************
          // BARRAA
          //************************************************************
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            color: AppColors.primaryColor,
            minHeight: 6,
            borderRadius: BorderRadius.circular(10),
          ),

          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text('${(progress * 100).round()}%',
              style: const TextStyle(fontSize: 12),
            ),
          ),

          //************************************************************
          // TODO FICAR BOTONS DE SERVEIS PER A PAGAR
          //************************************************************


        ],
      ),
    );
  }
}
