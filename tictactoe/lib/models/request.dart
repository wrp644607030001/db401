import 'package:flutter/material.dart';

class Request extends StatelessWidget {
  final String gameId;              // final จะมีค่าได้ต้องผ่าน constructor *บังคับ*
  final String challenger;
  final Function onAccept;

  const Request({                   // constructor
    required this.gameId, 
    required this.challenger, 
    required this.onAccept,
    super.key
  });

  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Text(challenger),      // challenger ชื่อคนท้า
      trailing: ElevatedButton(     // ElevatedButton คือ กดปุ่มแล้วไป onAccept เข้าเกมที่มีคนท้าเอาไว้
        onPressed: () => onAccept(gameId), 
        child: const Text('Accept')
      ),
    );
  }
}