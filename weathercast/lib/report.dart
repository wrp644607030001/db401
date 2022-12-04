import 'package:flutter/material.dart';
import 'package:weathercast/weather.dart';

import 'forecast.dart';
import 'weather.dart';


class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {          // เครื่องหมาย _ แปลว่า ใช้ได้ภายใน class นี้เท่านั้น
  Weather? _weather;                                 // สร้างตัวแปรไว้เก็บค่า Weather , เครื่องหมาย ? แปลว่า ค่าว่าง 
  @override
  void initState() {
    updateReport();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const Text(
          'สภาพอากาศวันนี้',
          style: TextStyle(
            fontSize: 36, 
            fontWeight: FontWeight.bold, 
            color: Colors.white
          ),
        ),
          Container(
              constraints: _weather == null ? const BoxConstraints.tightFor(
              width: 150, 
              height: 150
            ) : null,
            decoration: BoxDecoration(
              color: Colors.blueAccent.shade700.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10)
            ),
              margin: const EdgeInsets.symmetric(vertical: 30),
              padding: const EdgeInsets.all(20),
              child: _weather == null ? null : Column(
                children: [
                  Text(
                    _weather!.address,                                      // เครื่องหมาย ! แปลว่า มีค่าแน่นอน ไม่ว่าง
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,           // ตกแต่ง
                  ),
                  const SizedBox(height: 20,),
                  Text(
                    '${_weather!.temperature}℃',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(height: 20,),
                  Text(
                    _weather!.condition,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(height: 20,),
                  Text(
                    _weather!.symbol,
                    style: const TextStyle(fontSize: 72),
                  ),
                ]
              )
                
          ),
          ElevatedButton(
            onPressed: () {
              updateReport();
            }, 
            child: const Text('Refresh')
          )
      ],
    );
  }

  void updateReport() {
    forecast().then((weather) {             // ภายใน updateReport เรียกใช้ forecast
      setState(() {                         // สั่งให้มีการเปลี่ยน state โดยเอาผลลัพธ์ที่ได้ไปเก็บไว้ใน ตัวแปร _weather ของ state
        _weather = weather;                 
      });
      ScaffoldMessenger.of(context).removeCurrentSnackBar();     // ถ้ามี SnackBar ก็จะลบทิ้ง
    })
    .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(                                               // SnackBar คือ ข้อความที่ปรากฏด้านล่าง
          content: Text(error.toString()),
          duration: const Duration(days: 1),                    // แสดง SnackBar 1 วัน 
        )
      );            
    });
  }
}
