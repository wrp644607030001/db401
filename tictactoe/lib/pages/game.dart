import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/tile.dart';

class Game extends StatefulWidget {
  final String id;

  const Game({required this.id, super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  bool _done = false;     // มีค่าเป็น true - false 
  String _symbol = '_';   // เริ่มต้น ว่าง
  String _status = 'C';   // C: challenge, P: playing, D: draw, O: O win, X: X win ,เกมที่รอเล่น status=C
  bool _isTurn = false;
  List<List<String>> _filled = [
    ['_', '_', '_'],      // ตาราง 9 ช่อง
    ['_', '_', '_'],
    ['_', '_', '_'],
  ];
  late DocumentReference _game;   // _game ดึงมาจาก fileStore

  String _gameTitle() {
    if(_done) {
      if(_status == 'D') {
        return 'Draw';
      } else if(_status == _symbol) {
        return 'You win';
      } else {
        return 'You lose';
      }
    } else {
      return 'You are $_symbol';
    }
  }

  Color _gameBackground() {
    if(_status == 'D') {
      return Colors.yellow;
    } else if(_status == 'P' || _status == 'C') {
      return Colors.blueGrey;
    } else if(_status == _symbol) {
      return Colors.green;      // ถ้าชนะ เขียว
    }
    return Colors.red;        // ถ้าแพ้ แดง
  }

  bool _winByRow() {      // _winByRow คือ ชนะแบบแถวรึเปล่า?
    for (var row in _filled) {
      var players = <String>{...row};     // ... จุดสามจด คือ กระจาย
      if (players.length == 1 && players.first == _symbol) {    // players.length == 1 ถ้าเหลือตัวเดียว เป็น true ชนะ, ถ้าไม่ใช่ return false แพ้ 
        return true;
      }
    }
    return false;
  }

  bool _winByColumn() {      // _winByColumn คือ ชนะแบบดูตามคอลัมน์
    for (var col = 0; col < 3; col++) {
      var players = <String>{for (var row in [0,1,2]) _filled[row][col]};   // ฟิกคอลัมน์ วนไปทุกแถว 0,1,2
      if (players.length == 1 && players.first == _symbol) {
        return true;
      }
    }
    return false;
  }

  bool _winByDiagonal() {     // _winByDiagonal คือ ชนะแบบเส้นทแยงมุม
    var listOfPlayers = <Set<String>>[];
    listOfPlayers.add({_filled[0][0],_filled[1][1],_filled[2][2]});
    listOfPlayers.add({_filled[0][2],_filled[1][1],_filled[2][0]});
    for (var players in listOfPlayers) {
      if (players.length == 1 && players.first == _symbol) {
        return true;
      }
    }
    return false;
  }

  void _checkResult(int row, int col) {
    if(!_done && _isTurn) {
      setState(() {         // setState คือ วาดหน้าจอใหม่, และวาด X : O
        _isTurn = false;
        _filled[row][col] = _symbol;
        String filledString = _filled[0].join('') + _filled[1].join('') + _filled[2].join('');
        if(_winByRow() || _winByColumn() || _winByDiagonal()) {     // ถ้าตัวใดตัวหนุ่งเป็นจริงก็ชนะได้เลย
          _game.update({'filled': filledString, 'status': _symbol});
        } else {
          if(filledString.contains('_')) {      // ถ้ามี _ คือ เกมยังไม่จบ
            _game.update({'filled': filledString, 'turn': _symbol == 'O' ? 'X' : 'O'});     // ถ้าเรา O ฝ่ายตรงข้ามคือ X
          } else {
            _game.update({'filled': filledString, 'status': 'D'});    // ถ้าช่องเต็มหมดไม่มีใครชนะ คือ เสมอ
          }
        }
      });
    }
  }

  @override
  void initState() {        // เป็นตัวเช็คว่าเรา login แล้วหรือยัง
    String playerName = FirebaseAuth.instance.currentUser!.email!;      // เอา email ไปเก้บไว้ใน playerName 
    playerName = playerName.substring(0, playerName.length - 14);       // เอาชื่อตัด หลัง @ ออก 
    _game = FirebaseFirestore.instance.collection('games').doc(widget.id);    // 
    _game.get().then((value) {
      setState(() {
        _symbol = playerName == value['player_o'] ? 'O' : 'X';    // คนสร้างห้อง O คนเล่นด้วย X
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void gotoChallenge() {
      Navigator.pushReplacementNamed(context, 'challenge');
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: _game.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {      // ถ้า snapshot ส่งมามีค่า hasData จะเป็น true ถ้าไม่มี เป็น False
          return const Center(child: CircularProgressIndicator());
        }
        DocumentSnapshot data = snapshot.requireData;   // requireData คือ DATA ที่ส่งมา
        _isTurn = data['turn'] == _symbol;
        String filledString = data['filled'];
        _filled = [
          filledString.substring(0, 3).split(''),   // split คือ แยกออกจากกัน
          filledString.substring(3, 6).split(''),
          filledString.substring(6).split(''),
        ];
        _status = data['status'];
        _done = 'DOX'.contains(_status);
        return Scaffold(
          backgroundColor: _gameBackground(),
          appBar: AppBar(
            title: const Text('Tic-Tac-Toe'),
            actions: [
              IconButton(  
                icon: Icon(_done ? Icons.table_rows : Icons.flag),  // flag คือ ธงขาว ยอมแพ้
                onPressed: () async {
                  if(!_done) {
                    await _game.update({
                      'status': _symbol == 'O' ? 'X' : 'O',
                    });
                  }
                  gotoChallenge();
                }
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _gameTitle(),
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ), 
              ),
              const SizedBox(height: 24,),
              Text(
                _isTurn ? 'Your turn' : 'Opponent',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.red.shade900,
                ),
              ),
              const SizedBox(height: 12,),
              Row(    //ROW เรียงตมแนวนอน
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tile(row: 0, col: 0, value: _filled[0][0], onTap: _checkResult),
                  Tile(row: 0, col: 1, value: _filled[0][1], onTap: _checkResult),
                  Tile(row: 0, col: 2, value: _filled[0][2], onTap: _checkResult),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tile(row: 1, col: 0, value: _filled[1][0], onTap: _checkResult),
                  Tile(row: 1, col: 1, value: _filled[1][1], onTap: _checkResult),
                  Tile(row: 1, col: 2, value: _filled[1][2], onTap: _checkResult),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tile(row: 2, col: 0, value: _filled[2][0], onTap: _checkResult),
                  Tile(row: 2, col: 1, value: _filled[2][1], onTap: _checkResult),
                  Tile(row: 2, col: 2, value: _filled[2][2], onTap: _checkResult),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}