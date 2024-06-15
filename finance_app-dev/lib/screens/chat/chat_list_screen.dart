// chat_list_screen.dart
import 'package:flutter/material.dart';// Путь к вашей модели для чата
import 'chat_room_screen.dart';
// chat_model.dart
class Chat {
  final int id;
  final String name;
  final int firstUserId;
  final int secondUserId;

  Chat({
    required this.id,
    required this.name,
    required this.firstUserId,
    required this.secondUserId,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as int,
      name: json['name'] as String,
      firstUserId: json['first_user_id'] as int,
      secondUserId: json['second_user_id'] as int,
    );
  }
}

class ChatListScreen extends StatelessWidget {
  final int userId;
  final List<Chat> chats;

  const ChatListScreen({Key? key, required this.userId, required this.chats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _navigateToChat(Chat chat) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatRoomScreen(
            roomName: chat.name,
            userId: userId,
            firstUserId: chat.firstUserId,
            secondUserId: chat.secondUserId,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Список чатов'),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return GestureDetector(
            onTap: () => _navigateToChat(chat),
            child: ListTile(
              title: Text(chat.name),
            ),
          );
        },
      ),
    );
  }
}
