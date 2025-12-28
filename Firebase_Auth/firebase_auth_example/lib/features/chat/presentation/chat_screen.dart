import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_example/core/utils/utils.dart';
import 'package:firebase_auth_example/features/chat/logic/chat_event.dart';
import 'package:firebase_auth_example/features/chat/presentation/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/chat_bloc.dart';
import '../logic/chat_state.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String receiverId;
  final String receiverName;
  const ChatScreen({
    super.key,
    required this.chatRoomId,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.teal),
            ),
            Text(widget.receiverName),
          ],
        ),
      ),
      body: Column(
        children: [
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is ChatLoading) {
                return CircularProgressIndicator();
              } else if (state is ChatLoaded) {
                return ListView.builder(
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    return MessageBubble(
                      message: message.message,
                      isMe: message.senderId == currentUserId,
                      timestamp: message.timestamp,
                    );
                  },
                );
              } else if (state is ChatError) {
                UiUtils.showError(context, state.error);
                return Text(state.error);
              } else {
                return Text('Something went wrong');
              }
            },
          ),
          _buildMessageInput()
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[100],
              ),
              enableSuggestions: true,
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.teal.withOpacity(0.7),
            child: IconButton(
              onPressed: () {
                if (_messageController.text.isNotEmpty) {
                  context.read<ChatBloc>().add(
                    SendMessageEvent(
                      chatRoomId: widget.chatRoomId,
                      message: _messageController.text.trim(),
                      senderId: currentUserId,
                      receiverId: widget.receiverId,
                      timestamp: DateTime.now(),
                    ),
                  );
                  _messageController.clear();
                }
              },
              icon: Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
