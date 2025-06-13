import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//https://docs.stripe.com/testing 4242 4242 4242 4242 targeta FAKE
//https://dashboard.stripe.com/test/dashboard

class StripeService {

  StripeService._();
  final stripePublishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'];
  final stripeSecretKey = dotenv.env['STRIPE_SECRET_KEY'];

  static final StripeService instance = StripeService._();

  Future<bool> makePayment(BuildContext context, double cantidadEuros, String currency) async {
    try {
      int cantidadCentimos = (cantidadEuros * 100).round();
  
      String? paymentIntentClientSecret = await _createPaymentIntent(cantidadCentimos, currency);
  
      if (paymentIntentClientSecret == null) return false;
  
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          style: ThemeMode.light,
          merchantDisplayName: 'Luggo',
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'ES',
          ),
        ),
      );
  
      return await _confirmPayment();
  
    } catch (e) {
      //print('error $e');
      return false;
    }
  } 


  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();

      // OBLIGAR EN TARGETA ES: final data = "amount=${amount.toString()}&currency=$currency&payment_method_types[]=card";
      final data = {
        "amount": amount,
        "currency": currency,
      };

      final response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: "application/x-www-form-urlencoded",
          headers: {"Authorization": "Bearer ${stripeSecretKey}"},
        ),
      );


      if (response.statusCode == 200 && response.data != null) {
        return response.data['client_secret'];
      } else {
        return null;
      }
    } on DioException catch (e) {
      //print('🧊🧊🧊🧊🧊error: ${e.response?.statusCode}');
      //print('🧊🧊🧊response: ${e.response?.data}');
    } catch (e) {
      //print('🧊🧊🧊eror $e');
    }

    return null;
  }

  int convertirAEurosCents(double euros) {
    return (euros * 100).round();
  }

  Future<bool> _confirmPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return true;
    } on StripeException catch (e) {
      //print('🧊error ${e.error.localizedMessage}');
      return false;
    } catch (e) {
      //print('🧊🧊error $e');
      return false;
    }
  }

}
