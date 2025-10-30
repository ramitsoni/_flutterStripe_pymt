import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stripe Payment")),
      body: Center(
        child: ElevatedButton(
          onPressed: payment,
          child: const Text("Subscribe Now"),
        ),
      ),
    );
  }

  Future<void> payment() async {
    try {
      // Step 1: Create PaymentIntent
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
          'Bearer <Add Stripe Secret key Here....>',  //This is demo purpose make sure secret code should be not present here for security reason
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'amount': '10000', // ₹100.00
          'currency': 'inr',
          'payment_method_types[]': 'card',
        },
      );

      paymentIntent = json.decode(response.body);

      if (paymentIntent == null || paymentIntent!['client_secret'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create payment intent')),
        );
        return;
      }

      // Step 2: Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.light,
          merchantDisplayName: 'VPN',
        ),
      );

      // Step 3: Present Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Payment successful!')),
      );

      paymentIntent = null;
    } catch (err) {
      debugPrint('Error: $err');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Payment failed: $err')),
      );
    }
  }
}
