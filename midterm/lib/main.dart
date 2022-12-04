import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: const Scaffold(
      body: MyPanel(),
    ),
    theme: ThemeData(
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold
        )
      )
    ),
  ));
}

class MyPanel extends StatefulWidget {
  const MyPanel({super.key});

  @override
  State<MyPanel> createState() => _MyPanelState();
}

class _MyPanelState extends State<MyPanel> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
        body: Container(
        
          constraints: const BoxConstraints.expand(), 
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('images/bg.webp'),
                fit: BoxFit.cover
              )
            ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
        ), 

      ),
    );
  }
}

// child: Icon(Icons.remove)