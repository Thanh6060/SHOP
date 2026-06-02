import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio  ;
import '../../utils/constants/apis.dart';
import '../../utils/constants/keys.dart';

class StripServices extends GetxController{
  static StripServices get instance => Get.find();
  final _dio = dio.Dio();

  Future<dynamic> createPaymentIntent(String currency, int amount) async{
    try {


      String url = UApiUrls.stripeCreateIntents;
      final data = {
        'currency': currency,
        'amount': amount,

        'payment_method_types[]': 'card',
      };
      dio.Response response = await _dio.post(
          url, data: data, options: dio.Options(
          headers: {
            'Authorization': 'Bearer ${UKeys.stripeSecretKey}',
            'Content-Type': 'application/x-www-form-urlencoded'
          }
      ));
      if (response.statusCode == 200) {
        return response.data;
      }
    }catch(e){
      throw 'Something went wrong while creating payment intents ';
    }
  }

  Future<void> initPaymentSheet(String currency,int amount) async {
    try {
      // 1. Create payment intent on the server
      final data = await createPaymentIntent(currency, amount);
      log(data.toString() as num);

      // 2. Create billing details (optional)


      // 3. Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Main params
          customFlow: true,
          paymentIntentClientSecret: data['client_secret'],
          merchantDisplayName: 'Shopping App',
          // Customer params
          customerId: data['id'],

          // Return URL for redirect-based payment methods
         // returnURL: 'flutterstripe://redirect',
          // Extra options
         // primaryButtonLabel: 'Pay now',
          applePay: PaymentSheetApplePay(
            merchantCountryCode: 'US',
          ),
          googlePay: PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: true,
          ),
          style: ThemeMode.dark,
         // billingDetails: billingDetails,
        ),
      );

    } catch (e) {

      throw 'Something went wrong while initializing payment sheet';
    }
  }

  Future<void> showPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    }on StripeException catch (e) {
      switch(e.error.code){

        case FailureCode.Canceled:
          throw 'Payment sheet canceled';
        case FailureCode.Failed:
          throw 'Payment sheet failed';
        case FailureCode.Timeout:
          throw 'Payment sheet timed out';
        case FailureCode.Unknown:
          throw 'Payment sheet unknown error';

      }
    }catch(e){
      throw 'Something went wrong while presenting payment sheet';

    }
  }



}