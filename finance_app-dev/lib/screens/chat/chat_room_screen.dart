import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:finance_app/screens/showcase/coaches_screen.dart';
import 'package:collection/collection.dart';

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
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    // Подключение к вашему серверу WebSocket
    _channel = IOWebSocketChannel.connect('ws://213.226.126.164:8000/fitness_messages/ws/${widget.userId}');
    _channel.stream.listen((message) {
      final data = jsonDecode(message);
      setState(() {
        _messages.add(data);
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
        _messages.addAll(messageData.map((msg) => msg as Map<String, dynamic>).toList());
      });
    } else {
      // Обработка ошибки
      print('Failed to load chat history');
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty && _controller.text != 'null') {
      final messageText = _controller.text;
      final message = {
        "sender_id": widget.userId,
        "receiver_id": widget.secondUserId,
        "message_text": messageText,
        "timestamp": DateTime.now().toString(),
      };
      _channel.sink.add(jsonEncode(message));
      setState(() {
        _messages.add(message);
      });
      _controller.clear();
    }
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

  void _sendCustomMessage(String message) {
    final customMessage = {
      "sender_id": widget.userId,
      "receiver_id": widget.secondUserId,
      "message_text": message
    };
    _channel.sink.add(jsonEncode(customMessage));
    setState(() {
      _messages.add(customMessage);
    });
  }

  Future<List<Coach>> fetchCoaches() async {
    final response = await http.get(Uri.parse('https://kualsoft.ru/fitness/public/coach/all'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes)); // Декодирование UTF-8
      return jsonResponse.map((coach) => Coach.fromJson(coach)).toList();
    } else {
      throw Exception('Failed to load coaches');
    }
  }


  void _navigateToProfile() async {
    final coaches = await fetchCoaches();
    print(coaches);
    final selectedCoach = coaches.firstWhere((c) => c.id == widget.userId);
    if (selectedCoach != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CoachDetailsScreen(coach: selectedCoach),
        ),
      );
    } else {
      print('Selected coach is null');
    }
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
        title: GestureDetector(
          onTap: _navigateToProfile,
          child: Text(widget.roomName),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isCurrentUser = message['sender_id'] == widget.userId;

                  return Align(
                    alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: isCurrentUser ? Colors.purple[100] : Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: isCurrentUser ? Colors.purple : Colors.grey),
                      ),
                      child: Text(
                        "${message['sender_id']}: ${message['message_text']}",
                        style: TextStyle(
                          color: isCurrentUser ? Colors.black : Colors.black,
                        ),
                      ),
                    ),
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
