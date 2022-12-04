import 'package:flutter/material.dart';

import 'report.dart';


void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {          
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            fontSize: 20, 
            color: Colors.white
          ),
          headline1: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          caption: TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            color: Colors.yellow,
          ),
        )
      ),

      home: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(), // ขยายเต็มพื้นที่ Scaffold
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('images/cloud.gif'),
              fit: BoxFit.cover
            )
          ),
          child: const Report(),
        ),
      ),
    );
  }
}

