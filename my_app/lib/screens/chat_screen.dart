import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late WebSocketChannel channel;
  final List<String> messages = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState(){
    super.initState();
    connectToBackend();
  }

  @override
  void dispose() {
    channel.sink.close();
    _messageController.dispose();
    super.dispose();
  }

  void connectToBackend() {
    print("Connecting to Backend");
    channel = WebSocketChannel.connect(
        Uri.parse('wss://60820-3000.2.codesphere.com/backend/socket'),
        );

// Listen for incoming messages
    channel.stream.listen((data) {

      final quotedMessage = data.replaceAll('"', '');
      // Decode the base64 message
      final decodedMessage = utf8.decode(base64.decode(quotedMessage));
      print('Decoded message: $decodedMessage');
      final message = jsonDecode(decodedMessage);
      print('Json processed received: ${message['message']}');



      setState(() {
        messages.add(message['message']); // Add the decoded message to the list
      });
    }, onError: (error) {
      print('Error: $error');
    }, onDone: () {
      print('Connection closed');
    });
  }
  // Send a message to the WebSocket server
  void _sendMessage() {
    final message = _messageController.text;
    print('Message: $message');
    if (message.isNotEmpty) {
      final messageJson = jsonEncode({'message': message});
      channel.sink.add(messageJson); // Send message to WebSocket server
      setState(() {
        messages.add(message); // Add the message to the local list
        _messageController.clear(); // Clear the input field
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(messages[index]),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: 'Message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ]
            ),
          ),
        ]
      )
    );
  }
}