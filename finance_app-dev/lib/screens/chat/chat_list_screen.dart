// lib/screens/chat/chat_list_screen.dart
import 'package:flutter/material.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список чатов'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Chat 1'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoomScreen(
                    roomName: 'Chat 1',
                    userId: 1, // ваш userId для WebSocket
                    firstUserId: 1,
                    secondUserId: 2,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Chat 2'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoomScreen(
                    roomName: 'Chat 2',
                    userId: 2, // ваш userId для WebSocket
                    firstUserId: 2,
                    secondUserId: 1,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Chat 3'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoomScreen(
                    roomName: 'Chat 3',
                    userId: 1, // ваш userId для WebSocket
                    firstUserId: 1,
                    secondUserId: 4,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
