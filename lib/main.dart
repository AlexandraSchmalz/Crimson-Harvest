import 'package:crimson_harvest/calendar.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Aehm",
      home: Calendar(),
    );
  }
}