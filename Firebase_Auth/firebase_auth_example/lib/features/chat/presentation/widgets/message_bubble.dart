import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final DateTime timestamp;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
        color: isMe ? Colors.teal : Colors.grey[300],
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
          minWidth: 100,
          minHeight: 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(message,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black,
              fontSize: 16.0,
            ),
            ),
            const SizedBox(height: 4.0),
            Text("${timestamp.hour}: ${timestamp.minute.toString().padLeft(2,"0")}",
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black,
              fontSize: 10.0,
            ),
            )
          ],
        ),
      )
    );
  }
}
