import 'package:flutter/material.dart';  //เป็นการเรียกใช้สไตล์เลเอ้าของหน้าจอ เฉดสีต่างๆ ใช้ควบคุมการแสดงผล//




void main() { //เริ่มต้นโปรแกรมต้องมีเสมอ//
  runApp(const MyApp());    //จบด้วย; และจะมี widget ใน (app)อยู่ //
}
//ทั้งก้อนด้านล่างพิมพ์ Stl อยู่นิ่งๆไม่ทำอะไร//
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(     //const คือ ค่าคงที่//
      home: Shades(),
    );
  }
}
//ทั้งก้อนนี้พิมพ์ Stf เปลี่ยนแปลงหน้าตาเมื่อ state เปลี่ยนจึงจะวาดหน้าจอใหม่//
class Shades extends StatefulWidget {
  const Shades({super.key});

  @override
  State<Shades> createState() => _ShadesState();
}

class _ShadesState extends State<Shades> {
  int _shades = 10000;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(            //กำหนดว่าหากมีอะไรเกิดขึ้นต้องทำยังไงบ้าง//
      onTapDown: (details){  //เหตุการเมื่อกดคลิ๊ก///
        setState((){
          _paint(context, details);
         
        });
      },
      onVerticalDragUpdate: (details) { //เหตุการเมื่อเราลากเเล้วเลื่อน//
      setState((){
          _paint(context, details);
         
        });
      }, 
      child: Scaffold(
      backgroundColor: Color(0XFF000000+ _shades),
      ),
    );
  
  }
  void _paint(context, details){
    double maxScr =MediaQuery.of(context).size.height;
          double yPos = details.globalPosition.dy; 
        _shades = (yPos / maxScr * 16777215 ).round();
        if(_shades > 16777215) _shades = 16777215;
       // print(_shades);//
  }

}
