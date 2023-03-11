import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {
  final String id;
  const ChatMessage({Key? key,required this.id}) : super(key: key);

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Chat Messages' +  widget.id),
      ),
    );
  }
}
