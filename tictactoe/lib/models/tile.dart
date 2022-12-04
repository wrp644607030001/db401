import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final int row;                  // final จะมีค่าได้ต้องผ่าน constructor *บังคับ*
  final int col;
  final String value;
  final Function onTap;

  const Tile({                    // constructor
    required this.row, 
    required this.col,  
    required this.value, 
    required this.onTap, 
    super.key
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(                 // GestureDetector คือ จับการ tap แตะ 
      onTap: () => onTap(row, col),
      child: Container(
        width: 92,
        height: 92,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          value == '_' ? ' ' : value,         //  _ คือ ค่าว่าง
          style: const TextStyle(fontSize: 72),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}