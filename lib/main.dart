import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'homescreen.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey= "<Add your stripe Publishable Key Here...>";  //we can add add key here but recommendable put somewhere secure place

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: HomeScreen(),
    );
  }
}

