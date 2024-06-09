import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Длина установлена на 3, чтобы соответствовать количеству чатов
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Чаты'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Chat 1'),
            Tab(text: 'Chat 2'),
            Tab(text: 'Chat 3'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Действие при нажатии на кнопку "Вход"
            },
            icon: Icon(Icons.login),
          ),
          IconButton(
            onPressed: () {
              // Действие при нажатии на кнопку "Регистрация"
            },
            icon: Icon(Icons.app_registration),
          ),
          IconButton(
            onPressed: () {
              // Действие при нажатии на кнопку "Профиль"
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ChatRoom(roomName: 'Chat 1'), // Добавляем ChatRoom для каждого чата
          ChatRoom(roomName: 'Chat 2'),
          ChatRoom(roomName: 'Chat 3'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class ChatRoom extends StatefulWidget {
  final String roomName;

  const ChatRoom({Key? key, required this.roomName}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _controller = TextEditingController();
  late final WebSocketChannel _channel;

  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _channel = IOWebSocketChannel.connect('ws://localhost:8000/ws/${widget.roomName}');
    _channel.stream.listen((message) {
      setState(() {
        _messages.add(message);
      });
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add('User: ${_controller.text}');
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
