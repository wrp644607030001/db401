import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/models/request.dart';

import 'game.dart';

class Challenge extends StatefulWidget {
  const Challenge({super.key});

  @override
  State<Challenge> createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {
  late String _playerName;
  late CollectionReference _games;
  List<Request> _challenges = [];

 void startGame(String gameId) {
   _games.doc(gameId).update({
     'player_x': _playerName,
     'status': 'P',
   }).whenComplete(
     () => Navigator.pushReplacement(
       context, 
       MaterialPageRoute(builder: (context) => Game(id: gameId)))
   );
 }

 @override
 void initState() {
   _playerName = FirebaseAuth.instance.currentUser!.email!;
   _playerName = _playerName.substring(0, _playerName.length - 14);
   _games = FirebaseFirestore.instance.collection('games');
   _games.where('status', isEqualTo: 'C')
   .where('player_o', isNotEqualTo: _playerName)
   .get().then((value) {
     setState(() {
       _challenges = [
         for(var doc in value.docs) Request(
           gameId: doc.id, 
           challenger: doc['player_o'], 
           onAccept: startGame,
         )
       ];
     });
   });
   super.initState();
 }

void gotologin() {
  Navigator.pushReplacementNamed(context, 'login');
}

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: _games.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        QuerySnapshot data = snapshot.requireData;
        _challenges = [
          for (DocumentSnapshot doc in data.docs) 
            if (doc['status'] == 'C' && doc['player_o'] != _playerName) 
              Request(
                gameId: doc.id, 
                challenger: doc['player_o'], 
                onAccept: startGame,
              )
        ];
        return Scaffold(
          appBar: AppBar(
            title: const Text('All Challenges'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout), 
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  gotologin();
                }
              )
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Welcome $_playerName', style: const TextStyle(fontSize: 24),),
              ),
              Expanded(
                child: ListView(
                  children: _challenges.isNotEmpty ? ListTile.divideTiles(context: context, tiles: _challenges).toList() : [],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _games.add({
                    'start': FieldValue.serverTimestamp(),
                    'player_o': _playerName,
                    'filled': '_________',
                    'status': 'C',
                    'turn': Random().nextBool() ? 'O' : 'X',
                  }).then(
                    (value) => Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (context) => Game(id: value.id))
                    )
                  );
                }, 
                child: const Text('New Game'),
              ),
            ],
          ),
        );
      }
    );
  }
}