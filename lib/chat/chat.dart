import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_chat/model/message.dart';
import 'package:flutter_chat/model/user.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

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
  void dispose() {
    super.dispose();
    socket.disconnected;
    socket.dispose();
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
              shrinkWrap: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(
                      left: 14, right: 14, top: 4, bottom: 4),
                  child: Align(
                    alignment: messages[index].name == widget.userName
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (messages[index].name == widget.userName)
                          Text(
                            DateFormat('hh:mm a')
                                // DateFormat('yy/MM/dd - hh:mm a')
                                .format(DateTime.parse(messages[index].time)),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (messages[index].name == widget.userName
                                ? Colors.grey.shade200
                                : Colors.blue[200]),
                          ),
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width * 0.4,
                          ),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                messages[index].name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                messages[index].text,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (messages[index].name != widget.userName)
                          Text(
                            DateFormat('hh:mm a')
                                // DateFormat('yy/MM/dd - hh:mm a')
                                .format(DateTime.parse(messages[index].time)),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
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
