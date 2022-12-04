import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String _playername;            // late บอกไว้ว่าจะมาค่าที่หลัง ณ ตอนนี้ยังไม่กำหนดว่าคืออะไร
  late String _password;
  bool _ready = false;

  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() {        // เรียกใช้ Firebase core เพ่อให้ติดต่อ Firebase
      setState(() {
        _ready = true;      // ถ้าติดต่อได้ให้เป็น true วาดหน้าจอใหม่
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void gotoChallenge() {
      Navigator.pushReplacementNamed(context, 'challenge');     // เปลี่ยนหน้าโดยคำสั่ง pushReplacementNamed ล็อกอินผ่านไปหน้า challenge(อ้างจากหน้าmain)
    }

return Scaffold(
  body: Center(
    child: SingleChildScrollView(                   // SingleChildScrollView ถ้าพื้นที่ไม่พอใช้คำสั้่งนี้
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset('images/logo.png', height: 100,),
          const SizedBox(height: 48,),
          TextField(                                // TextField คือกล่องข้อความ ที่พิมพ์ข้อความไปได้
            onChanged: (value) {                    // onChanged  - value ที่่ด้จากการพิมพ์ไปเก็บไว้ใน _playername
              _playername = value;
            },
            keyboardType: TextInputType.name,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Enter your player name',
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.blueAccent, 
                  width: 1
                ),
                borderRadius: BorderRadius.circular(30)
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10, 
                horizontal: 20
              ),
            ),
          ),
          const SizedBox(height: 8,),
          TextField(
            onChanged: (value) {
              _password = value;
            },
            obscureText: true,        // obscureText คือถ้าเป็น true คือปิดข้อความเช่น * ปิด passwprd
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.blueAccent, 
                  width: 1
                ),
                borderRadius: BorderRadius.circular(30)
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10, 
                horizontal: 20
              ),
            ),
          ),
          const SizedBox(height: 24,),
          ElevatedButton(
            onPressed: _ready ? () async {
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: '$_playername@tictactoe.com',
                  password: _password
                );
                gotoChallenge();        // ถ้าผ่าน gotoChallenge();  
              } on FirebaseAuthException catch (e) {      // ถ้าไม่ผ่าน แสดง error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.code),
                    duration: const Duration(seconds: 10),
                  )
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    duration: const Duration(seconds: 10),
                  )
                );
              }
            } : null, 
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder()      // รูปแบบปุ่ม สนามบอล
            ),
            child: const Text('Log In'),
          ),
          const SizedBox(height: 8),
          TextButton(                       // TextButton คือ ปุ่ม
            onPressed: _ready 
            ? () => Navigator.pushNamed(context, 'register')    // ถ้าเป็น true ทำหลัง ?
            : null,                                             // ถ้าเป็น faise ทำหลัง :
            child: const Text('New Player Click Here!'),
          )
        ],
      ),
    ),
  ),
);
  }
}