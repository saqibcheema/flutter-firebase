import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../data/models/chatScreenArguments_model.dart';
import '../data/models/message_model.dart';
import '../logic/chat_bloc.dart';
import '../logic/chat_event.dart';
import '../logic/chat_state.dart';

class ChatScreen extends StatefulWidget {
  final ChatScreenArguments args;


  const ChatScreen({
    super.key,
    required this.args
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(
      GetMessageEvent(chatRoomId: widget.args.chatRoomId),
    );
  }

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;

    context.read<ChatBloc>().add(
      SendMessageEvent(
        chatRoomId: widget.args.chatRoomId,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        receiverId: widget.args.receiverId,
        message: _msgController.text.trim(),
        timestamp: DateTime.now(),
      ),
    );
    _msgController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(onPressed: (){
                    context.pop();
                  }, icon: Icon(Icons.arrow_back_ios)),
                  CircleAvatar(
                    backgroundColor: Colors.teal,
                    backgroundImage: NetworkImage(widget.args.receiverProfilePic),
                  ),
                  const SizedBox(width: 8),
                  Text(widget.args.receiverName),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.videocam),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.call),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: Colors.teal,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
      
                  if (state is ChatLoaded) {
                    return ListView.builder(
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final msg = state.messages[index];
                        final isMe = msg.senderId == currentUserId;
      
                        return _buildMessageBubble(context, msg, isMe);
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            // Input Area
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 20),
                    child: _buildTextForm(context),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                      shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.teal,
                      width: 2.0
                    )
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.teal),
                    onPressed: _sendMessage,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, MessageModel msg, bool isMe){
    return Align(
      alignment: isMe
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.teal : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Text(
          msg.message,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildTextForm(BuildContext context) {
    return TextField(
      cursorColor: Colors.teal,
      controller: _msgController,
      decoration: const InputDecoration(
        hintText: "Type a message...",
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        focusColor: Colors.teal,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
      ),
    );
  }
}
