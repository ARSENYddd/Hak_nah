// lib/screens/chat/chat_room_screen.dart
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatRoomScreen extends StatefulWidget {
  final String roomName;
  final int userId;
  final int firstUserId;
  final int secondUserId;

  const ChatRoomScreen({
    Key? key,
    required this.roomName,
    required this.userId,
    required this.firstUserId,
    required this.secondUserId,
  }) : super(key: key);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  late final WebSocketChannel _channel;
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    // Подключение к вашему серверу WebSocket
    _channel = IOWebSocketChannel.connect('ws://213.226.126.164:8000/fitness_messages/ws/${widget.userId}');
    _channel.stream.listen((message) {
      setState(() {
        _messages.add(message);
      });
    });

    // Получение истории сообщений
    _fetchChatHistory();
  }

  Future<void> _fetchChatHistory() async {
    final url = 'http://213.226.126.164:8000/chats/history?first_user_id=${widget.firstUserId}&second_user_id=${widget.secondUserId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> messageData = jsonDecode(response.body);
      setState(() {
        _messages.addAll(messageData.map((msg) => msg['message'].toString()).toList());
      });
    } else {
      // Обработка ошибки
      print('Failed to load chat history');
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text); // Отправка сообщения на сервер
      _controller.clear();
    }
  }

  void _sendCustomMessage(String message) {
    _channel.sink.add(message);
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.fitness_center),
            title: Text('Отправить упражнение'),
            onTap: () {
              _sendCustomMessage('Отправить упражнение');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.directions_run),
            title: Text('Отправить тренировку'),
            onTap: () {
              _sendCustomMessage('Отправить тренировку');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.restaurant_menu),
            title: Text('Отправить рецепт'),
            onTap: () {
              _sendCustomMessage('Отправить рецепт');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close(); // Закрытие WebSocket соединения при уничтожении виджета
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_messages[index]),
                  );
                },
              ),
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _showAttachmentOptions,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Отправить сообщение',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
