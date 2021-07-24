import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class StripTransactionResponse {
  String message;
  bool success;
  StripTransactionResponse({this.message, this.success});
}

class StripService {
  static String apiBase = 'https://api.strip.com//v1';
  static String paymentApiUrl = '${StripService.apiBase}/payment_Intents';
  static String secret = 'sk_test_51Hw5onCSZOZugzpgDnlvkFJAZGzRzgOuHmAfDqaQSeuzkS9kPARUR7d0MKdNrDjQLbT6BWIWfQfbmNiGIPVSZhY200RsyL4MdS';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripService.secret}',
    'content-Type': 'application/x-www-form-urlencoded'
  };
  static init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51Hw5onCSZOZugzpgNvw4DPayvqyAAHw78cqRexEDCox8l0ZciRa2R27OnASpRo4s4GRgtZZowrRqjWJ9BrBYCrtV00wxY4IiBY",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  static Future<StripTransactionResponse> payViaExixtingCard(
     {String amount, String currency, CreditCard card}) async{
        
    try {
       var paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(card: card));
       var paymentIntent =await StripService.createPaymentIntent(amount, currency);
       var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
         clientSecret: paymentIntent['client_secret'],
         paymentMethodId: paymentMethod.id

       ));
       if (response.status =='succeeded'){
         return new StripTransactionResponse(
        message: 'Transaction successful', success: true);
       }
       else{
         return new StripTransactionResponse(
        message: 'Transaction failed', success: false);
       }
       
    } 
       on PlatformException catch (err){
         return StripService.getPlatformExceptionErrorResults(err);

       }catch (err){
      return new StripTransactionResponse(
        message: 'Transaction failed: ${err.toString()}', success: false);
    }
  }
  static getPlatformExceptionErrorResults(err){
    String message = 'something went wrong';
    if (err.code == 'cancelled'){
      message = 'Transaction cancelled';
    }
    return  new StripTransactionResponse(
    message: message,
    success: false );
  }
  static Future<Map<String,dynamic>>createPaymentIntent(String amount, String currency) async{
    try{
      Map<String, dynamic> body = {
        'amount': amount, 
        'currency': currency,
        'Payment_method_types[]': 'card'
      };
      var response = await http.post(
        Uri.parse(StripService.paymentApiUrl),
        body: body,
        headers: StripService.headers
      );
     return jsonDecode(response.body);
    }catch(err){
      print('err charging user: ${err.toString()}');
    }
    return null;
  }

  static Future<StripTransactionResponse> payWithNewCard({
    String amount,
    String currency,
  }) async{
    try {
       var paymentMethod = await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());
       print(jsonEncode(paymentMethod));
       var paymentIntent =await StripService.createPaymentIntent(amount, currency);
       var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
         clientSecret: paymentIntent['client_secret'],
         paymentMethodId: paymentMethod.id

       ));
       if (response.status =='succeeded'){
         return new StripTransactionResponse(
        message: 'Transaction successful', success: true);
       }
       else{
         return new StripTransactionResponse(
        message: 'Transaction failed', success: false);
       }
       
    } 
       on PlatformException catch (err){
         return StripService.getPlatformExceptionErrorResults(err);

       }catch (err){
      return new StripTransactionResponse(
        message: 'Transaction failed: ${err.toString()}', success: false);
    }
  }
  static getPlatformExceptionErrorResultss(err){
    String message = 'something went wrong';
    if (err.code == 'cancelled'){
      message = 'Transaction cancelled';
    }
    return  new StripTransactionResponse(
    message: message,
    success: false );
  }
  static Future<Map<String,dynamic>>createPaymentIntents(String amount, String currency) async{
    try{
      Map<String, dynamic> body = {
        'amount': amount, 
        'currency': currency,
        'Payment_method_types[]': 'card'
      };
      var response = await http.post(
        Uri.parse(StripService.paymentApiUrl),
        body: body,
        headers: StripService.headers
      );
     return jsonDecode(response.body);
    }catch(err){
      print('err charging user: ${err.toString()}');
    }
    return null;
  }
}

