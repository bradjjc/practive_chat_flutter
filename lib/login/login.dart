import 'package:flutter/material.dart';
import 'package:flutter_chat/chat/chat.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<String> roomName = [
    "ROOM-1",
    "ROOM-2",
    "ROOM-3",
    "ROOM-4",
  ];
  String selectedRoom = "ROOM-1";
  TextEditingController _controllerName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('방 접속 하기'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              controller: _controllerName,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '사용하실 닉네임을 입력하세요',
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: DropdownButton(
              items: roomName
                  .map((e) => DropdownMenuItem(child: Text(e), value: e))
                  .toList(),
              value: selectedRoom,
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    selectedRoom = val;
                  });
                }
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Chat(
                    userName: _controllerName.text,
                    roomName: selectedRoom,
                  ),
                ),
              );
            },
            child: Text('입장하기'),
          ),
        ],
      ),
    );
  }
}
