import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class ChatMessage {
  final String username;
  final String text;
  final bool isSent;

  ChatMessage({
    required this.username,
    required this.text,
    required this.isSent,
  });

    // Method to convert ChatMessage to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'message': text,
    }; 
  }
    // Factory method to create a ChatMessage from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      username: json['username'],
      text: json['message'],
      isSent: false, // Default to false since this is for received messages
    );
  }
}


class _ChatScreenState extends State<ChatScreen> {
  late WebSocketChannel channel;
  final List<ChatMessage> messages = [];
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // Add FocusNode


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

      //final quotedMessage = data.replaceAll('"', '');
      // Decode the base64 message
      final message = jsonDecode(data);
      print('Json processed received: ${message['message']}');

      final receivedMessage = ChatMessage(
        username: message['username'],
        text: message['message'],
        isSent: false,
      );



      setState(() {
        messages.add(receivedMessage); // Add the decoded message to the list
      });
    }, onError: (error) {
      print('Error: $error');
    }, onDone: () {
      print('Connection closed');
    });
  }
  // Send a message to the WebSocket server
  void _sendMessage() {
      final sendMessage = ChatMessage(
        username: _usernameController.text,
        text: _messageController.text,
        isSent: true,
      );

    print('Message: ${sendMessage.text}');
    if (sendMessage.text.isNotEmpty) {
      final messageJson = jsonEncode(sendMessage.toJson());
      channel.sink.add(messageJson); // Send message to WebSocket server
      setState(() {
        messages.add(sendMessage); // Add the message to the local list
        _messageController.clear(); // Clear the input field
      });
    }
    // Request focus back to the input field
      _focusNode.requestFocus();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Expanded(child: 
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              ),
            ],)
          ),
        Expanded(
          child: ListView.builder(
    itemCount: messages.length,
    itemBuilder: (context, index) {
      bool isSent = false;

      return Align(
        alignment: messages[index].isSent ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(12.0),
          margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: isSent ? Colors.green[100] : Colors.blue[100],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
              bottomLeft: isSent ? Radius.circular(12.0) : Radius.zero,
              bottomRight: isSent ? Radius.zero : Radius.circular(12.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2),
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                messages[index].username ,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4.0), // Space between username and message
              Text(messages[index].text),
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
              children: [
                Expanded(
                  child: TextField(
                  controller: _messageController,
                  focusNode: _focusNode,
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