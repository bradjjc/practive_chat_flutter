import 'package:flutter/material.dart';
import 'package:flutter_chat/login/login.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:developer';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '체팅 테스트',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
      // home: ChatPage(),
    );
  }
}
