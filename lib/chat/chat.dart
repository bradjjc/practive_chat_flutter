import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_chat/model/message.dart';
import 'package:flutter_chat/model/user.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Chat extends StatefulWidget {
  final String userName;
  final String roomName;
  const Chat({super.key, required this.userName, required this.roomName});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late final IO.Socket socket;
  TextEditingController _controller = TextEditingController();
  List<Message> messages = [];
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void connectToServer() {
    socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.on('connect', (_) {
      print('Connected to server');
      socket.emit('joinRoom', {
        'username': widget.userName,
        'room': widget.roomName,
      });
    });

    socket.on('disconnect', (_) {
      print('Disconnected from server');
    });
    socket.on("roomUsers", (data) {
      log('data $data');
      if (data['users'] != null) {
        users = List<User>.from(data['users'].map((x) => User.fromJson(x)));
      }
    });

    socket.on('message', (msg) {
      log('message ${msg}');
      setState(() {
        messages.add(Message.fromJson(msg));
      });
    });
  }

  void sendMessage(String message) {
    socket.emit('chatMessage', message);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('체팅 테스트'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 8.0),
                  child: Container(
                    color: messages[index].name == widget.userName
                        ? Colors.green[100]
                        : Colors.blue[100],
                    child: Column(
                      children: [
                        SizedBox(
                            height: 20,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    messages[index].name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    messages[index].time,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 2,
                        ),
                        ListTile(
                          title: Text(messages[index].text),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      sendMessage(_controller.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
