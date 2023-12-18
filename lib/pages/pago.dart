import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:parkit_now/utils/globals.dart' as globals;
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';


class PagoPage extends StatefulWidget {
  const PagoPage({super.key});

  @override
  State<PagoPage> createState() => _PagoPageState();
}


class _PagoPageState extends State<PagoPage> {
  Future<Map<String, dynamic>> crearPreferencia() async {
    var mp = MP(globals.mpClientID, globals.mpClientSecret);
    var preference = {
        "items": [
            {
                "title": "Test",
                "quantity": 1,
                "currency_id": "USD",
                "unit_price": 10.4
            }
        ]
    };

    var result = await mp.createPreference(preference);

    return result;
}
  void ejecutarMP() async{
    await crearPreferencia().then(
      (result){
        if(result!=null){
          var preferenceID = result['response']['id'];
          print(result);
        }
      }
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PayPal Checkout",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          TextButton(onPressed: ejecutarMP, child: Text('Mercado Pago'))
  
          // Center(
          //   child: TextButton(
          //     onPressed: () async {
          //       Navigator.of(context).push(MaterialPageRoute(
          //         builder: (BuildContext context) => PaypalCheckout(
          //           sandboxMode: true,
          //           clientId: globals.ppClientID,
          //           secretKey: globals.ppClientSecret,
          //           returnURL: "success.snippetcoder.com",
          //           cancelURL: "cancel.snippetcoder.com",
          //           transactions: const [
          //             {
          //               "amount": {
          //                 "total": '70',
          //                 "currency": "USD",
          //                 "details": {
          //                   "subtotal": '70',
          //                   "shipping": '0',
          //                   "shipping_discount": 0
          //                 }
          //               },
          //               "description": "The payment transaction description.",
          //               // "payment_options": {
          //               //   "allowed_payment_method":
          //               //       "INSTANT_FUNDING_SOURCE"
          //               // },
          //               "item_list": {
          //                 "items": [
          //                   {
          //                     "name": "Apple",
          //                     "quantity": 4,
          //                     "price": '5',
          //                     "currency": "USD"
          //                   },
          //                   {
          //                     "name": "Pineapple",
          //                     "quantity": 5,
          //                     "price": '10',
          //                     "currency": "USD"
          //                   }
          //                 ],
          
          //                 // shipping address is not required though
          //                 //   "shipping_address": {
          //                 //     "recipient_name": "Raman Singh",
          //                 //     "line1": "Delhi",
          //                 //     "line2": "",
          //                 //     "city": "Delhi",
          //                 //     "country_code": "IN",
          //                 //     "postal_code": "11001",
          //                 //     "phone": "+00000000",
          //                 //     "state": "Texas"
          //                 //  },
          //               }
          //             }
          //           ],
          //           note: "Contact us for any questions on your order.",
          //           onSuccess: (Map params) async {
          //             print("onSuccess: $params");
          //           },
          //           onError: (error) {
          //             print("onError: $error");
          //             Navigator.pop(context);
          //           },
          //           onCancel: () {
          //             print('cancelled:');
          //           },
          //         ),
          //       ));
          //     },
          //     style: TextButton.styleFrom(
          //       backgroundColor: Colors.teal,
          //       foregroundColor: Colors.white,
          //       shape: const BeveledRectangleBorder(
          //         borderRadius: BorderRadius.all(
          //           Radius.circular(1),
          //         ),
          //       ),
          //     ),
          //     child: const Text('Checkout'),
          //   ),
          // ),
        ],
      ),
    );
  }
}