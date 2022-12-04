import 'package:flutter/material.dart';

import 'pages/challenge.dart';
import 'pages/login.dart';
import 'pages/register.dart';

void main() {
  runApp(MaterialApp(
    routes: {                                          
      'login': (context) => const Login(),
      'register': (context) => const Register(),
      'challenge': (context) => const Challenge(),
    },
    initialRoute: 'login',
  ));
}