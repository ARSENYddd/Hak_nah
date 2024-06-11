// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/io.dart';
//
//
//
//
// class ChatListScreen extends StatelessWidget {
//   final List<String> chatRooms = ['Chat 1', 'Chat 2', 'Chat 3'];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Чаты'),
//       ),
//       body: ListView.builder(
//         itemCount: chatRooms.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(chatRooms[index]),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ChatRoomScreen(roomName: chatRooms[index]),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// class ChatRoomScreen extends StatefulWidget {
//   final String roomName;
//
//   const ChatRoomScreen({Key? key, required this.roomName}) : super(key: key);
//
//   @override
//   _ChatRoomScreenState createState() => _ChatRoomScreenState();
// }
//
// class _ChatRoomScreenState extends State<ChatRoomScreen> {
//   final TextEditingController _controller = TextEditingController();
//   late final WebSocketChannel _channel;
//
//   final List<String> _messages = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _channel = IOWebSocketChannel.connect('ws://localhost:8000/ws/${widget.roomName}');
//     _channel.stream.listen((message) {
//       setState(() {
//         _messages.add(message);
//       });
//     });
//   }
//
//   void _sendMessage() {
//     if (_controller.text.isNotEmpty) {
//       _channel.sink.add('User: ${_controller.text}');
//       _controller.clear();
//     }
//   }
//
//   @override
//   void dispose() {
//     _channel.sink.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.roomName),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _messages.length,
//                 itemBuilder: (context, index) {
//                   final message = _messages[index];
//                   return ListTile(
//                     title: Text(message != null ? message : ''),
//                   );
//                 },
//               ),
//             ),
//             Row(
//               children: <Widget>[
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       labelText: 'Отправить сообщение',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
